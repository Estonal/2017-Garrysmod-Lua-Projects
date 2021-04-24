util.AddNetworkString("show_ranking")

function GM:ShowTeam(ply)

	local rankingdata = snip_SortScores()
	
	net.Start("show_ranking")
		net.WriteTable(rankingdata)
	net.Send(ply)
end



function snip_SortScores()
	newdata = {}
	newdata["kills"] = {}
	newdata["deaths"] = {}
	newdata["nicknames"] = {}
	newdata["steamids"] = {}
	 data = {}
	 data["kills"] = {}
	 data["deaths"] = {}
 	 data["nicknames"] = {}
	 data["steamids"] = {}
	 local files, directories = file.Find( "kddata/*", "DATA" )

	for k,v in pairs(files) do
		local _ = util.JSONToTable(file.Read('kddata/'..v,"DATA"))
		data["kills"][k] = _.Kill
		data["deaths"][k] = _.Death
		data["nicknames"][k] = _.Nickname
		data["steamids"][k] = _.SteamID
	end

	for i=1, #files do
		newdata["kills"][i] = data["kills"][i]
		newdata["deaths"][i] =data['deaths'][i]
		newdata["nicknames"][i] = data["nicknames"][i]
		newdata["steamids"][i] = data["steamids"][i]
	end

	for i=1, #files do
		for j=1, #files-i do
		if newdata["kills"][j] - newdata["deaths"][j] < newdata["kills"][j+1] - newdata["deaths"][j+1] then
			local temp = newdata["kills"][j]
			local temp1 = newdata["deaths"][j]
			local temp2 = newdata["nicknames"][j]
			local temp3 = newdata["steamids"][j]
			newdata["kills"][j] = newdata["kills"][j+1]
			newdata["deaths"][j] = newdata["deaths"][j+1]
			newdata["nicknames"][j] = newdata["nicknames"][j+1]
			newdata["steamids"][j] = newdata["steamids"][j+1]
			newdata["kills"][j+1] = temp
			newdata["deaths"][j+1] = temp1
			newdata["nicknames"][j+1] = temp2
			newdata["steamids"][j+1] = temp3

		end

	end
	end

	return newdata
end