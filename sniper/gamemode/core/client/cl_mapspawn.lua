

hook.Add('OnPlayerChat', 'spawnpoint', function(sender, text, teamchat, isdead)

if sender:UniqueID() == LocalPlayer():UniqueID() then
		if sender:IsUserGroup('superadmin') then
		local commandTable = string.Explode(' ', text)
		if commandTable[1] == '!스폰설정' then

		if commandTable[2] == 'red' || commandTable[2] == 'blue' then
			local team = commandTable[2]
			local num = tonumber(commandTable[3])
			local loc = sender:GetPos()
			local spawnpos = {}
			spawnpos.x = loc.x
			spawnpos.y = loc.y
			spawnpos.z = loc.z
			spawnpos.team = team
			spawnpos.number = num

			net.Start("snip_setspawnpoint")
				net.WriteTable(spawnpos)
				net.SendToServer()
		end
	end
end
end

end)