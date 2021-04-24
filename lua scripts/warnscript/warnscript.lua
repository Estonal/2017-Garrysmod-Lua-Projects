AddCSLuaFile()

WarnTable = {}

print("WARNING 0.0000001ver is working.")

if SERVER then
	
	util.AddNetworkString( "WarnScript_Load" )
	util.AddNetworkString( "WarnScript_Send" )
	util.AddNetworkString( "WarnScript_Kick" )
	util.AddNetworkString( "WarnScript_Ban" )
	util.AddNetworkString( "WarnScript_Warn" )
	util.AddNetworkString( "WarnScript_Reset" )
	util.AddNetworkString( "Chat_WarnOpen" )
	
	if file.Exists( "warnscript.txt" , "DATA" ) then
		WarnTable = util.JSONToTable( file.Read( "warnscript.txt" , "DATA") )
		for _, players in pairs( player.GetAll() ) do
			net.Start("WarnScript_Send")
				net.WriteTable(WarnTable)
			net.Send(players)
		end
	else
		file.Write('warnscript.txt', WarnTable) --*
	end

	
	
	net.Receive( "WarnScript_Warn", function( len, ply )
		local pl = net.ReadEntity()
		local reason = net.ReadString()
		if pl:IsPlayer() then
			WarnTable[pl:SteamID()] = (WarnTable[pl:SteamID()] or 0) + 1
			 if WarnTable[pl:SteamID()] == 3 then
               pl:Kick()
            end
			for _, players in pairs( player.GetAll() ) do
				players:ChatPrint(pl:Nick() .. " 님이 경고를 받으셧습니다. ( 이유 : " .. reason .. " )")
				net.Start("WarnScript_Send")
					net.WriteTable(WarnTable)
				net.Send(players)
			end
			file.Write( "warnscript.txt", util.TableToJSON(WarnTable) )
		end
	end)


	
	net.Receive( "WarnScript_Reset", function( len, ply )
		local pl = net.ReadEntity()
		local reason = net.ReadString()
		if pl:IsPlayer() then
			WarnTable[pl:SteamID()] = 0
			for _, players in pairs( player.GetAll() ) do
				net.Start("WarnScript_Send")
					net.WriteTable(WarnTable)
				net.Send(players)
			end
			file.Write( "warnscript.txt", util.TableToJSON(WarnTable) )
		end
	end)


	
	net.Receive( "WarnScript_Kick", function( len, ply )
		local pl = net.ReadEntity()
		local reason = net.ReadString()
		if pl:IsPlayer() then
			pl:Kick(reason)
		end
	end)
	
	net.Receive( "WarnScript_Ban", function( len, ply )
		local pl = net.ReadEntity()
		local time = net.ReadFloat()
		if pl:IsPlayer() then
			pl:Ban(time)
		end
	end)


	
	net.Receive( "WarnScript_Load", function( len, ply )
		net.Start("WarnScript_Send")
			net.WriteTable(WarnTable)
		net.Send(ply)
	end)

	hook.Add( "PlayerAuthed", "PlayerAuthed", function( Player, SteamID )
		net.Start("WarnScript_Send")
			net.WriteTable(WarnTable)
		net.Send(Player)
	end)



	hook.Add( "PlayerSay", "CHAT_COMMAND", function( sender, text, teamchat )   -- 여기임
		print("IS IT POSSIBLE?!?!??!?!?!?!")
		sender:ChatPrint("되긴됨?")
		local string = string.lower(text)
		if string == "!경고" then
			net.Start("CHAT_WarnOpen")
			net.Send(sender)
		end
	end)

end
	
if CLIENT then
	surface.CreateFont( "WS_Font", {
		font		= "Roboto",
		size		= 18,
		antialias = true
	})
	surface.CreateFont( "WS_Font2", {
		font		= "Roboto",
		size		= 13,
		antialias = true
	})
	local PANEL = {}

	function PANEL:Init()

		self:SetSize( 0, 0 )
		self:MakePopup()
		self:ShowCloseButton(false)
		
		self.CloseButton = vgui.Create("DButton", self)
		self.CloseButton:SetSize( 15, 15 )
		self.CloseButton:SetText("")
		function self.CloseButton:Paint(w,h)
			draw.SimpleText( "X", "WS_Font", w/2, h/2, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		self.CloseButton.DoClick = function( button )
			self:Close()
		end
		
		self.PanelList = vgui.Create( "DPanelList", self )
		self.PanelList:SetPos(5, 25)
		self.PanelList:SetPadding(2)
		self.PanelList:SetSpacing(2)
		self.PanelList:EnableHorizontal(false)
		self.PanelList:EnableVerticalScrollbar(true)
		function self.PanelList:Paint(w,h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 255 ) )
		end
		
		net.Start("WarnScript_Load")
		net.SendToServer()
	
		net.Receive( "WarnScript_Send", function( len, ply )
			WarnTable = net.ReadTable()
		end)

		for _, player in pairs( player.GetAll() ) do
			local PlayerButton = vgui.Create("DButton", self)
			PlayerButton:SetSize( 0, 58 )
			PlayerButton:SetText("")
			PlayerButton.SteamID = 0
			PlayerButton.IDAlpha = 0
			function PlayerButton:Think()
				if !player:IsValid() then
					PlayerButton:Remove()
				end
			end
			function PlayerButton:Paint(w,h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 180, 180, 200 ) )
				draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 255, 255, 255 ) )
				draw.RoundedBox( 0, 3, 3, 52, 52, Color( 0, 0, 0, 255 ) )
				draw.SimpleTextOutlined( player:Nick(), "WS_Font",  75, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, PlayerButton.IDAlpha / 15) )
				if player:IsAdmin() then
					player:Nick()
					surface.SetFont( "WS_Font" )
					local width, height = surface.GetTextSize( player:Nick() )
					surface.SetDrawColor( 255, 255, 255, 255 ) 
					surface.SetMaterial( Material( "icon16/shield.png" ) )
					surface.DrawTexturedRect( 76 + width, h/2 - 8, 16, 16 )
				end
				PlayerButton.IDAlpha = Lerp(0.1, PlayerButton.IDAlpha, PlayerButton.SteamID)
				draw.SimpleTextOutlined( player:SteamID(), "WS_Font2",  80, h / 2 + 16, Color( 0, 0, 0, PlayerButton.IDAlpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, PlayerButton.IDAlpha / 15) )
				draw.SimpleTextOutlined( "경고 : " .. (WarnTable[player:SteamID()] or 0), "WS_Font2",  w - 5, h  - 10, Color( 255, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(255, 0, 0, PlayerButton.IDAlpha / 15) )
			end
			function PlayerButton:DoRightClick( button )
				PlayerButton.Option = DermaMenu()
				if LocalPlayer():IsAdmin() then
					PlayerButton.Option:AddOption("경고", function()
						local frame = vgui.Create( "DFrame" )
						frame:SetSize(400,60)
						frame:Center()
						frame:MakePopup()
						frame:ShowCloseButton(false)
						function frame:Paint(w,h)
							draw.RoundedBox( 3, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
							draw.RoundedBox( 3, 1, 1, w-2, h-2, Color( 255, 255, 255, 255 ) )
							draw.SimpleTextOutlined( "이유", "WS_Font",  w/2, 14, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 10) )
						end
						local textbox = vgui.Create("DTextEntry", frame)
						textbox:SetMultiline(false)
						textbox:SetSize(380,20) 
						textbox:SetPos(10,27)
						textbox.OnEnter = function(self)
							net.Start("WarnScript_Warn")
								net.WriteEntity(player)
								net.WriteString(self:GetValue())
							net.SendToServer()
							frame:Remove()
						end
						
						Close = vgui.Create("DButton", frame)
						Close:SetSize( 15, 15 )
						Close:SetPos(frame:GetWide()-20,5)
						Close:SetText("")
						function Close:Paint(w,h)
							draw.SimpleText( "X", "WS_Font", w/2, h/2, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						end
						Close.DoClick = function( button )
							frame:Remove()
						end
					end)
					PlayerButton.Option:AddOption("경고 초기화", function()
						net.Start("WarnScript_Reset")
							net.WriteEntity(player)
						net.SendToServer()
					end)
					PlayerButton.Option:AddOption("킥", function()
						local frame = vgui.Create( "DFrame" )
						frame:SetSize(400,60)
						frame:Center()
						frame:MakePopup()
						frame:ShowCloseButton(false)
						function frame:Paint(w,h)
							draw.RoundedBox( 3, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
							draw.RoundedBox( 3, 1, 1, w-2, h-2, Color( 255, 255, 255, 255 ) )
							draw.SimpleTextOutlined( "Reason", "WS_Font",  w/2, 14, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 10) )
						end
						local textbox = vgui.Create("DTextEntry", frame)
						textbox:SetMultiline(false)
						textbox:SetSize(380,20) 
						textbox:SetPos(10,27)
						textbox.OnEnter = function(self)
							net.Start("WarnScript_Kick")
								net.WriteEntity(player)
								net.WriteString(self:GetValue())
							net.SendToServer()
							frame:Remove()
						end
						
						Close = vgui.Create("DButton", frame)
						Close:SetSize( 15, 15 )
						Close:SetPos(frame:GetWide()-20,5)
						Close:SetText("")
						function Close:Paint(w,h)
							draw.SimpleText( "X", "WS_Font", w/2, h/2, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						end
						Close.DoClick = function( button )
							frame:Remove()
						end
					end)
					PlayerButton.Option:AddOption("밴", function()
						local time = 0
						local frame = vgui.Create( "DFrame" )
						frame:SetSize(400,60)
						frame:Center()
						frame:MakePopup()
						frame:ShowCloseButton(false)
						function frame:Paint(w,h)
							draw.RoundedBox( 3, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
							draw.RoundedBox( 3, 1, 1, w-2, h-2, Color( 255, 255, 255, 255 ) )
							draw.SimpleTextOutlined( "Time(Minutes)", "WS_Font",  w/2, 14, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 10) )
						end
						local textbox = vgui.Create("DTextEntry", frame)
						textbox:SetMultiline(false)
						textbox:SetSize(380,20) 
						textbox:SetPos(10,27)
						textbox.OnEnter = function(self)
							frame:Remove()
							net.Start("WarnScript_Ban")
								net.WriteEntity(player)
								net.WriteFloat(time)
							net.SendToServer()
						end
						
						Close = vgui.Create("DButton", frame)
						Close:SetSize( 15, 15 )
						Close:SetPos(frame:GetWide()-20,5)
						Close:SetText("")
						function Close:Paint(w,h)
							draw.SimpleText( "X", "WS_Font", w/2, h/2, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						end
						Close.DoClick = function( button )
							frame:Remove()
						end
					end)
				end
				PlayerButton.Option:AddOption("고유번호 복사", function()
					SetClipboardText( player:SteamID() )
				end)
				PlayerButton.Option:AddOption("프로필 보기", function()
					player:ShowProfile()
				end)
				PlayerButton.Option:Open()
			end
			
			function PlayerButton:OnCursorEntered()
				PlayerButton.SteamID = 255
			end
			
			function PlayerButton:OnCursorExited()
				PlayerButton.SteamID = 0
			end
			
			
			local PlayerAvatar = vgui.Create( "AvatarImage", PlayerButton )
			PlayerAvatar:SetSize( 50, 50 )
			PlayerAvatar:SetPos( 4, 4 )
			PlayerAvatar:SetPlayer( player, 50 )
			PlayerAvatar:SetMouseInputEnabled( false )
			PlayerAvatar:SetKeyboardInputEnabled( false )
			self.PanelList:AddItem(PlayerButton)
		end
	end

	
	function PANEL:Think()
		if self:GetWide() < 500 then
			self:SetWide( self:GetWide() + 10 )
			self:SetTall( self:GetTall() + 10 )
			self:SetPos( ScrW() / 2 - (self:GetWide()/2), ScrH() / 2 - (self:GetTall()/2) )
			self.PanelList:SetSize(self:GetWide() - 10, self:GetTall() - 30)
			self.CloseButton:SetPos( self:GetWide() - 20, 5 )
		end
	end
	
	function PANEL:Paint(w, h)
		draw.RoundedBox( 3, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		draw.RoundedBox( 3, 1, 1, w-2, h-2, Color( 255, 255, 255, 255 ) )
		draw.RoundedBox( 0, 4, 24, self:GetWide() - 8, self:GetTall() - 28, Color( 0, 0, 0, 150 ) )
	end

	vgui.Register("WarnMenu", PANEL, "DFrame")
	
	concommand.Add("test", function( cmd )
		local WarnMenu = vgui.Create("WarnMenu")
	end)
	
	--[[
	menuIsOpen = false
	function OpenWarn()
		if input.IsKeyDown( KEY_P ) and !menuIsOpen then
		    RunConsoleCommand("test")
			menuIsOpen = true
		end
	end
	hook.Add("Think", "OpenWarn", OpenWarn)
	]]--
	---------------------------------------------------------------------------------------------
	
	
	local PANEL = {}

	AccessorFunc( PANEL, "m_bSizeToContents",		"AutoSize" )
	AccessorFunc( PANEL, "m_bStretchHorizontally",	"StretchHorizontally" )
	AccessorFunc( PANEL, "m_bNoSizing",				"NoSizing" )
	AccessorFunc( PANEL, "m_bSortable",				"Sortable" )
	AccessorFunc( PANEL, "m_fAnimTime",				"AnimTime" )
	AccessorFunc( PANEL, "m_fAnimEase",				"AnimEase" )
	AccessorFunc( PANEL, "m_strDraggableName",		"DraggableName" )

	AccessorFunc( PANEL, "Spacing", "Spacing" )
	AccessorFunc( PANEL, "Padding", "Padding" )

	function PANEL:Init()

		self:SetDraggableName( "GlobalDPanel" )

		self.pnlCanvas = vgui.Create( "DPanel", self )
		self.pnlCanvas:SetPaintBackground( false )
		self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
		self.pnlCanvas.OnChildRemoved = function() self:OnChildRemoved() end
		self.pnlCanvas:SetMouseInputEnabled( true )
		self.pnlCanvas.InvalidateLayout = function() self:InvalidateLayout() end

		self.Items = {}
		self.YOffset = 0
		self.m_fAnimTime = 0
		self.m_fAnimEase = -1 -- means ease in out
		self.m_iBuilds = 0

		self:SetSpacing( 0 )
		self:SetPadding( 0 )
		self:EnableHorizontal( false )
		self:SetAutoSize( false )
		self:SetPaintBackground( true )
		self:SetNoSizing( false )

		self:SetMouseInputEnabled( true )

		-- This turns off the engine drawing
		self:SetPaintBackgroundEnabled( false )
		self:SetPaintBorderEnabled( false )

	end

	function PANEL:OnModified()

		-- Override me

	end

	function PANEL:SizeToContents()

		self:SetSize( self.pnlCanvas:GetSize() )

	end

	function PANEL:GetItems()

		-- Should we return a copy of this to stop
		-- people messing with it?
		return self.Items

	end

	function PANEL:EnableHorizontal( bHoriz )

		self.Horizontal = bHoriz

	end

	function PANEL:EnableVerticalScrollbar()

		if ( self.VBar ) then return end

		self.VBar = vgui.Create( "DVScrollBar", self )

	end

	function PANEL:GetCanvas()

		return self.pnlCanvas

	end

	function PANEL:Clear( bDelete )

		for k, panel in pairs( self.Items ) do

			if ( !IsValid( panel ) ) then continue end

			panel:SetVisible( false )

			if ( bDelete ) then
				panel:Remove()
			end

		end

		self.Items = {}

	end

	function PANEL:AddItem( item, strLineState )

		if ( !IsValid( item ) ) then return end

		item:SetVisible( true )
		item:SetParent( self:GetCanvas() )
		item.m_strLineState = strLineState || item.m_strLineState
		table.insert( self.Items, item )

		--[[if ( self.m_bSortable ) then
			local DragSlot = item:MakeDraggable( self:GetDraggableName(), self )
			DragSlot.OnDrop = self.DropAction
		end]]

		item:SetSelectable( self.m_bSelectionCanvas )

		self:InvalidateLayout()

	end

	function PANEL:InsertBefore( before, insert, strLineState )

		table.RemoveByValue( self.Items, insert )

		self:AddItem( insert, strLineState )

		local key = table.KeyFromValue( self.Items, before )

		if ( key ) then
			table.RemoveByValue( self.Items, insert )
			table.insert( self.Items, key, insert )
		end

	end

	function PANEL:InsertAfter( before, insert, strLineState )

		table.RemoveByValue( self.Items, insert )
		self:AddItem( insert, strLineState )

		local key = table.KeyFromValue( self.Items, before )

		if ( key ) then
			table.RemoveByValue( self.Items, insert )
			table.insert( self.Items, key + 1, insert )
		end

	end

	function PANEL:InsertAtTop( insert, strLineState )

		table.RemoveByValue( self.Items, insert )
		self:AddItem( insert, strLineState )

		local key = 1
		if ( key ) then
			table.RemoveByValue( self.Items, insert )
			table.insert( self.Items, key, insert )
		end

	end

	function PANEL.DropAction( Slot, RcvSlot )

		local PanelToMove = Slot.Panel
		if ( dragndrop.m_MenuData == "copy" ) then

			if ( PanelToMove.Copy ) then

				PanelToMove = Slot.Panel:Copy()

				PanelToMove.m_strLineState = Slot.Panel.m_strLineState
			else
				return
			end

		end

		PanelToMove:SetPos( RcvSlot.Data.pnlCanvas:ScreenToLocal( gui.MouseX() - dragndrop.m_MouseLocalX, gui.MouseY() - dragndrop.m_MouseLocalY ) )

		if ( dragndrop.DropPos == 4 || dragndrop.DropPos == 8 ) then
			RcvSlot.Data:InsertBefore( RcvSlot.Panel, PanelToMove )
		else
			RcvSlot.Data:InsertAfter( RcvSlot.Panel, PanelToMove )
		end

	end

	function PANEL:RemoveItem( item, bDontDelete )

		for k, panel in pairs( self.Items ) do

			if ( panel == item ) then

				self.Items[ k ] = nil

				if ( !bDontDelete ) then
					panel:Remove()
				end

				self:InvalidateLayout()

			end

		end

	end

	function PANEL:CleanList()

		for k, panel in pairs( self.Items ) do

			if ( !IsValid( panel ) || panel:GetParent() != self.pnlCanvas ) then
				self.Items[k] = nil
			end

		end

	end

	function PANEL:Rebuild()

		local Offset = 0
		self.m_iBuilds = self.m_iBuilds + 1

		self:CleanList()

		if ( self.Horizontal ) then

			local x, y = self.Padding, self.Padding
			for k, panel in pairs( self.Items ) do

				if ( panel:IsVisible() ) then

					local OwnLine = ( panel.m_strLineState && panel.m_strLineState == "ownline" )

					local w = panel:GetWide()
					local h = panel:GetTall()

					if ( x > self.Padding && ( x + w > self:GetWide() || OwnLine ) ) then

						x = self.Padding
						y = y + h + self.Spacing

					end

					if ( self.m_fAnimTime > 0 && self.m_iBuilds > 1 ) then
						panel:MoveTo( x, y, self.m_fAnimTime, 0, self.m_fAnimEase )
					else
						panel:SetPos( x, y )
					end

					x = x + w + self.Spacing
					Offset = y + h + self.Spacing

					if ( OwnLine ) then

						x = self.Padding
						y = y + h + self.Spacing

					end

				end

			end

		else

			for k, panel in pairs( self.Items ) do

				if ( panel:IsVisible() ) then

					if ( self.m_bNoSizing ) then
						panel:SizeToContents()
						if ( self.m_fAnimTime > 0 && self.m_iBuilds > 1 ) then
							panel:MoveTo( ( self:GetCanvas():GetWide() - panel:GetWide() ) * 0.5, self.Padding + Offset, self.m_fAnimTime, 0, self.m_fAnimEase )
						else
							panel:SetPos( ( self:GetCanvas():GetWide() - panel:GetWide() ) * 0.5, self.Padding + Offset )
						end
					else
						panel:SetSize( self:GetCanvas():GetWide() - self.Padding * 2, panel:GetTall() )
						if ( self.m_fAnimTime > 0 && self.m_iBuilds > 1 ) then
							panel:MoveTo( self.Padding, self.Padding + Offset, self.m_fAnimTime, self.m_fAnimEase )
						else
							panel:SetPos( self.Padding, self.Padding + Offset )
						end
					end

					-- Changing the width might ultimately change the height
					-- So give the panel a chance to change its height now,
					-- so when we call GetTall below the height will be correct.
					-- True means layout now.
					panel:InvalidateLayout( true )

					Offset = Offset + panel:GetTall() + self.Spacing

				end

			end

			Offset = Offset + self.Padding

		end

		self:GetCanvas():SetTall( Offset + self.Padding - self.Spacing )

		-- Although this behaviour isn't exactly implied, center vertically too
		if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

			self:GetCanvas():SetPos( 0, ( self:GetTall() - self:GetCanvas():GetTall() ) * 0.5 )

		end

	end

	function PANEL:OnMouseWheeled( dlta )

		if ( self.VBar ) then
			return self.VBar:OnMouseWheeled( dlta )
		end

	end

	function PANEL:Paint( w, h )

		derma.SkinHook( "Paint", "PanelList", self, w, h )
		return true

	end

	function PANEL:OnVScroll( iOffset )

		self.pnlCanvas:SetPos( 0, iOffset )

	end

	function PANEL:PerformLayout()

		local Wide = self:GetWide()
		local Tall = self.pnlCanvas:GetTall()
		local YPos = 0

		if ( !self.Rebuild ) then
			debug.Trace()
		end

		self:Rebuild()

		if ( self.VBar ) then

			self.VBar:SetPos( self:GetWide() - 8, 0 )
			self.VBar:SetSize( 8, self:GetTall() )
			self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() ) -- Disables scrollbar if nothing to scroll
			YPos = self.VBar:GetOffset()

			if ( self.VBar.Enabled ) then Wide = Wide - 8 end

		end

		self.pnlCanvas:SetPos( 0, YPos )
		self.pnlCanvas:SetWide( Wide )

		self:Rebuild()

		if ( self:GetAutoSize() ) then

			self:SetTall( self.pnlCanvas:GetTall() )
			self.pnlCanvas:SetPos( 0, 0 )

		end

		if ( self.VBar && !self:GetAutoSize() && Tall != self.pnlCanvas:GetTall() ) then
			self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
		end

	end

	function PANEL:OnChildRemoved()

		self:CleanList()
		self:InvalidateLayout()

	end

	function PANEL:ScrollToChild( panel )

		local x, y = self.pnlCanvas:GetChildPosition( panel )
		local w, h = panel:GetSize()

		y = y + h * 0.5
		y = y - self:GetTall() * 0.5

		self.VBar:AnimateTo( y, 0.5, 0, 0.5 )

	end

	function PANEL:SortByMember( key, desc )

		desc = desc || true

		table.sort( self.Items, function( a, b )

			if ( desc ) then

				local ta = a
				local tb = b

				a = tb
				b = ta

			end

			if ( a[ key ] == nil ) then return false end
			if ( b[ key ] == nil ) then return true end

			return a[ key ] > b[ key ]

		end )

	end

	derma.DefineControl( "DPanelList", "A Panel that neatly organises other panels", PANEL, "DPanel" )

	
	local PANEL = {}

	function PANEL:Init()
	end

	function PANEL:OnMousePressed()

		self:GetParent():Grip( 1 )

	end

	function PANEL:Paint( w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 180, 180, 255 ) )
		return true

	end

	derma.DefineControl( "DScrollBarGrip", "A Scrollbar Grip", PANEL, "DPanel" )

	local PANEL = {}

	AccessorFunc( PANEL, "m_HideButtons", "HideButtons" )

	function PANEL:Init()

		self.Offset = 0
		self.Scroll = 0
		self.CanvasSize = 1
		self.BarSize = 1

		self.btnUp = vgui.Create( "DButton", self )
		self.btnUp:SetText( "" )
		self.btnUp.DoClick = function( self ) self:GetParent():AddScroll( -1 ) end
		self.btnUp.Paint = function( panel, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 180, 180, 255 ) ) end

		self.btnDown = vgui.Create( "DButton", self )
		self.btnDown:SetText( "" )
		self.btnDown.DoClick = function( self ) self:GetParent():AddScroll( 1 ) end
		self.btnDown.Paint = function( panel, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 180, 180, 255 ) ) end

		self.btnGrip = vgui.Create( "DScrollBarGrip", self )

		self:SetSize( 8, 15 )
		self:SetHideButtons( false )

	end

	function PANEL:SetEnabled( b )

		if ( !b ) then

			self.Offset = 0
			self:SetScroll( 0 )
			self.HasChanged = true

		end

		self:SetMouseInputEnabled( b )
		self:SetVisible( b )

		-- We're probably changing the width of something in our parent
		-- by appearing or hiding, so tell them to re-do their layout.
		if ( self.Enabled != b ) then

			self:GetParent():InvalidateLayout()

			if ( self:GetParent().OnScrollbarAppear ) then
				self:GetParent():OnScrollbarAppear()
			end

		end

		self.Enabled = b

	end

	function PANEL:Value()

		return self.Pos

	end

	function PANEL:BarScale()

		if ( self.BarSize == 0 ) then return 1 end

		return self.BarSize / ( self.CanvasSize + self.BarSize )

	end

	function PANEL:SetUp( _barsize_, _canvassize_ )

		self.BarSize = _barsize_
		self.CanvasSize = math.max( _canvassize_ - _barsize_, 1 )

		self:SetEnabled( _canvassize_ > _barsize_ )

		self:InvalidateLayout()

	end

	function PANEL:OnMouseWheeled( dlta )

		if ( !self:IsVisible() ) then return false end

		-- We return true if the scrollbar changed.
		-- If it didn't, we feed the mousehweeling to the parent panel

		return self:AddScroll( dlta * -2 )

	end

	function PANEL:AddScroll( dlta )

		local OldScroll = self:GetScroll()

		dlta = dlta * 25
		self:SetScroll( self:GetScroll() + dlta )

		return OldScroll != self:GetScroll()

	end

	function PANEL:SetScroll( scrll )

		if ( !self.Enabled ) then self.Scroll = 0 return end

		self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )

		self:InvalidateLayout()

		-- If our parent has a OnVScroll function use that, if
		-- not then invalidate layout (which can be pretty slow)

		local func = self:GetParent().OnVScroll
		if ( func ) then

			func( self:GetParent(), self:GetOffset() )

		else

			self:GetParent():InvalidateLayout()

		end

	end

	function PANEL:AnimateTo( scrll, length, delay, ease )

		local anim = self:NewAnimation( length, delay, ease )
		anim.StartPos = self.Scroll
		anim.TargetPos = scrll
		anim.Think = function( anim, pnl, fraction )

			pnl:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )

		end

	end

	function PANEL:GetScroll()

		if ( !self.Enabled ) then self.Scroll = 0 end
		return self.Scroll

	end

	function PANEL:GetOffset()

		if ( !self.Enabled ) then return 0 end
		return self.Scroll * -1

	end

	function PANEL:Think()
	end

	function PANEL:Paint( w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 255 ) )
		return true

	end

	function PANEL:OnMousePressed()

		local x, y = self:CursorPos()

		local PageSize = self.BarSize

		if ( y > self.btnGrip.y ) then
			self:SetScroll( self:GetScroll() + PageSize )
		else
			self:SetScroll( self:GetScroll() - PageSize )
		end

	end

	function PANEL:OnMouseReleased()

		self.Dragging = false
		self.DraggingCanvas = nil
		self:MouseCapture( false )

		self.btnGrip.Depressed = false

	end

	function PANEL:OnCursorMoved( x, y )

		if ( !self.Enabled ) then return end
		if ( !self.Dragging ) then return end

		local x, y = self:ScreenToLocal( 0, gui.MouseY() )

		-- Uck.
		y = y - self.btnUp:GetTall()
		y = y - self.HoldPos

		local BtnHeight = self:GetWide()
		if ( self:GetHideButtons() ) then BtnHeight = 0 end

		local TrackSize = self:GetTall() - BtnHeight * 2 - self.btnGrip:GetTall()

		y = y / TrackSize

		self:SetScroll( y * self.CanvasSize )

	end

	function PANEL:Grip()

		if ( !self.Enabled ) then return end
		if ( self.BarSize == 0 ) then return end

		self:MouseCapture( true )
		self.Dragging = true

		local x, y = self.btnGrip:ScreenToLocal( 0, gui.MouseY() )
		self.HoldPos = y

		self.btnGrip.Depressed = true

	end

	function PANEL:PerformLayout()

		local Wide = self:GetWide()
		local BtnHeight = Wide
		if ( self:GetHideButtons() ) then BtnHeight = 0 end
		local Scroll = self:GetScroll() / self.CanvasSize
		local BarSize = math.max( self:BarScale() * ( self:GetTall() - ( BtnHeight * 2 ) ), 10 )
		local Track = self:GetTall() - ( BtnHeight * 2 ) - BarSize
		Track = Track + 1

		Scroll = Scroll * Track

		self.btnGrip:SetPos( 0, BtnHeight + Scroll )
		self.btnGrip:SetSize( Wide, BarSize )

		if ( BtnHeight > 0 ) then
			self.btnUp:SetPos( 0, 0, Wide, Wide )
			self.btnUp:SetSize( Wide, BtnHeight )

			self.btnDown:SetPos( 0, self:GetTall() - BtnHeight )
			self.btnDown:SetSize( Wide, BtnHeight )
			
			self.btnUp:SetVisible( true )
			self.btnDown:SetVisible( true )
		else
			self.btnUp:SetVisible( false )
			self.btnDown:SetVisible( false )
			self.btnDown:SetSize( Wide, BtnHeight )
			self.btnUp:SetSize( Wide, BtnHeight )
		end

	end

	derma.DefineControl( "DVScrollBar", "A Scrollbar", PANEL, "Panel" )

	net.Receive("CHAT_WarnOpen", function() -- 여기
		local WarnMenu = vgui.Create("WarnMenu")
	end)
end