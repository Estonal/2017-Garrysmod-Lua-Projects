net.Receive("show_ranking",function(len, ply)


	w,h = 600, 500
	ranksdata = net.ReadTable()
	local Ranking = vgui.Create( "DFrame" )
	Ranking:SetPos( ScrW()/2-w/2, ScrH()/2-h/2 )
	Ranking:SetSize( w, h )
	Ranking:SetTitle( "랭크" )
	Ranking:SetDraggable( true )
	Ranking:MakePopup()
	function Ranking:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
	draw.RoundedBox( 0, 0, 0, w, 25, Color( 100, 100, 255 ) )
	end


	local AppList = vgui.Create( "DListView", Ranking )
	AppList:Dock( FILL )
	AppList:SetMultiSelect( false )
	AppList:AddColumn( "등수" )
	AppList:AddColumn( "닉네임" )
	AppList:AddColumn( "킬" )
	AppList:AddColumn( "데스" )
	AppList:AddColumn( "퍼센트" )
	AppList:SetSortable( false )

	for k,v in pairs(ranksdata["kills"]) do
	AppList:AddLine( k, ranksdata["nicknames"][k], v, ranksdata["deaths"][k], math.Round(v/(v+ranksdata["deaths"][k]) * 100 ) )
	end






end)