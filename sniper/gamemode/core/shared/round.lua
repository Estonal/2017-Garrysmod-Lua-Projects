-- AAAAAAA
sniper.round 		= {}
sniper.round.VarTab = {}

sniper.round.VarTab.Round 		= sniper.round.VarTab.Round or 0
sniper.round.VarTab.Time 		= sniper.round.VarTab.Time or snipConst.Status[ snipConst.Waiting ].Time
sniper.round.VarTab.Status 		= sniper.round.VarTab.Status or snipConst.Waiting
sniper.round.VarTab.CurrentMod 	= sniper.round.VarTab.CurrentMod or snipConst.DeathmatchMod

function sniper.round.GetRound()
	return sniper.round.VarTab.Round
end

function sniper.round.GetStatus()
	return sniper.round.VarTab.Status
end

function sniper.round.GetTime()
	return sniper.round.VarTab.Time
end