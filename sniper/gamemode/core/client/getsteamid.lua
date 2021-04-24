-- AAAAAAA
net.Receive('getyoursteamid',function()
net.Start('newbieoruser')
	net.WriteString(LocalPlayer():SteamID())
	net.WriteEntity(LocalPlayer())
net.SendToServer()
end)