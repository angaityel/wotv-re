-- chunkname: @scripts/managers/persistence/persistence_manager_client.lua

require("scripts/managers/persistence/persistence_manager_common")
require("scripts/settings/dlc_settings")
require("scripts/settings/ranks")

PersistenceManagerClient = class(PersistenceManagerClient, PersistenceManagerCommon)

function PersistenceManagerClient:init(settings)
	PersistenceManagerClient.super.init(self)
	fassert(settings, "No backend settings supplied")

	self._settings = settings
	self._profile_id = -1
end

function PersistenceManagerClient:connect(connect_callback)
	if Managers.backend:connected() and self._profile_id ~= -1 then
		print("Already connected to backend...")
		connect_callback()
	else
		print("[Backend] Connecting to", self._settings.connection.address)

		self._connect_callback = connect_callback

		local callback = callback(self, "cb_connected")

		self.backend_connect_try_count = (self.backend_connect_try_count or 0) + 1

		local timeout_duration

		timeout_duration = self.backend_connect_try_count < 10 and 10 or 30

		Managers.backend:connect(self._settings.connection.address, Steam.app_id(), Backend.CLIENT, self._settings.connection.port, self._settings.connection.interface, callback, Managers.time:time("main") + timeout_duration)
	end
end

function PersistenceManagerClient:cb_connected(response)
	if response.error == nil then
		self.backend_connect_try_count = 0

		print("[Backend] Authenticating...")
		Managers.backend:steam_login(callback(self, "cb_authenticated"))
	elseif self.backend_connect_try_count < 10 then
		printf("Backed connection failed '%s', retrying #%d", response.error, self.backend_connect_try_count)
		self:connect(self._connect_callback)
	else
		print("Error (cb_connected)", response.error)
		self._connect_callback(response.error)
	end
end

local function create_profile(callback)
	local profile_attributes_to_save = {}

	for stat_name, stat_props in pairs(StatsContexts.player) do
		if stat_props.backend.save and stat_props.type ~= "compound" then
			profile_attributes_to_save[stat_name] = tostring(stat_props.value)
		end
	end

	print("Creating profile...")
	Managers.backend:create_profile(Steam.user_id(), nil, profile_attributes_to_save, callback)
end

function PersistenceManagerClient:cb_authenticated(response)
	if response.error == nil then
		if response.profiles == nil then
			create_profile(callback(self, "cb_profile_created"))
		elseif self._settings.reset_profile == true then
			local _, profile = next(response.profiles)

			print("Resetting profile...", profile.id)
			Managers.backend:drop_profile(profile.id, callback(self, "cb_profile_dropped"))
		else
			local _, profile = next(response.profiles)

			print("Selecting profile...", profile.id)
			Managers.backend:select_profile(profile.id, callback(self, "cb_profile_selected"))
		end
	else
		print("Error (cb_authenticated)", response.error)
		self._connect_callback(response.error)
	end
end

function PersistenceManagerClient:cb_profile_dropped(response)
	if response.error == nil then
		create_profile(callback(self, "cb_profile_created"))
	else
		print("Error (cb_profile_dropped)", response.error)
		self._connect_callback(response.error)
	end
end

function PersistenceManagerClient:cb_profile_created(response)
	if response.error == nil then
		print("Selecting profile...")
		Managers.backend:select_profile(response.profile.id, callback(self, "cb_profile_selected"))
	else
		print("Error (cb_profile_created)", response.error)
		self._connect_callback(response.error)
	end
end

function PersistenceManagerClient:cb_profile_selected(response)
	if response.error == nil then
		self._profile_id = response.profile.id

		print("Fetching entity types...")
		Managers.backend:get_entity_types(callback(self, "cb_entity_types_fetched"))
	else
		print("Error (cb_profile_selected)", response.error)
		self._connect_callback(response.error)
	end
end

function PersistenceManagerClient:cb_entity_types_fetched(response)
	if response.error == nil then
		print("Parsing entity types...")
		self:_parse_entity_types(response.entity_types or {})
		print("Backend setup successfully!")
		self._connect_callback()
	else
		print("Error (cb_entity_types_fetched)", response.error)
		self._connect_callback(response.error)
	end
end

function PersistenceManagerClient:profile_id()
	return self._profile_id
end

function PersistenceManagerClient:load_profile(profile_callback)
	print("Loading profile...")

	self._profile_callback = profile_callback
	self._profile_data = {
		attributes = {},
		entities = {},
		stats = {}
	}

	Managers.backend:get_profile_attributes(self._profile_id, callback(self, "cb_profile_attributes_fetched"))
end

function PersistenceManagerClient:cb_profile_attributes_fetched(response)
	if response.error == nil then
		print("Profile attributes fetched!")

		self._profile_data.attributes = self:_parse_profile_attributes(response.attributes or {})

		Managers.backend:get_entities(self._profile_id, callback(self, "cb_profile_entities_fetched"))
	else
		print("Error fetching profile attributes...", response.error)

		self._profile_data = nil

		self._profile_callback()
	end
end

function PersistenceManagerClient:cb_profile_entities_fetched(response)
	if response.error == nil then
		print("Profile entities fetched!")

		self._profile_data.entities = self:_parse_profile_entities(response.entities or {})

		self:_synchronize_unlocks(self._profile_data.attributes.rank or 0)
		self:_synchronize_coin_dlcs()
	else
		print("Error fetching profile entities...", response.error)

		self._profile_data = nil

		self._profile_callback()
	end
end

function PersistenceManagerClient:_synchronize_coin_dlcs()
	local profile_attribs = {}
	local coins = 0

	if not self._profile_data.attributes.coins_unlocked_coins_gift and DLCSettings.coins_gift() then
		profile_attribs.coins_unlocked_coins_gift = {
			[Backend.PROFILE_ATTRIBUTE_SET] = tostring(true)
		}
		coins = coins + 1000
	end

	if not self._profile_data.attributes.coins_unlocked_coins_gift_2 and DLCSettings.coins_gift() then
		profile_attribs.coins_unlocked_coins_gift_2 = {
			[Backend.PROFILE_ATTRIBUTE_SET] = tostring(true)
		}
		coins = coins + 4000
	end

	if not self._profile_data.attributes.coins_unlocked_coins_retail_bonus and DLCSettings.coins_retail_bonus() then
		profile_attribs.coins_unlocked_coins_retail_bonus = {
			[Backend.PROFILE_ATTRIBUTE_SET] = tostring(true)
		}
		coins = coins + 2000
	end

	if not self._profile_data.attributes.coins_unlocked_blood_eagle and DLCSettings.beagle() then
		profile_attribs.coins_unlocked_blood_eagle = {
			[Backend.PROFILE_ATTRIBUTE_SET] = tostring(true)
		}
		coins = coins + 10000
	end

	if table.size(profile_attribs) > 0 then
		profile_attribs.coins = {
			[Backend.PROFILE_ATTRIBUTE_INC] = coins
		}

		table.dump(profile_attribs, "Coins unlocked", 1)
		Managers.backend:update_profile_attributes(self._profile_id, profile_attribs, callback(self, "cb_coin_dlcs"))
	else
		self:_finalize_profile_load()
	end
end

function PersistenceManagerClient:cb_coin_dlcs(response)
	if response.error == nil then
		print("Coin DLCs updated")
		self:_finalize_profile_load()
	else
		print("Error updating coin DLCs", response.error)

		self._profile_data = nil

		self._profile_callback()
	end
end

function PersistenceManagerClient:_finalize_profile_load()
	self._profile_callback(self._profile_data)
end

function PersistenceManagerClient:cb_rank_60(response)
	if response.error == nil then
		self._profile_data.attributes = self:_parse_profile_attributes(response.attributes or {})

		self._profile_callback(self._profile_data)
	end
end

function PersistenceManagerClient:_synchronize_unlocks(rank)
	local mismatch_entities = {}
	local rank_unlocks = default_rank_unlocks(rank)

	table.merge(mismatch_entities, rank_unlocks)

	local gear_unlocks = default_gear_unlocks()

	table.merge(mismatch_entities, gear_unlocks)

	local gear_attachment_unlocks = default_gear_attachment_unlocks()

	table.merge(mismatch_entities, gear_attachment_unlocks)

	local perk_unlocks = default_perk_unlocks()

	table.merge(mismatch_entities, perk_unlocks)

	local armour_attachment_unlocks = default_armour_attachment_unlocks()

	table.merge(mismatch_entities, armour_attachment_unlocks)

	local head_unlocks = default_head_unlocks()

	table.merge(mismatch_entities, head_unlocks)

	local helmet_unlocks = default_helmet_unlocks()

	table.merge(mismatch_entities, helmet_unlocks)

	local helmet_attachment_unlocks = default_helmet_attachment_unlocks()

	table.merge(mismatch_entities, helmet_attachment_unlocks)

	for _, entity in pairs(self._profile_data.entities) do
		mismatch_entities[entity.type .. "|" .. entity.name] = nil
	end

	self:process_unlocks(self._profile_id, mismatch_entities, callback(self, "cb_unlocks_synchronized"))
end

function PersistenceManagerClient:cb_unlocks_synchronized(unlocked_entities)
	for _, entity in pairs(unlocked_entities) do
		self:_add_profile_entitiy(entity.full_name)
	end

	table.dump(unlocked_entities, "Synchronized unlocks", 3)
end

function PersistenceManagerClient:profile_data()
	return self._profile_data
end

function PersistenceManagerClient:load_market(market_callback)
	print("Loading market...")

	self._market_callback = market_callback
	self._market = {
		currencies = {},
		items = {}
	}

	Managers.backend:get_currencies(callback(self, "cb_currencies_fetched"))
end

function PersistenceManagerClient:market()
	return self._market
end

function PersistenceManagerClient:cb_currencies_fetched(response)
	if response.error == nil then
		print("Market currencies fetched!")

		self._market.currencies = response.currencies or {}

		Managers.backend:get_market_items(false, callback(self, "cb_market_items_fetched"))
	else
		print("Error fetching currencies...", response.error)
		self._market_callback()
	end
end

function PersistenceManagerClient:cb_market_items_fetched(response)
	if response.error == nil then
		print("Market items received!")

		self._market.items = response.market_items or {}

		for index, market_item in pairs(self._market.items) do
			self._market.items[market_item.name] = market_item
		end

		for i = 1, #self._market.items do
			self._market.items[i] = nil
		end

		self._market_callback(self._market)
	else
		print("Error fetching market items...", response.error)
		self._market_callback()
	end
end

function PersistenceManagerClient:load_store(store_callback)
	print("Loading store...")

	self._store_callback = store_callback
	self._store = {}

	if GameSettingsDevelopment.enable_micro_transactions then
		Managers.backend:get_store_items(callback(self, "cb_store_items_fetched"))
	else
		store_callback(self._store)
	end
end

function PersistenceManagerClient:cb_store_items_fetched(response)
	if response.error == nil then
		print("Store items received!")

		self._store = response.store_items

		self._store_callback(self._store)
	else
		print("Error fetching store items...", response.error)
		self._store_callback()
	end
end

function PersistenceManagerClient:store()
	return self._store
end

function PersistenceManagerClient:purchase_item(item, purchase_callback, success_callback)
	if IS_DEMO then
		purchase_callback(false, "demo")

		return
	end

	print("Purchasing item " .. tostring(item.id) .. "...")

	self._purchase_callback = purchase_callback
	self._success_callback = success_callback

	local currency_id = item.prices[1].currency_id

	Managers.backend:purchase_item(item.id, currency_id, callback(self, "cb_item_purchased", item))
end

function PersistenceManagerClient:cb_item_purchased(purchased_item, response)
	if response.error == nil then
		print("Item successfully purchased!", purchased_item.name)
		self:_update_profile_purchase(purchased_item)
		self._purchase_callback(true)

		if self._success_callback then
			self._success_callback()
		end
	else
		print("Error purchasing item...", response.error)
		self._purchase_callback(false, response.error)
	end
end

function PersistenceManagerClient:purchase_store_item(item_id, quantity, purchase_callback, success_callback)
	if IS_DEMO then
		purchase_callback(false, "demo")

		return
	end

	print("Purchasing store item " .. tostring(item_id) .. "...")

	self._purchase_callback = purchase_callback
	self._success_callback = success_callback

	Managers.backend:purchase_store_item(item_id, quantity, callback(self, "cb_store_item_purchased"))
end

function PersistenceManagerClient:cb_store_item_purchased(response)
	if response.error == nil then
		if response.authorized then
			print("Store item successfully purchased!")
			self._purchase_callback(true)

			if self._success_callback then
				self._success_callback()
			end
		else
			print("Purchase cancelled")
			self._purchase_callback(false, "cancelled")
		end
	else
		print("Error purchasing store item...", response.error)
		self._purchase_callback(false, response.error)
	end
end

function PersistenceManagerClient:_update_profile_purchase(purchased_item)
	local item_price = purchased_item.prices[1].price

	self._profile_data.attributes.coins = self._profile_data.attributes.coins - item_price

	self:_add_profile_entitiy(purchased_item.name)
end

function PersistenceManagerClient:_add_profile_entitiy(full_name)
	local entity_type, entity_name = full_name:match("([^|]*)|(.*)")

	self._profile_data.entities[#self._profile_data.entities + 1] = {
		type = entity_type,
		name = entity_name,
		profile_id = self._profile_id
	}
end

function PersistenceManagerClient:reload_profile_attributes(reload_callback)
	print("Reloading profile attributes")

	self._reload_callback = reload_callback

	Managers.backend:get_profile_attributes(self._profile_id, callback(self, "cb_profile_attributes_reloaded"))
end

function PersistenceManagerClient:cb_profile_attributes_reloaded(response)
	if response.error == nil then
		print("Profile attributes reloaded")

		self._profile_data.attributes = self:_parse_profile_attributes(response.attributes or {})

		self._reload_callback(true)
	else
		print("Error (cb_profile_attributes_reloaded)", response.error)
		self._reload_callback(false)
	end
end

function PersistenceManagerClient:set_rank(rank)
	Managers.backend:set_profile_attribute(self._profile_id, "experience", RANKS[rank].xp.base)
end

function PersistenceManagerClient:set_coins(coins)
	Managers.backend:set_profile_attribute(self._profile_id, "coins", coins)
end

function PersistenceManagerClient:save_short_term_goal()
	return
end
