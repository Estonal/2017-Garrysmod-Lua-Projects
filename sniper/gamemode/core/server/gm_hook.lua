-- AAAAAAA 
util.AddNetworkString('getyoursteamid')
util.AddNetworkString('newbieoruser')
util.AddNetworkString('snip_setspawnpoint')
util.AddNetworkString('snip_choosemode')
util.AddNetworkString("snip_selects_red")
util.AddNetworkString("snip_selects_blue")
util.AddNetworkString("snip_selects_spectate")

teamplayers_range = 2      --각 팀간의 팀원들 인원수 차이를 허용하는 수준

net.Receive('snip_selects_red',function(len, ply)
	local r = #team.GetPlayers(1) -- red
	local b = #team.GetPlayers(2) -- blue

    if r < b + teamplayers_range then
    	if ply:Team() != 1 then
    		if ply:Alive() then
    			ply:Kill()
    		end
    	ply:SetTeam(1)
    	end
    else
    	net.Start("snip_choosemode")
    		net.WriteInt(r, 32)
    		net.WriteInt(b, 32)
    	net.Send(ply)
	end

end)
net.Receive('snip_selects_blue', function(len, ply)
	local r = #team.GetPlayers(1) -- red
	local b = #team.GetPlayers(2) -- blue

    if b < r + teamplayers_range then
    	if ply:Team() != 2 then
    	if ply:Alive() then
    			ply:Kill()
    	end
    	ply:SetTeam(2)
    	end

    else
    	net.Start("snip_choosemode")
    		net.WriteInt(r, 32)
    		net.WriteInt(b, 32)
    	net.Send(ply)
	end

end)

net.Receive('snip_selects_spectate', function(len, ply)
	ply:SetTeam(3)
end)

RegularDistance = 1000 -- 이 거리 이후로 데미지가 낮아지기 시작함
distance_unit = 500           --이 거리마다 데미지가 0.9배씩 감소

winroundred = 0
winroundblue = 0
playerlivered = {}
playerliveblue = {} 

function GM:Think()
	sniper.round.Think() 
	if not file.Exists('SpawnPosData','DATA') then
	file.CreateDir('SpawnPosData')
	end
	if not file.Exists('spawnposdata/'..game.GetMap(), 'DATA' ) then
	file.CreateDir('spawnposdata/'..game.GetMap())
	end
	if not file.Exists('plyjoinnum', 'DATA') then
		file.CreateDir('plyjoinnum')
	end
	if not file.Exists('clandata', 'DATA') then
		file.CreateDir('clandata')
	end

	for k,v in pairs(player.GetAll()) do
		if v:Team() == 3 && v:Alive() then
			v:Kill()
		end
	end
end 

function GM:PlayerSay(sender, text, teamchat)
sender:ChatPrint("hellwoa")
end

function GM:ShowSpare2(ply)
	net.Start('snip_choosemode')
		net.WriteInt(#team.GetPlayers(1), 32)
		net.WriteInt(#team.GetPlayers(2), 32)
	net.Send(ply)
end

function GM:PlayerInitialSpawn( ply )

	timer.Simple(2, function()
	net.Start("getyoursteamid")
	net.Send( ply )
	end)

	ply:SetTeam(2)
	net.Start('snip_choosemode')
		net.WriteInt(#team.GetPlayers(1), 32)
		net.WriteInt(#team.GetPlayers(2), 32)
	net.Send(ply)
end


function GM:PlayerDeathSound() return true end


function GM:PlayerSpawn( ply )

	if sniper.round.GetStatus() == 3 then
		ply:Kill()
		ply:Spectate(6)
	elseif sniper.round.GetStatus() != 3 then
	ply:UnSpectate()
	end
	ply:StripWeapons( )
    ply:StripAmmo()
	
	ply:Give( "weapon_crowbar" )
	ply:SetArmor(100) -- 아머


	if ply:Team() == 1 then
		if file.Exists('spawnposdata/'..game.GetMap(), 'DATA') then

		for k,v in pairs(team.GetPlayers(1)) do
			if v:UniqueID() == ply:UniqueID() then
				plyspawn = util.JSONToTable(file.Read('spawnposdata/'..game.GetMap()..'/red_'..k..'.txt', "DATA"))
				break
			end
		end
		ply:SetModel( "models/player/testrsl/redsimleader.mdl" )
		ply:SetupHands( ) 
		ply:SetPos(Vector(plyspawn.x, plyspawn.y, plyspawn.z))
		end

	elseif ply:Team() == 2 then

		if file.Exists('spawnposdata/'..game.GetMap(), 'DATA') then

		for k,v in pairs(team.GetPlayers(2)) do
			if v:UniqueID() == ply:UniqueID() then
				plyspawn = util.JSONToTable(file.Read('spawnposdata/'..game.GetMap()..'/blue_'..k..'.txt', "DATA"))
				break
			end
		end
		ply:SetModel( "models/player/baoto/bluesimleader.mdl" )
		ply:SetupHands( ) 
		
		ply:SetPos(Vector(plyspawn.x, plyspawn.y, plyspawn.z))
		end

	if ply:Team() == 1 or ply:Team() == 2 then

	for i=1, 27 do
		if i == 8 or i == 10 then
		else
			ply:GiveAmmo( 120, i, true )
		end
    end 
	
	ply:SetRunSpeed( 300 )
	ply:SetWalkSpeed( 240 ) 
	ply:SetCrouchedWalkSpeed( 0.3 ) 
	ply:SetJumpPower( 160 ) 
	ply:SetCanWalk( false ) 
	ply:AllowFlashlight( true ) 
	end
end
end
function GM:DoPlayerDeath( ply, attacker, dmginfo )

end

function GM:PlayerSay(sender, text, teamchat)

end

function GM:PlayerDeathThink( ply )
	if ply:Team() == 1 or ply:Team() == 2 then
	snipConst.Status[ sniper.round.GetStatus() ].DeathThink( ply )
	return false
	end

end
 

function GM:CreateTeams( )
	TEAM_RED = 1
	TEAM_BLUE = 2
	TEAM_SPECTATE = 3
	
	team.SetUp( TEAM_RED, "테러리스트", Color( 255, 100, 100 ), false )
	
	team.SetUp( TEAM_BLUE, "대테러리스트", Color( 100, 100, 255 ), false )

	team.SetUp( TEAM_SPECTATE, "관전자", Color( 0, 255, 0 ), false )
end


function GM:PlayerDeath( ply, weapon, aply )
	if ply:Team() == 1 || ply:Team() == 2 then
	ply:CreateRagdoll()
	ply:Spectate(6)
	if aply:IsWorld() or ply == aply then
		for k,v in pairs(player.GetAll()) do
			if v:Alive() then
				if v == ply then continue end
				ply:SpectateEntity(v)
				break
			end
		end
	else
	ply:SpectateEntity(aply)
	end
	if ply == aply then return end
	ply:AddDeaths(1)
	aply:AddFrags(1)
	aply:PS_GivePoints(snipConst.Basicpoint[1] * snipConst.GroupNumCheck(aply:GetUserGroup()))
	aply:ChatPrint('['..system..']'.." 당신은 적군을 죽였으므로 "..snipConst.Basicpoint[1] * snipConst.GroupNumCheck(aply:GetUserGroup()).."포인트를 획득하셨습니다!")
end
end

function GM:PlayerShouldTakeDamage(ply, attacker )
	if attacker:IsWorld() then return true end
	if ply:Team() == attacker:Team() then
		return false
	else
		return true
	end

end


local function NextPlayer( ply )

	local plys = player.GetAlive()

	if #plys < 1 then return nil end
	if not IsValid(ply) then return plys[1] end

	local old, new

	for k, v in pairs( plys ) do

		if old == ply then
			new = v
		end

		old = v

	end

	if not IsValid(new) then
		return plys[1]
	end

	return new

end
local function PrevPlayer( ply )

	local plys = player.GetAlive()

	if #plys < 1 then return nil end
	if not IsValid(ply) then return plys[1] end

	local old

	for k, v in pairs( plys ) do

		if v == ply then
			return old or plys[#plys]
		end

		old = v

	end

	if not IsValid(old) then
		return plys[#plys]
	end

	return old
end

function GM:KeyPress( ply, key )
	if not ply:Alive() || ply:Team() == 3 then
		if key == IN_ATTACK2 then
			targ = NextPlayer( ply:GetObserverTarget() )
			if IsValid(targ) then
			ply:Spectate( ply:GetObserverMode() )
			ply:SpectateEntity( targ )
			end
		end
		if key == IN_ATTACK then
			targ = PrevPlayer( ply:GetObserverTarget() )
			if IsValid(targ) then
			ply:Spectate( ply:GetObserverMode() )
			ply:SpectateEntity( targ )
			end
		end
		if key == IN_JUMP then

		if ply:GetObserverMode() == 4  || ply:GetObserverMode() == 0 then
			ply:Spectate(6) 
		elseif ply:GetObserverMode() == 5 then
			ply:Spectate(4)
		elseif ply:GetObserverMode() == 6 then
			ply:Spectate(5)
		end
	end
	end
end


function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

end

function GM:EntityTakeDamage( ply, dmginfo )


	if ply:IsPlayer() then
		local attacker = dmginfo:GetAttacker()

		local ply_pos = ply:GetPos() or 0
		local attacker_pos = attacker:GetPos() or 0
		if not (ply_pos:Distance( attacker_pos ) < RegularDistance) then
			local _ = (ply_pos:Distance( attacker_pos ) - RegularDistance) / 100
			dmginfo:ScaleDamage( 0.9^math.floor(_) )
		end
	end
end

function newbieoruser(ply)
	local steamid = ply:SteamID()
	if file.Exists( 'plyjoinnum/'..string.Replace(steamid, ':', '_')..'.txt', 'DATA' ) == false then
			file.Write('plyjoinnum/'..string.Replace(steamid, ':', '_')..'.txt', 1)
			ply:PS_GivePoints( 400000 )			
	else
			file.Write('plyjoinnum/'..string.Replace(steamid, ':', '_')..'.txt', file.Read('plyjoinnum/'..string.Replace(steamid, ':', '_')..'.txt', "DATA") + 1)
	end

end

net.Receive('snip_setspawnpoint',function(len, ply)
	local spawndata = net.ReadTable()
	local posdata = {}
	posdata.x = spawndata.x
	posdata.y = spawndata.y
	posdata.z = spawndata.z
		file.Write("spawnposdata/"..game.GetMap().."/"..spawndata.team.."_"..spawndata.number..".txt", util.TableToJSON(posdata) or 0)
		ply:ChatPrint(spawndata.team ..'팀 '..spawndata.number.."번의 스폰좌표가 설정되었습니다.")

end)