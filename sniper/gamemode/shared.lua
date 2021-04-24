-- Sniper Gamemode?
DeriveGamemode( "base" )

GM.Name     = "라운드FPS"
GM.Author 	= ""

sniper = {}
snipConst = {}

snipConst.MinimumPlayers 				= 2     		-- 라운드를 플레이하기 위한 최소 플레이어 수

snipConst.MaximumRound 					= 17		-- 맵첸하기까지의 라운드 수 + 1

snipConst.RespawnTime 					= 1  			-- 리스폰까지 걸리는 시간

snipConst.Waiting 						= 0				-- 여기부터
snipConst.Practice 						= 1				-- .
snipConst.Prepare 						= 2				-- .
snipConst.Process 						= 3				-- .
snipConst.GameSet 						= 4				-- .
snipConst.Cycle 						= 5				-- .
sniper.IsMapVotetime                    = 0             -- 여기까진 안건드려도 됨.
snipConst.Status = {}
snipConst.Status[ snipConst.Waiting ] 	= { Time = 1 }	-- 최소 인원 미달시 기다리는 상태의 시간(애초에 이 상태는 시간이 의미없으므로 0)
snipConst.Status[ snipConst.Practice ] 	= { Time = 5 }	-- 최소 인원 충족시 로딩중인 플레이어를 기다리며 워밍업 하는 시간
snipConst.Status[ snipConst.Prepare ] 	= { Time = 3 }	-- 라운드 시작 전 잠시 플레이어를 정지시키는 시간(시작전에 3,2,1 사운드 넣으면 좋아용)
snipConst.Status[ snipConst.Process ] 	= { Time = 300 }-- 라운드 시간
snipConst.Status[ snipConst.GameSet ] 	= { Time = 3 }	-- 라운드 끝나고 정산 화면 보이는 시간
snipConst.Status[ snipConst.Cycle ] 	= { Time = snipConst.Status[ snipConst.Prepare ].Time }

--------------------------------- 원한다면 그룹 더 만들기 가능
snipConst.earnpoint = {}
snipConst.earnpoint[1] = 'user'
snipConst.earnpoint[2] = 'admin'
snipConst.earnpoint[3] = 'superadmin'
snipConst.earnpoint[4] = 'private'
--포인트 받는 방식 -> snipConst.Basicpoint * snipConst.GroupNumCheck의 값
snipConst.Basicpoint = {}
snipConst.Basicpoint[1] = 10       -- 킬로 얻는 포인트
snipConst.Basicpoint[2] = 20       -- 팀승리로 얻는 포인트
snipConst.Basicpoint[3] = 30       -- 팀패배로 얻는 포인트
snipConst.Basicpoint[4] = 40       -- 무승부로 얻는 포인트

snipConst.GroupNumCheck = function(groupname)
	for k,v in pairs(snipConst.earnpoint) do
		if v == groupname then
			return k
		end
	end
	return 1

end
--------------------------------

system = '시스템'
plymeta = FindMetaTable( "Player" )

player.GetPlayers = function()
	local list = {}

	for _, ply in pairs( player.GetAll() ) do
		if ply:Team() != 3 then table.insert( list, ply ) end
	end

	return list
end

player.GetAlive = function()
	local list = {}

	for _, ply in pairs( player.GetAll() ) do
		if ply:Alive() then table.insert( list, ply ) end
	end

	return list
end

player.GetDead = function()
	local list = {}

	for _, ply in pairs( player.GetAll() ) do
		if !ply:Alive() and ply:Team() != 3 then table.insert( list, ply ) end
	end

	return list
end

team.SetClass( 1, 'player_red' )
team.SetClass( 2, 'player_blue' )