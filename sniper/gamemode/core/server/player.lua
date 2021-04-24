-- AAAAAAA
util.AddNetworkString( "sniper.LoadVarTab" )
function plymeta:SetSpectator( spec )
	self.Spectator = spec
end

function plymeta:IsSpectator()
	return self.Spectator
end

function plymeta:RequestRespawn()
	if self.RespawnRequested then return end
	
	local c = snipConst
	
	timer.Create( tostring( self ) .. ":RequestRespawn", c.RespawnTime, 1, function()
		self:Spawn()
		self.RespawnRequested = false
	end )
	
	self.RespawnRequested = true
end

function plymeta:LoadVarTab()
	net.Start( "sniper.LoadVarTab" )
		net.WriteFloat( sniper.round.GetRound() )
		net.WriteFloat( sniper.round.GetStatus() )
		net.WriteFloat( sniper.round.GetTime() )
	net.Send( self )
end