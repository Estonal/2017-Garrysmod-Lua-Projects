surface.CreateFont( "TheDefaultSettings", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 30,
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

net.Receive("PSHelperManage",function()

local Weapons = net.ReadTable()
local frame = vgui.Create( "DFrame" )
frame:SetSize( 700, 500 )
frame:Center()
frame:MakePopup()

local sweplist = vgui.Create( "DListView", frame )
sweplist:SetMultiSelect( false )
sweplist:AddColumn("Weapon")
sweplist:AddColumn("WeaponClass")
sweplist:SetPos( 20, 20)
sweplist:SetSize( 660, 460 )
for k,weapon in pairs(Weapons) do
sweplist:AddLine(weapon.PrintName, weapon.ClassName)
end
function sweplist:DoDoubleClick( lineID, line )
	local selectedswep = line:GetColumnText(1)
	local selectedswepclass = line:GetColumnText(2)

	local swepname = vgui.Create("DLabel", frame)
	swepname:SetPos(20, 50)
	swepname:SetSize(410,50)
	swepname:SetTextColor( Color(255,255,0,255) )
	swepname:SetText("SWEPName: "..selectedswep)
	sweplist:SetVisible( false )

	local price = vgui.Create( "DTextEntry", frame )
	price:SetPos( 20, 100 )
	price:SetSize( 660, 30 )
	price:SetText( "price" )
	price.OnEnter = function()
		Sendinform(Weapons, selectedswep, selectedswepclass,price:GetValue())
		frame:Close()

	end

end

end)

function Sendinform(weapons, swepname, swepclass ,price)
	net.Start("giveoffweapon")
	for k,weapon in pairs(weapons) do
		if weapon.PrintName == swepname then
			if weapon.ClassName == swepclass then
			net.WriteTable(weapon)
			break
			end
		end
	end
	net.WriteInt(price,32)
	net.SendToServer()
end