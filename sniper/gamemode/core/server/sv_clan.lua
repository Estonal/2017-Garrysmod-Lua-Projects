util.AddNetworkString('PlySay_')
util.AddNetworkString("clan_manage")
util.AddNetworkString('hasclancheck')

/* clandata값
clandata = {}
clandata.name = ???
clandata.color = ??? green, blue 등
clandata.title = "[바나나]" 등
clandata.earnpoint = 이 클랜의 포인트 배율
clandata.clanpoint = ?? 클랜전 포인트
clandata.clanrating = ?? 클랜전 등급
clandata.unique = 유니크아디
clandata.owner = UniqueID()
*/

local pla = FindMetaTable('Player')

function pla:AddClan(clandata)

local clan = clandata
if clan == 0 then return end
clan.earnpoint = 1    -- 포인트 배율(클랜에 소속되어있을경우)
clan.clanpoint = 0
clan.clanrating = 0
clan.owner = self:UniqueID()

local tab = GetAllClanName() or 0
if tab != 0 then
for k,v in pairs(tab) do
if v == clan.name then
	return 0
end
end

end
file.CreateDir('clandata/'..clan.name)
file.Write('clandata/'..clan.name..'/settings.txt', util.TableToJSON(clan))
self:ChatPrint("당신은 "..clan.name.." 클랜을 만들었습니다!")
ClanAddPlayer(self, clan.name)
end

function pla:GetClanSettings()

local clanname = self:GetClanName()
local data = {}
if clanname != 0 then
local data = util.JSONToTable(file.Read('clandata/'..clanname..'/settings.txt', 'DATA'))
return data

else

data.earnpoint = 1
return data

end
end

function pla:ChangeOwner(ply)
	local clanname = self:GetClanName()
	if self:IsClanOwner(clanname) && ply:GetClanName() == clanname then
		if self:UniqueID() != ply:UniqueID() then
			local data = util.JSONToTable(file.Read('clandata/'..clanname..'/settings.txt'))
			data.owner = ply:UniqueID()
			file.Write('clandata/'..clanname..'/settings.txt', util.TableToJSON(data))
		end
	end

end

function SetClanPoint(clanname, num)
local data = util.JSONToTable(file.Read('clandata/'..clanname..'/settings.txt', "DATA"))
data.clanpoint = num
file.Write('clandata/'..clanname..'/settings.txt', data)
end

function SetClanRating(clanname, num)
local data = util.JSONToTable(file.Read('clandata/'..clanname..'/settings.txt', "DATA"))
data.clanrating = num
file.Write('clandata/'..clanname..'/settings.txt', data)
end

function SetClanEarnPoint(clanname, num)
local data = util.JSONToTable(file.Read('clandata/'..clanname..'/settings.txt', "DATA"))
data.earnpoint = num
file.Write('clandata/'..clanname..'/settings.txt', data)
end

function ClanAddPlayer(target, clanname)

local playerdata = {}
playerdata.name = target:Nick()
playerdata.Steamid = target:SteamID()
playerdata.kill = util.JSONToTable(file.Read('kddata/'..string.gsub(target:SteamID(),':','_')..'.txt')).Kill
playerdata.death = util.JSONToTable(file.Read('kddata/'..string.gsub(target:SteamID(),':','_')..'.txt')).Death
playerdata.Unique = target:UniqueID()

file.Write('clandata/'..clanname..'/'..target:UniqueID()..'.txt', util.TableToJSON(playerdata))

end

function GetAllClanName()

local _,clanlist = file.Find('clandata/*',"DATA")
if clanlist != nil then
return clanlist
end
return 0
end

function pla:GetClanName()

local allclan = GetAllClanName()
	for k,v in pairs(allclan) do
		local filelist, directorieslist = file.Find('clandata/'..v..'/*',"DATA")
		for ke, va in pairs(filelist) do
			if va != 'settings.txt' then
				local checkfilename = string.Explode(".", va)
				if checkfilename[1] == self:UniqueID() then
					return v
				end
			end
		end
	end

	return 0

end

function pla:GetPlayerClanData()

	local folder = self:GetClanName()
	if folder != 0 then
	local playerdata = util.JSONToTable(file.Read('clandata/'..folder..'/'..self:UniqueID()..".txt")) or 0
	return playerdata
	end

end

function pla:ChangeClan(clanname)

	if !(self:IsClanOwner()) then
	local old = self:GetClanName()
	local new = clanname
	local playerdata = self:GetClanData()
	if file.Exists('clandata/'..old..'/'..self:UniqueID()..".txt", "DATA") then
		if file.Exists('clandata/'..new, "DATA") then
			file.Delete( 'clandata/'..old..'/'..self:UniqueID()..'.txt' )
			file.Write('clandata/'..new..'/'..self:UniqueID()..'.txt', util.TableToJSON(playerdata))
		end
	end
	end
end

function pla:RemoveClan(clanname)
	if self:IsClanOwner() then
	file.Delete('clandata/'..clanname..'/' )
	self:ChatPrint("성공적으로 클랜이 삭제되었습니다!")
	end

end

function pla:QuitClan()
file.Delete('clandata/'..self:GetClanName()..'/'..self:UniqueID()..'.txt')
end

function ClanDeletePlayer(clanname, uniqueid)
	file.Delete('clandata/'..clanname..'/'..uniqueid..'.txt')
end

function pla:IsClanOwner(clanname)

local data = self:GetClanSettings()
if data.owner == self:UniqueID() then
return true
else
return false
end

end

function pla:InviteClan(target, clanname)
	if self:GetClanName() != 0 && target:GetClanName() == 0 then
	if self:IsClanOwner(self:GetClanName()) then
			target:ChatPrint(clanname.."클랜에 초대되셨습니다! !클랜수락 "..clanname.." 또는 !클랜거절 "..clanname)
			target.InvitedClan = clanname
	else
		self:ChatPrint("당신은 클랜장이 아닙니다!")
	end
	else
		self:ChatPrint("초대받을 플레이어가 이미 클랜이 있거나 당신은 클랜이 없습니다!")
	end
end

function pla:DenyClan(clanname)
	if self.InvitedClan != 0 then
	if self:GetClanName() == 0 then
		for k,v in pairs(GetAllClanName()) do
		if clanname == v then
			self.InvitedClan = 0
			self:ChatPrint("당신은 "..clanname.."클랜의 초대를 거절하셨습니다!")
		end
		end
	end
	else
	self:ChatPrint("당신은 어떠한 클랜의 초대도 받지 않았습니다!")
end
end

function GetClanPlayers(clanname)
	local data = {}
	local files, directories = file.Find('clandata/'..clanname..'/*.txt','DATA')
	for k,v in pairs(files) do
		if v != 'settings.txt' then

		table.insert(data, util.JSONToTable(file.Read("clandata/"..clanname.."/"..v)))
		end
	end
	return data
end

function pla:AcceptClan(clanname)
	if self:GetClanName() == 0 then
		if self.InvitedClan == clanname then
		ClanAddPlayer(self, clanname)
		self:ChatPrint('클랜에 가입했습니다!')
			self.InvitedClan = 0

		else
			self:ChatPrint("당신은 어떠한 클랜의 초대도 받지 않았습니다!")
		end

	end
end

net.Receive('PlySay_', function()
	local sender = net.ReadEntity()
	local text = net.ReadString()

	local commandTable = string.Explode(' ', text)
	if commandTable[1] == '!클랜제작' then
		local data = {}
		data.name = commandTable[2]
		data.color = commandTable[3]
		data.title = commandTable[4]
		sender:AddClan(data)

	end
	

	if commandTable[1] == '!클랜초대' then
		if sender:GetClanName() != 0 then
			if sender:IsClanOwner() then

			sender:InviteClan(FindPlayerTable(commandTable[2]), sender:GetClanName())

			end
		end
	end

	if commandTable[1] == '!클랜수락' then
		if sender:GetClanName() == 0 then
			sender:AcceptClan(commandTable[2])
		end
	end

	if commandTable[1] == '!클랜거절' then
		sender:DenyClan(commandTable[2])

	end

	if commandTable[1] == '!클랜' then
		if sender:GetClanName() != 0 then
			net.Start('clan_manage')
			net.WriteTable(GetClanPlayers(sender:GetClanName()))
			net.WriteString(sender:GetClanName())
			if sender:IsClanOwner() then
				net.WriteBool(true)
			else
				net.WriteBool(false)
			end
			net.Send(sender)
		end
	end

	if commandTable[1] == '!클랜추방' then
		if sender:GetClanName() != 0 then
			if sender:IsClanOwner(sender:GetClanName()) then
				local data = GetClanPlayers(sender:GetClanName())
				for k,v in pairs(data) do
					if v.name == commandTable[2] then
						ClanDeletePlayer(sender:GetClanName(), v.Unique)
					end
				end
			end
		end
	end

end)

function FindPlayerTable(str)
for k,v in pairs(player.GetAll()) do
	if v:Nick() == str or v:SteamID() == str or v:UniqueID() == str then
		return v
	end
end
return 0
end


hook.Add("PlayerInitialSpawn", "Clanspawn", function( ply )
	ply.InvitedClan = 0

end)

hook.Add("Think", "Clanthink", function()
	for k,v in pairs(player.GetAll()) do
	net.Start("hasclancheck")
		if v:GetClanName() != 0 then
		net.WriteBool(true)
		net.WriteString(v:GetClanSettings().title)
		else
		net.WriteBool(false)
		net.WriteString('0')
		end
	net.Send(v)
	end




	for k,target in pairs(player.GetAll()) do
	if target:GetClanName() != 0 then

	local clanname = target:GetClanName()
	local playerdata = {}
	playerdata.name = target:Nick()
	playerdata.Steamid = target:SteamID()
	playerdata.kill = util.JSONToTable(file.Read('kddata/'..string.gsub(target:SteamID(),':','_')..'.txt')).Kill
	playerdata.death = util.JSONToTable(file.Read('kddata/'..string.gsub(target:SteamID(),':','_')..'.txt')).Death
	playerdata.Unique = target:UniqueID()

	if target:IsClanOwner(clanname) then
	playerdata.position = '클랜장'
	else
	playerdata.position = '클랜원'
	end

	file.Write('clandata/'..clanname..'/'..target:UniqueID()..'.txt', util.TableToJSON(playerdata))
	end
	end

end)