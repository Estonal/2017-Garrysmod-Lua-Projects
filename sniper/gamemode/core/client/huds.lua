-- AAAAAAA

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

surface.CreateFont( "TheDefaultSettingst", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 55,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "Win_or_Lose", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 120,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "TheDefaultSettingsmall", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "TheDefaultSettingsmalltwo", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )



local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudFlashlight = false,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
}


hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false
	else if not ( hide[ name ] ) then return true
	end
end
end )


function checkammo(ply)

	local swep = ply:GetActiveWeapon( ) or 0
	if ply == 0 or swep == 0 or tostring(swep) == '[NULL Entity]' then return end

	local clip = swep:Clip1() or 0
	local ammocount = ply:GetAmmoCount(swep:GetPrimaryAmmoType( ))
	local swepname = swep:GetPrintName()

	local pre_clip = ply:GetNWInt("ammo1", 0)
	local pre_ammocount = ply:GetNWInt("ammocount", 0)
	local pre_swepname = ply:GetNWInt("swepname", 0)

	if clip == pre_clip && ammocount == pre_ammocount && pre_swepname == swepname then ammolode(clip, ammocount, swepname) return end

	ply:SetNWInt('ammo1',clip)
	ply:SetNWInt('ammocount',ammocount)
	ply:SetNWInt('swepname',swepname)

	ammolode(clip, ammocount,swepname)
end

hook.Add("HUDPaint", "HUD", function()
	local ply = LocalPlayer() or 0
	if ply == 0 then return end

	if ply:Alive() then
		checkammo(ply)
		healthbar(ply)
		roundview()
		winorlose()
		killanddeath()
	elseif not ply:Alive() then
	roundview()
	winorlose()

	local observ = ply:GetObserverTarget() or 0
	if observ == 0 then return end

	if ply:GetObserverMode() != 6 and observ != ply then
		healthbar(observ)

	end
	end
end)


function searchliveplayers()
	livered = 0
	liveblue = 0
	for k,v in pairs(team.GetPlayers(1)) do
		if v:Alive() then
			livered = livered + 1
		end
	end
	for k,v in pairs(team.GetPlayers(2)) do
		if v:Alive() then
			liveblue = liveblue + 1
		end
	end

end

function healthbar(ply)
	local triangle = {
	{ x = 300, y = ScrH()-40 },
	{ x = 320, y = ScrH()-10 },
	{ x = 340, y = ScrH()-40 },

	}
	local triangle2 = {
	{ x = 300, y = ScrH()-40 },
	{ x = 320, y = ScrH()-25 },
	{ x = 340, y = ScrH()-40 },

	}
	surface.SetDrawColor( 0, 0, 0, 240 )
	surface.DrawRect(0, ScrH()-50, 600, 50)
	draw.OutlinedBox(0, ScrH()-50, 600, 50, 3, Color(0,0,0))
	draw.OutlinedBox(0, ScrH()-90, 600, 43, 3, Color(0,0,0))
	surface.SetDrawColor(0,0,0,230)
	surface.DrawRect(0, ScrH()-90, 600, 43)
	surface.SetDrawColor(0,0,0, 127)
	surface.DrawRect( 120, ScrH()-35, 165, 20)
	surface.SetDrawColor(150,255,0, 127)
	surface.DrawRect( 125, ScrH()-30, ply:Health()*1.55, 10)
	surface.SetDrawColor( 50, 50, 50 )
	surface.DrawPoly( triangle )
	surface.SetDrawColor( 255, 255, 255 )
	surface.DrawPoly( triangle2 )
	surface.DrawRect( 25, ScrH()-45, 10, 40)
	surface.DrawRect( 10, ScrH()-30, 40, 10)
	surface.SetDrawColor(0,0,0, 127)
	surface.DrawRect( 400, ScrH()-35, 165, 20)
	surface.SetDrawColor(150,255,0, 127)
	surface.DrawRect( 405, ScrH()-30, ply:Armor()*1.55, 10)
	if ply:Team() == 1 then
	colr = Color(255, 0,0)
	elseif ply:Team() == 2 then
	colr = Color(0,0,255)
	end
	draw.SimpleText( ply:Nick(), "TheDefaultSettingsmalltwo", 150, ScrH()-87, colr, 1,0)
	if rounds != nil then
		draw.SimpleText( rounds.." / ".. (snipConst.MaximumRound-1).." Rounds", "TheDefaultSettingsmalltwo", 450, ScrH()-87, Color(255,255,255), 1,0)
	end

	if ply:Health() < 0 then
	draw.SimpleText( '0', "TheDefaultSettingsmall", 85, ScrH()-45, Color(150,255,0, 127), 1,0)
	else
	draw.SimpleText( ply:Health(), "TheDefaultSettingsmalltwo", 85, ScrH()-45, Color(150,255,0, 127), 1,0)
	end
	if ply:Armor() < 0 then
	draw.SimpleText( '0', "TheDefaultSettingsmall", 85, ScrH()-85, Color(150,255,0, 127), 1,0)
	else
	draw.SimpleText( ply:Armor(), "TheDefaultSettingsmalltwo", 370, ScrH()-45, Color(150,255,0, 127), 1,0)
	end
end

function roundview()
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect( ScrW()/2.87, 0, (ScrW()/2/1.2 -  ScrW()/2.87), 50 )
	surface.DrawRect( (ScrW()/2/1.2)+(ScrW()/2/3)-1, 0, (ScrW()/2/1.2 -  ScrW()/2.87), 50 )

	draw.OutlinedBox( ScrW()/2/1.2, 0, ScrW()/2/3, 100, 2, Color( 0,0,0 ) )

	draw.OutlinedBox( (ScrW()/2.87), 0, (ScrW()/2/3 + 2*(ScrW()/2/1.2 -  ScrW()/2.87)) , 100, 3, Color( 0,0,0 ) )


	surface.SetDrawColor(0,0,0,250)
	surface.DrawRect( ScrW()/2.87, 50, (ScrW()/2/1.2 -  ScrW()/2.87), 50 )
	surface.DrawRect( (ScrW()/2/1.2)+(ScrW()/2/3)-1, 50, (ScrW()/2/1.2 -  ScrW()/2.87), 50 )

	draw.SimpleText( "빨강", "TheDefaultSettingsmall", ScrW()/2.87 + (ScrW()/2/1.2 -  ScrW()/2.87)/2, 0, Color(255,255,255), 1,0)
	draw.SimpleText( "파랑", "TheDefaultSettingsmall", (ScrW()/2/1.2)+(ScrW()/2/3)-1 + (ScrW()/2/1.2 -  ScrW()/2.87)/2, 0, Color(255,255,255), 1,0)

	surface.SetDrawColor(0,0,0,254)
	surface.DrawRect( ScrW()/2/1.2, 0, ScrW()/2/3, 100 )
	if natstatus == 0 then
		draw.SimpleText( "플레이어 부족", "TheDefaultSettingsmall", ScrW()/2, 45, Color(255,255,255), 1,0)
	end
	if natstatus == 1 then
		draw.SimpleText( "시작 준비", "TheDefaultSettingsmall", ScrW()/2, 0, Color(0,208,255), 1,0)
		draw.SimpleText( string.ToMinutesSeconds( timesay ), "TheDefaultSettingst", ScrW()/2, 45, Color(0,208,255), 1,0)
	end
	if natstatus == 2 then
		draw.SimpleText( "시작"..string.ToMinutesSeconds( timesay ).."초전", "TheDefaultSettingsmall", ScrW()/2, 45, Color(0,208,255), 1,0)
	end
	if natstatus == 3 then
		draw.SimpleText( "게임시작", "TheDefaultSettingsmall", ScrW()/2, 0, Color(0,208,255), 1,0)
		draw.SimpleText( string.ToMinutesSeconds( timesay ), "TheDefaultSettingsmall", ScrW()/2, 45, Color(0,208,255), 1,0)
	end
	if natstatus == 4 then
		draw.SimpleText( "점수계산중", "TheDefaultSettingsmall", ScrW()/2, 0, Color(0,208,255), 1,0)
		draw.SimpleText( string.ToMinutesSeconds( timesay ), "TheDefaultSettingsmall", ScrW()/2, 45, Color(0,208,255), 1,0)
	end
	if natstatus == 5 then
		draw.SimpleText( "시작 ".. string.ToMinutesSeconds( timesay ) .. "초전", "TheDefaultSettingsmall", ScrW()/2, 45, Color(0,208,255), 1,0)
	end
	draw.SimpleText( winroundred, "TheDefaultSettingsmall", ScrW()/2.62, 50, Color(255,0,0), 1,0)
	draw.SimpleText( winroundblue, "TheDefaultSettingsmall", ScrW()/1.62, 50, Color(0,0,255), 1,0)
end

function winorlose(ply)
	if natstatus == 3 or natstatus == 4 then
	searchliveplayers()
	if livered == 0 or liveblue == 0 then
		local square1 = {
		{ x = 0, y = ScrH()/2-50 },
		{ x = ScrW()/2-600, y = ScrH()/2+50 },
		{ x = ScrW()/2+600, y = ScrH()/2+50 },
		{ x = ScrW(), y = ScrH()/2-50 },

		}
		surface.SetDrawColor(0,0,0,230)
		surface.DrawPoly(square1)
		if livered == 0 and liveblue == 0 then
			draw.SimpleText("레드 VS 블루 무승부.", "Win_or_Lose",ScrW()/2, ScrH()/2, Color(255,255,255), 1,1)
			return
		end
		if livered == 0 then
			if LocalPlayer():Team() == 1 then
				draw.SimpleText("레드 패배..", "Win_or_Lose",ScrW()/2, ScrH()/2, Color(255,0,0), 1,1)
			else
				draw.SimpleText("블루 승리!", "Win_or_Lose",ScrW()/2, ScrH()/2, Color(0,0,255), 1,1)
			end
		end
		if liveblue == 0 then
			if LocalPlayer():Team() == 2 then
				draw.SimpleText("블루 패배..", "Win_or_Lose",ScrW()/2, ScrH()/2, Color(0,0,255), 1,1)
			else
				draw.SimpleText("레드 승리!", "Win_or_Lose",ScrW()/2, ScrH()/2, Color(255,0,0), 1,1)
			end
		end
		end
	end
end 

function ammolode(wpleft, ammocount, swepname)
	if ammocount == 0 then ammocount = '-' end
	if wpleft == -1 then wpleft = '-' end
	draw.SimpleText(wpleft..' | '..ammocount, "TheDefaultSettingst", (ScrW()-200+ScrW())/2, ScrH()-60, Color(255,255,255), 1,0)
	draw.SimpleText(swepname, "TheDefaultSettingsmall", (ScrW()-200+ScrW())/2, ScrH()-100, Color(255,255,255), 1,0)
end


function killanddeath()
end