-- AAAAAAA
Controlnumber = 0
Selectnums = 0
surface.CreateFont( "mapchangefont", {
    font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    size = 100,
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
net.Receive("Votemapsend",function()
    if Controlnumber == 0 then
	local votemapname = net.ReadTable()
    votemappanel = vgui.Create("DFrame")
	votemappanel:SetVisible(true)
	votemappanel:SetPos(0, 0)
    votemappanel:SetSize(ScrW(), ScrH())
    votemappanel:Center()
    votemappanel:SetTitle("MapChange")
    votemappanel:ShowCloseButton(false)
    votemappanel:SetDraggable(false)
    votemappanel:MakePopup()
    function votemappanel:Paint(w, h)
    draw.RoundedBox(3,0,0,w,h,Color(0,0,0,200))
    end
	local scrollpanel = votemappanel:Add("DScrollPanel")
    scrollpanel:SetPos(10, 10)
    scrollpanel:SetSize(votemappanel:GetWide() - 20 + 16, votemappanel:GetTall() - 20)
    for i=1, #votemapname do
    	local mapbutton = scrollpanel:Add("DButton")
    	mapbutton:SetSize(votemappanel:GetWide() - 16, 30)
    	mapbutton:SetPos(0, i*35)
    	mapbutton:SetText(votemapname[i])
        function mapbutton:Paint(w, h)
            draw.RoundedBox(3,0,0,w,h,Color(0,0,25,210))
        end
    	mapbutton.DoClick = function()
        Selectnums = Selectnums + 1
        if Selectnums == 1 then
        function mapbutton:Paint(w, h)
            draw.RoundedBox(3,0,0,w,h,Color(127,127,200,210))
        end
		net.Start("MapCheckout")
		for i=1, #votemapname do
		if mapbutton:GetText() == votemapname[i] then
			net.WriteInt(i, 16)
			break
		end
		end
		net.SendToServer()
        timer.Simple(1, function() votemappanel:Close() end)
        end
    	end
    end
    Controlnumber = 1
    end

end)

net.Receive("Votestop", function()
    votemappanel:Close()
end)