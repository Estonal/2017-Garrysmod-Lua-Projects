

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end



local Player = FindMetaTable('Player')
Player.IsOwner = false
Player.HasClan = false
Player.Clantitle = 0






net.Receive('clan_manage', function()
	local clantab = net.ReadTable()
	local clanname = net.ReadString()
	local IsOwner = net.ReadBool()
	Player.IsOwner = IsOwner

	clan_frame(clantab, IsOwner, clanname)

end)



net.Receive('hasclancheck', function()
Player.HasClan = net.ReadBool()
if Player.Clantitle != '0' then
Player.Clantitle = net.ReadString()
else
Player.Clantitle = 0
end
end)

hook.Add("OnPlayerChat", "snip_clan", function(sender, text, teamchat, isdead)
	if sender:UniqueID() == LocalPlayer():UniqueID() then


		net.Start('PlySay_')
			net.WriteEntity(sender)
			net.WriteString( text )
		net.SendToServer()
	end





	tab = {}
	if Player.HasClan then
		table.insert(tab, Color(255,255,0))
		table.insert(tab, "["..Player.Clantitle.."]")

	end

	if ( isdead ) then
		table.insert( tab, Color( 255, 30, 40 ) )
		table.insert( tab, "*죽음* " )
	end

	if ( teamchat ) then
		table.insert( tab, Color( 30, 160, 40 ) )
		table.insert( tab, "( 팀 ) " )
	end

	if ( IsValid( sender ) ) then
		table.insert( tab, sender )
	else
		table.insert( tab, "Console" )
	end

	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": "..text )

	chat.AddText( unpack( tab ) )
	return true

end)

function clan_frame(tab, isowner, clanname)
	if Player.HasClan then
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW()/2,ScrH()/3)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle(clanname)
		frame:SetDraggable( true )
		function frame:Paint(w,h)
			draw.RoundedBox(5,0,0,w,h,Color(0,0,125,255))
		end

		local listview = vgui.Create("DListView", frame)
		listview:Dock( FILL )
		listview:SetMultiSelect( false )
		listview:AddColumn( "이름" )
		listview:AddColumn( "고유번호" )
		listview:AddColumn( "직급" )
		listview:AddColumn( "킬-데스(랭킹점수)" )
		listview:AddColumn( "퍼센트" )

		for k,v in pairs(tab) do
			listview:AddLine(v.name, v.Steamid, v.position ,v.kill - v.death, math.Round(v.kill/(v.kill+v.death) * 100 ))
		end



	end
end