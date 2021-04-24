-- Shared AddCSLuaFile
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "core/shared/round.lua" )

-- Client AddCSLuaFile
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "core/client/round.lua" )
AddCSLuaFile( "core/client/huds.lua" )
AddCSLuaFile( "core/client/teamscore.lua" )
AddCSLuaFile( "core/client/cl_votemap.lua" )
AddCSLuaFile( "core/client/cl_drawent.lua" )
AddCSLuaFile( "core/client/getsteamid.lua" )
AddCSLuaFile( "core/client/cl_ranking.lua" )
AddCSLuaFile( "core/client/cl_mapspawn.lua" )
AddCSLuaFile( "core/client/cl_choosemode.lua" )
AddCSLuaFile( "core/client/cl_clan.lua" )
-- Shared Include
include( "shared.lua" )
include( "core/shared/round.lua" )

-- Server Include
include( "core/server/round.lua" )
include( "core/server/player.lua" )
include( "core/server/gm_hook.lua" )
include( "core/server/sv_votemap.lua" )
include( "core/server/kdsaver.lua" )
include( "core/server/sv_ranking.lua" )
include( "core/server/sv_clan.lua" )

concommand.Add("addgun",function(ply,cmd,args)
	ply:Give("weapon_smg");

end)