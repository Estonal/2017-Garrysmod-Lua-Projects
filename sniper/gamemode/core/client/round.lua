-- AAAAAAA
net.Receive( "sniper.round.SetRound", function( len )	
	rounds = net.ReadFloat()
	print( "round: " .. rounds )
    winroundred = net.ReadInt(16)
    winroundblue = net.ReadInt(16)
end )

net.Receive( "sniper.round.SetStatus", function( len )
	local status = net.ReadFloat()
	natstatus = status
	
	if status == 5 then return end

	print( "status: " .. status )
end )

net.Receive( "sniper.round.SetTime", function( len )
	timesay = net.ReadFloat()
	--print( "time: " .. timesay )
end )