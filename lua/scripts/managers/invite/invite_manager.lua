-- chunkname: @scripts/managers/invite/invite_manager.lua

InviteManager = class(InviteManager)

function InviteManager:init()
	print("InviteManager:init()")
end

function InviteManager:update()
	local invite_type, ip, params = Friends.next_invite()

	if invite_type == Friends.INVITE_LOBBY then
		Managers.state.event:trigger("invite_to_lobby", ip, params)
	elseif invite_type == Friends.INVITE_SERVER then
		Managers.state.event:trigger("invite_to_server", ip, params)
	end
end
