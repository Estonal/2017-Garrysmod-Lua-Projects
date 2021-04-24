
red_model = "models/player/testrsl/redsimleader.mdl"
blue_model = "models/player/baoto/bluesimleader.mdl"


surface.CreateFont( "teamselectbutton", {
		font		= "Roboto",
		size		= 25,
		antialias = true
	})

surface.CreateFont( "teamselectbutton2", {
		font		= "Roboto",
		size		= 40,
		antialias = true
	})


function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end


net.Receive("snip_choosemode",function()
	local team_red = net.ReadInt(32) -- team 1
	local team_blue = net.ReadInt(32) -- team 2
	
	local ChooseMenu = vgui.Create("DFrame")
	ChooseMenu:SetPos( ScrW()/4, ScrH()/4 )
	ChooseMenu:SetSize( ScrW()/2, ScrH()/2 )
	ChooseMenu:SetTitle( "TEAM CHOOSE" )
	ChooseMenu:SetScreenLock( true )
	ChooseMenu:SetDraggable( false )
	ChooseMenu:MakePopup()
	ChooseMenu:ShowCloseButton( false )
	function ChooseMenu:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color(50,50,50) )
	draw.OutlinedBox(0,0,w,h, 3, Color(0,0,0))
	end

	local REDModel = vgui.Create( "DModelPanel", ChooseMenu)
	REDModel:SetModel( red_model )
	REDModel:SetPos(25,20)
	REDModel:SetSize( ChooseMenu:GetWide()/5*2-25, ScrH()/2-40 )

	REDModel:SetCamPos( Vector( 0, -70, 50 ) )
	REDModel:SetLookAt( Vector( 0, 0, 90 ) )


	function REDModel:LayoutEntity( ent ) return end

	local Choosebutton_red = vgui.Create( "DButton", REDModel )
	Choosebutton_red:SetPos( 0, 0 )
	Choosebutton_red:SetSize( ChooseMenu:GetWide()/5*2-25, ScrH()/2-40 )
	Choosebutton_red:SetText('')	
	Choosebutton_red.DoClick = function()
		net.Start("snip_selects_red")
		net.SendToServer()
		ChooseMenu:Close()
	end
	function Choosebutton_red:Paint(w,h)
		draw.SimpleText( "레드팀( "..team_red.."명 )", "teamselectbutton", w/2, h/2, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,10) )
		draw.RoundedBox( 0, 0, 0, w, h/10, Color(255,0,0,255) )
		
		draw.OutlinedBox(0, 0, w, h, 5, Color(0,0,0))
		if team_red+1 < team_blue then
			draw.SimpleText( "추천!", "teamselectbutton2", w/2, h/4, Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	function REDModel:DoClick()
			Choosebutton_red.DoClick()
	end


	local BLUEModel = vgui.Create( "DModelPanel", ChooseMenu)
	BLUEModel:SetModel( blue_model )
	BLUEModel:SetPos(ChooseMenu:GetWide()/5*3,20)
	BLUEModel:SetSize( ChooseMenu:GetWide()/5*2-25, ScrH()/2-40 )

	BLUEModel:SetCamPos( Vector( 0, -70, 50 ) )
	BLUEModel:SetLookAt( Vector( 0, 0, 90 ) )


	function BLUEModel:LayoutEntity( ent ) ent:SetAngles( Angle( 0, 180, 0 ) ) return end

	local Choosebutton_blue = vgui.Create( "DButton", BLUEModel )
	Choosebutton_blue:SetPos( 0, 0 )
	Choosebutton_blue:SetSize( ChooseMenu:GetWide()/5*2-25, ScrH()/2-40 )
	Choosebutton_blue:SetText('')	
	Choosebutton_blue.DoClick = function()
		net.Start("snip_selects_blue")
		net.SendToServer()
		ChooseMenu:Close()
	end
	function Choosebutton_blue:Paint(w,h)
		draw.SimpleText( "블루팀( "..team_blue.."명 )", "teamselectbutton", w/2, h/2, Color( 0, 0, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,10) )
		draw.RoundedBox( 0, 0, 0, w, h/10, Color(0,0,255,255) )
		draw.OutlinedBox(0, 0, w, h, 5, Color(0,0,0))
		if team_red > team_blue+1 then
			draw.SimpleText( "추천!", "teamselectbutton2", w/2, h/4, Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	function BLUEModel:DoClick()
			Choosebutton_red.DoClick()
	end

	local Choosebutton_spectate = vgui.Create("DButton", ChooseMenu)
	Choosebutton_spectate:SetPos( ChooseMenu:GetWide()/5*2,20)
	Choosebutton_spectate:SetSize( ChooseMenu:GetWide()/5, (ScrH()/2-40) )
	Choosebutton_spectate:SetText('')	
	Choosebutton_spectate.DoClick = function()
		net.Start("snip_selects_spectate")
		net.SendToServer()
		ChooseMenu:Close()
	end
	function Choosebutton_spectate:Paint(w,h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(100,100,100,255) )
		draw.SimpleText( "관전자", "teamselectbutton", w/2, h/2, Color( 100, 255, 100, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.OutlinedBox(0, 0, w, h, 5, Color(0,0,0))
	end

end)



/*local l= #team.GetPlayers(1)
    local m= #team.GetPlayers(2)
    if l > m then
    	ply:SetTeam(2) 
    else if l < m then
    		ply:SetTeam(1)
    else if l == m then
    	ply:SetTeam(math.random(1,2))
    end
	end
	end 랜덤참가용