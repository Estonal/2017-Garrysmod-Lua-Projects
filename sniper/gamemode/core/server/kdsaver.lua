-- AAAAAAA
local Player = FindMetaTable("Player")

hook.Add("InitPostEntity","Folder Check AA",function()
	if !file.Exists('KDData','DATA') then
		file.CreateDir('kddata') 
	end
end)

hook.Add("PlayerInitialSpawn","Load KD",function(ply)
	ply:LoadKDInfo()
end)
hook.Add("PlayerDisconnected","Save KD",function(ply)
	ply:SaveKDInfo()
end)

function Player:LoadKDInfo()
	local SID = string.gsub(self:SteamID(),":","_");
	local Data = {}
	if file.Exists( "kddata/" .. SID .. ".txt" ,"DATA") then
		Data = util.JSONToTable(file.Read( "kddata/" .. SID .. ".txt" ))
	end
	
	self:SetFrags(Data.Kill or 0);
	self:SetDeaths(Data.Death or 0);
	
end

function Player:SaveKDInfo()
	local SID = string.gsub(self:SteamID(),":","_");
	
	local Data = {}
	Data.UniqueID = self:UniqueID()
	Data.SteamID = self:SteamID()
	Data.Nickname = self:Nick()
	Data.Kill = self:Frags()
	Data.Death = self:Deaths()
	file.Write("kddata/" .. SID .. ".txt", util.TableToJSON(Data))
end