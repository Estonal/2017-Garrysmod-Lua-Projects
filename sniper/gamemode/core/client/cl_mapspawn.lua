

hook.Add('OnPlayerChat', 'spawnpoint', function(sender, text, teamchat, isdead)
local commandTable = string.Explode(' ', text)
if sender:UniqueID() == LocalPlayer():UniqueID() then
		if sender:IsUserGroup('superadmin') then
		if commandTable[1] == '!스폰설정' then

			setspawnpoints(commandTable)
		end
		end

end
end)


function setspawnpoints(table)

if table[2] == 'red' || table[2] == 'blue' then
			local team = table[2]
			local num = tonumber(table[3])
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