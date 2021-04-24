-- AAAAAAA
local votecheck = {}
util.AddNetworkString("Votemapsend")
util.AddNetworkString("MapCheckout")
util.AddNetworkString("Votestop")
net.Receive("MapCheckout", function()
	local votenumber = net.ReadInt(16)
	votecheck[votenumber] = votecheck[votenumber] + 1
end)
function VoteMap()
	mapname, directoris = file.Find( "maps/*.bsp", "GAME" )
	for i=1, #mapname do
		table.insert(votecheck, 0)
	end
	net.Start("Votemapsend")
		net.WriteTable(mapname)
	net.Broadcast()
	timer.Simple( 20, VoteTimeOver )
end

function VoteTimeOver()
	net.Start("Votestop")
	net.Broadcast()
	changenum = 1
	for i=1, #votecheck do
		if i == 1 then
			changenum = i
		else if votecheck[i] > votecheck[i-1] then
			changenum = i
		end
		end
	end
	votecheck = {}
	game.ConsoleCommand( "changelevel " .. string.Replace(mapname[changenum], ".bsp", "") .. "\n" )

end