util.AddNetworkString("PSHelperManage")
util.AddNetworkString("giveoffweapon")
util.AddNetworkString("PSHelper_someonemadefile")
if !file.Exists("PSHelper", "DATA") then
file.CreateDir("PSHelper")
end

net.Receive("giveoffweapon",function()
	local sweptable = net.ReadTable()
	local price = net.ReadInt(32)
	local name = sweptable.PrintName
	local weaponclass = weapons.GetStored( sweptable.ClassName )
	local worldmodel = weaponclass.WorldModel
	local i=1
	while 1 do
	if !file.Exists("pshelper/"..name..i..".txt", "DATA") then
	file.Write("pshelper/"..name..i..".txt", "ITEM.Name = '"..name.."'\nITEM.Price = "..price.."\nITEM.Model = \""..worldmodel.."\"\nITEM.WeaponClass = '"..sweptable.ClassName.."'\nITEM.SingleUse = false\n\nfunction ITEM:OnBuy(ply)\nend\n\nfunction ITEM:OnSell(ply)\nply:StripWeapon(self.WeaponClass)\nend\n\nfunction ITEM:OnEquip(ply, modifications)\nply:Give(self.WeaponClass)\nply:SelectWeapon(self.WeaponClass)\nend\n\nfunction ITEM:OnHolster(ply)\nply:StripWeapon(self.WeaponClass)\nend")
	break
	end
	i=i+1
	end
end)


hook.Add("PlayerSay","PSHelperCheck",function(sender, text, teamchat)
	if text == "!포샵무기" then
		net.Start("PSHelperManage")
		net.WriteTable( list.Get("Weapon") )
		net.Send(sender)
	end


end)