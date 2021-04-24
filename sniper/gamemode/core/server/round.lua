-- AAAAAAA
util.AddNetworkString( "sniper.round.SetRound" )
util.AddNetworkString( "sniper.round.SetStatus" )
util.AddNetworkString( "sniper.round.SetTime" )
snipConst.Status[ snipConst.Waiting ].Initialize = function() 

end
snipConst.Status[ snipConst.Waiting ].Think = function()
end
snipConst.Status[ snipConst.Waiting ].DeathThink = function( ply ) 
end

snipConst.Status[ snipConst.Practice ].Initialize = function()
	for _, ply in pairs( player.GetPlayers() ) do
		ply:Spawn()
	end
end
snipConst.Status[ snipConst.Practice ].Think = function() end
snipConst.Status[ snipConst.Practice ].DeathThink = function( ply )

	ply:RequestRespawn()

end

snipConst.Status[ snipConst.Prepare ].Initialize = function()
	sniper.round.AddRound()
	
	game.CleanUpMap()
	
	for _, ply in pairs( player.GetPlayers() ) do

		ply:Spawn()
		ply:Freeze( true )

	end
end
snipConst.Status[ snipConst.Prepare ].Think = function()
	if #player.GetDead() == 0 then return end
	
	for _, ply in pairs( player.GetDead() ) do

		ply:Spawn()
		ply:Freeze( true )
		
	end
end
snipConst.Status[ snipConst.Prepare ].DeathThink = function( ply ) end

snipConst.Status[ snipConst.Process ].Initialize = function()
	for _, ply in pairs( player.GetPlayers() ) do
		ply:Freeze( false )
	end
end
snipConst.Status[ snipConst.Process ].Think = function()
local a = 0
local b = 0
for k,v in pairs(team.GetPlayers(1)) do
	if v:Alive() then
		a = a + 1
	end
end
for k,v in pairs(team.GetPlayers(2)) do
	if v:Alive() then
		b = b + 1
	end
end
if a <= 0 or b <= 0 then
		sniper.round.NextStatus()
end
end
snipConst.Status[ snipConst.Process ].DeathThink = function( ply ) end

snipConst.Status[ snipConst.GameSet ].Initialize = function()
	for k,v in pairs(player.GetAll()) do
	v:SaveKDInfo()
	end
end
snipConst.Status[ snipConst.GameSet ].Think = function() end
snipConst.Status[ snipConst.GameSet ].DeathThink = function( ply ) end

snipConst.Status[ snipConst.Cycle ].Initialize = function() sniper.round.SetStatus( snipConst.Prepare ) end
snipConst.Status[ snipConst.Cycle ].Think = function() end
snipConst.Status[ snipConst.Cycle ].DeathThink = function( ply ) end

function sniper.round.SetRound( round )
	local maxRound = snipConst.MaximumRound
	
	if round < 0 or round >= maxRound then 
		if round > 0 then
			VoteMap()
		end
		return 
	end
	
	sniper.round.VarTab.Round = round
	local l = 0
	local m = 0
	for k,v in pairs(team.GetPlayers(1)) do
    	if v:Alive() then
    		l=l+1
    	end
    end
    for k,v in pairs(team.GetPlayers(2)) do
    	if v:Alive() then
    		m=m+1
    	end
    end
    if l == 0 or m == 0 then
    	if l == 0 and m == 0 then
    		winroundred = winroundred + 1
    		winroundblue = winroundblue + 1
    		for k,v in pairs(player.GetPlayers()) do
    			v:PS_GivePoints(snipConst.Basicpoint[4] * snipConst.GroupNumCheck(v:GetUserGroup())*v:GetClanSettings().earnpoint)
    			v:ChatPrint('['..system..']'.. " 무승부! 양쪽 팀 모두에게 포인트 지급!")
    		end
    	else if l == 0 then
    		for k,v in pairs(team.GetPlayers(2)) do
    			v:PS_GivePoints(snipConst.Basicpoint[2] * snipConst.GroupNumCheck(v:GetUserGroup())*v:GetClanSettings().earnpoint)
    			v:ChatPrint('['..system..']'.. " 대테러리스트 승리! 승리포인트 지급!")
    		end 
    		for k,v in pairs(team.GetPlayers(1)) do
    			v:PS_GivePoints(snipConst.Basicpoint[3] * snipConst.GroupNumCheck(v:GetUserGroup())*v:GetClanSettings().earnpoint)
    			v:ChatPrint('['..system..']'.. " 테러리스트 패배..")
    		end
    		winroundblue = winroundblue + 1
    	else if m == 0 then
    		for k,v in pairs(team.GetPlayers(1)) do
    			v:PS_GivePoints(snipConst.Basicpoint[2] * snipConst.GroupNumCheck(v:GetUserGroup())*v:GetClanSettings().earnpoint)
    			v:ChatPrint('['..system..']'.. " 테러리스트 승리! 승리포인트 지급!")
    		end
    		for k,v in pairs(team.GetPlayers(2)) do
    			v:PS_GivePoints(snipConst.Basicpoint[2] * snipConst.GroupNumCheck(v:GetUserGroup())*v:GetClanSettings().earnpoint)
    			v:ChatPrint('['..system..']'.. " 대 테러리스트 패배..")
    		end
    		winroundred = winroundred + 1
   		end
    	end
    end
	end
	net.Start( "sniper.round.SetRound" )
		net.WriteFloat( round )
		net.WriteInt(winroundred, 16)
		net.WriteInt(winroundblue, 16)
	net.Broadcast()
end

function sniper.round.AddRound()
	sniper.round.SetRound( sniper.round.GetRound() + 1 )
end

function sniper.round.SetStatus( status )
	local firstKey = snipConst.Waiting
	local lastKey = snipConst.Cycle
	
	if status < firstKey or status > lastKey then return end
	
	sniper.round.VarTab.Status = status
	hookgetstatus = status
	
	snipConst.Status[ status ].Initialize()
	
	net.Start( "sniper.round.SetStatus" )
		net.WriteFloat( status )
	net.Broadcast()
	
	sniper.round.SetTime( snipConst.Status[ status ].Time )
end

function sniper.round.NextStatus()
	sniper.round.SetStatus( sniper.round.GetStatus() + 1 )
end

function sniper.round.SetTime( time )
	if time < 0 then return end
	
	sniper.round.VarTab.Time = time
	net.Start( "sniper.round.SetTime" )
		net.WriteFloat( time )
	net.Broadcast()
end

function sniper.round.SubtractTime()
	sniper.round.SetTime( sniper.round.GetTime() - 1 )
	for k,v in pairs(player.GetPlayers()) do
		v:SetNWInt('afktime', v:GetNWInt('afktime', 0) + 1)
		if v:GetNWInt('afktime', 0) >= 295 then
			if 300-v:GetNWInt('afktime', 0) > 0  then
			for l,z in pairs(player.GetAll()) do
				z:ChatPrint(v:Nick()..'님이 잠수를 타셔서 '..300-v:GetNWInt('afktime', 0)..'초 후 자동 퇴장됩니다!')
			end
			end
		end
		if v:GetNWInt('afktime', 0) > 300 then
			v:Kick('['..system..']'..'당신은300초동안 무반응으로 자동 강퇴당하셧습니다.')
		end
	end
end
hook.Add("KeyPress", 'afkcheck', function(ply, key)
	ply:SetNWInt('afktime',0)
end)

function sniper.round.Start()
	if timer.Exists( "sniper.round.Timer" ) then return end
	timer.Create( "sniper.round.Timer", 1, 0, function()
		sniper.round.TimerThink()
	end)
end

function sniper.round.Think()
	local minPlayer = snipConst.MinimumPlayers
	if (#team.GetPlayers(1) >= minPlayer/2 && #team.GetPlayers(2) >= minPlayer/2  && #player.GetPlayers() >= minPlayer) then
		sniper.round.Start()
	else
		sniper.round.Stop()
	end
	
	snipConst.Status[ sniper.round.GetStatus() ].Think()
end

function sniper.round.TimerThink()
	if sniper.round.GetTime() == 0 then
		sniper.round.NextStatus()
	else
		sniper.round.SubtractTime()
	end
end

function sniper.round.Stop()
	if !timer.Exists( "sniper.round.Timer" ) then return end
	timer.Remove( "sniper.round.Timer" )
	
	sniper.round.SetStatus( snipConst.Waiting )
end