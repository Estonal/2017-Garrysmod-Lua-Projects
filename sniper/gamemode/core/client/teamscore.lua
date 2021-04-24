local function CalculateKD(kill,death)
	if ( kill+death) == 0 then
		return "-"
	end
	return math.Round((kill / (kill+death))*100,2) .. "%"
end


hook.Add("ScoreboardShow", "스코어보드", function()
	spectatelist = {}
surface.CreateFont( "TheDefaultSettings", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 25,
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
surface.CreateFont( "TheDefaultSettings2", {
	font = "Arial",
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
	shadow = true,
	additive = false,
	outline = false,
} ) 
hook.Add("HUDPaint", "스코어보드허드", function()
    draw.RoundedBox(10,200,0,ScrW()-400,ScrH(),Color(0,0,0,127))
    draw.RoundedBox(0,200,0,ScrW()-400,125,Color(0,0,10, 200))
	draw.SimpleText( "맵: ".. game.GetMap(), "TheDefaultSettings", 200, 50, Color(255,255,255), 0,0 )
	draw.SimpleText(GetHostName(), "TheDefaultSettings2", 200, 0, Color(255,255,255), 0,0 ) 
	draw.RoundedBox(10,200,90,ScrW()-400,35,Color(0,0,0,225))
	draw.SimpleText( "테러리스트", "TheDefaultSettings", 210, 92, Color(255,255,255), 0,0 )
	draw.RoundedBox(10,200,ScrH()-50,ScrW()-400,ScrH(),Color(0,0,0,255))
	draw.SimpleText( "관전자:", "TheDefaultSettings", 210, ScrH()-50, Color(255,255,255), 0,0 )
draw.SimpleText( "대 테러리스트", "TheDefaultSettings", ScrW()-340, 92, Color(255,255,255), 0,0 )
	draw.RoundedBox(10,200,125,ScrW()-400,35,Color(0,0,50,225))
	draw.SimpleText( "이름                    ㅣ    퍼센트    ㅣ     살음/죽음     ㅣ     핑     ㅣ", "TheDefaultSettings", 210, 128, Color(255,255,255), 0,0 )
	draw.SimpleText( "   이름                    ㅣ    퍼센트    ㅣ     살음/죽음     ㅣ     핑     ㅣ", "TheDefaultSettings", 190+(ScrW()-400)/2, 128, Color(255,255,255), 0,0 )
	local i = 1
	local j = 1
	for k,v in pairs(team.GetPlayers( 1 )) do
		draw.RoundedBox(10,200,125+i*35,(ScrW()-400)/2,35,Color(255,0,0,150))
		draw.SimpleText(v:Name(),"TheDefaultSettings", 200,127+i*35,Color(255,255,255),0,0)
		draw.SimpleText(v:Ping(),"TheDefaultSettings", 727,127+i*35,Color(0,0,0),0,0)
		if v:Alive() then
			draw.SimpleText("살음","TheDefaultSettings", 578,127+i*35,Color(255,255,255),0,0)
		else
			draw.SimpleText("죽음","TheDefaultSettings", 578,127+i*35,Color(255,255,255),0,0)
		end
		
		draw.SimpleText(CalculateKD(v:Frags(),v:Deaths()),"TheDefaultSettings", 415,127+i*35,Color(255,255,255),0,0)
		i=i+1 
	end
	for k,v in pairs(team.GetPlayers( 2 )) do
		draw.RoundedBox(10,ScrW()/2,125+j*35,(ScrW()-400)/2,35,Color(0,0,255,150))
		draw.SimpleText(v:Name(),"TheDefaultSettings", (ScrW()-445)/2+230,127+j*35,Color(255,255,255),0,0)
		draw.SimpleText(v:Ping(),"TheDefaultSettings", (ScrW()-27)/2+540,127+j*35,Color(0,0,0),0,0)
		if v:Alive() then
			draw.SimpleText("살음","TheDefaultSettings", ScrW()/2+375,127+j*35,Color(255,255,255),0,0)
		else
			draw.SimpleText("죽음","TheDefaultSettings", ScrW()/2+375,127+j*35,Color(255,255,255),0,0)
		end
		
			draw.SimpleText(CalculateKD(v:Frags(),v:Deaths()),"TheDefaultSettings", ScrW()/2+215,127+j*35,Color(255,255,255),0,0)
		j=j+1
	end

end)
return true
end)


hook.Add("ScoreboardHide", "스코어보드허드", function()

	hook.Remove("HUDPaint", "스코어보드허드")
end)

	