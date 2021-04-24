-- AAAAAAA
surface.CreateFont( "TheDefaultset", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 20,
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


function DrawName( ply )
	if ( !IsValid( ply ) ) then return end
	if ( !ply:Alive() ) then return end
	local Distance = LocalPlayer():GetPos():Distance( ply:GetPos() )

		local offset = Vector( 0, 0, 85 )
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.4 )
			if ( ply:Team() == LocalPlayer():Team() ) then
			cam.IgnoreZ(true)
			draw.DrawText( ply:GetName(), "TheDefaultset", 2, 2, Color(255,255,255), TEXT_ALIGN_CENTER )
			end
			if ( ply:Team() == LocalPlayer():Team() ) then
			cam.IgnoreZ(false)
			end
		cam.End3D2D()
		if ( ply:Team() == LocalPlayer():Team() ) then
		cam.Start3D2D(ply:GetPos() + Vector(0,0,80),Angle( 0, ang.y, 90),0.4)
		cam.IgnoreZ(true)
		draw.DrawText( "아군", "TheDefaultset", 2, 2, Color(0,255,0), TEXT_ALIGN_CENTER )
		cam.IgnoreZ(false)
		cam.End3D2D()
		--elseif ( ply:Team() != LocalPlayer():Team() ) then
		--	cam.Start3D2D(ply:GetPos() + Vector(0,0,80),Angle( 0, ang.y, 90),0.4)
		--	draw.DrawText( "적군", "TheDefaultset", 2, 2, Color(255,0,0), TEXT_ALIGN_CENTER )
		--	cam.End3D2D()
		end
end
hook.Add( "PostPlayerDraw", "DrawName", DrawName )