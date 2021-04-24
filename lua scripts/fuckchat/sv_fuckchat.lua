local cursing = {
	"씨발",
	"개새끼",
	"병신",
	"애미",
	"느금",
	"시발"







}

hook.Add("PlayerSay", "cursingcheck", function(sender, text, teamchat)
	local string = text
	for k,v in pairs(cursing) do
		string = string.Replace(string, v, "**")

	end
	return string

end)