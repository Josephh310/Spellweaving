local PlayerData = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ProfileStore = require(ReplicatedStorage.Library.ProfileStore)
local PlayerStats = require(ReplicatedStorage.Shared.Data.PlayerStats)
local PlayerDataUtils = require(ReplicatedStorage.Shared.Utilities.PlayerDataUtils)

--Directories
local Remotes = ReplicatedStorage.Remotes
local Events = ServerScriptService.Events

--Values
local DataStore = ProfileStore.New("DataStore", PlayerStats.Template)
local Profiles = {} :: {[Player]: Profile}
local MOCK_STORE_IN_STUDIO = false

--Types
export type Profile = ProfileStore.Profile<typeof(PlayerStats.Template)>

--Functions
local function InitProfile(Player: Player, Profile: Profile)
	Profile:Reconcile()
	Profile.OnSessionEnd:Connect(function()
		Profiles[Player] = nil
		Player:Kick("Profile session ended, please rejoin.")
	end)
	if Player.Parent == Players then
		Profiles[Player] = Profile
	else
		Profile:EndSession()
	end
end

local function LoadProfile(Player: Player)
	local ProfileKey = tostring(Player.UserId)
	local NewProfile = DataStore:StartSessionAsync(ProfileKey)
	if NewProfile == nil then
		Player:Kick("Profile load failed, please rejoin.")
		return;
	end
	InitProfile(Player, NewProfile)
end

local function RemoveProfile(Player: Player)
	local PlayerProfile = Profiles[Player]
	if PlayerProfile ~= nil then
		PlayerProfile:EndSession()
	end
end

local function GetProfile(Player: Player)
	if not Profiles[Player] then
		repeat task.wait() until Profiles[Player] ~= nil
	end
	return Profiles[Player].Data
end

local function GetValue(Player: Player, Path: {string})
	local PlayerSave = GetProfile(Player)
	return PlayerDataUtils.GetNestedValue(PlayerSave, Path)
end

local function CreateLeaderstats(Player: Players)
	local leaderstats = Instance.new("Folder", Player)
	leaderstats.Name = "leaderstats"
	for Index, Leaderstat in PlayerStats.Leaderstats do
		local LeaderstatValue = Instance.new("IntValue", leaderstats)
		LeaderstatValue.Name = Leaderstat
		LeaderstatValue.Value = GetValue(Player, {Leaderstat})
	end
end

local function SetValue(Player: Player, Path: {string}, Value: any)
	local PlayerSave = GetProfile(Player)
	local Success = PlayerDataUtils.SetNestedValue(PlayerSave, Path, Value)
	if Success ~= true then
		error(`Unable to set {table.concat(Path, "/")} to value {Value}`)
		return;
	end
	Remotes.ReplicateSaveChange:FireClient(Player, Path, Value)
	if #Path == 1 then
		local leaderstat = Player.leaderstats:FindFirstChild(Path[1])
		if leaderstat then
			leaderstat.Value = Value
		end
	end
	return true
end

local function ApplyChange(Player: Player, Path: {string}, ChangeCallback: () -> (), ...)
	local PlayerProfile = Profiles[Player]
	if PlayerProfile and PlayerProfile:IsActive() then
		local PathValue = GetValue(Player, Path)
		local NewValue = ChangeCallback(PathValue, ...)
		SetValue(Player, Path, NewValue)
	end
end

local function PlayerAdded(Player: Player)
	print(`{Player} has joined the game.`)
	LoadProfile(Player)
	CreateLeaderstats(Player)
end

local function PlayerRemoved(Player: Player)
	print(`{Player} has left the game.`)
	RemoveProfile(Player)
end

local function CriticalStatusChanged(IsCritical: boolean)
	if IsCritical == true then
		print(`ProfileStore entered critical state`)
	else
		print(`ProfileStore critical state is over`)
	end
end

--Init functions
function PlayerData.Start()
	for _, Player in Players:GetPlayers() do 
		PlayerAdded(Player) 
	end
	Players.PlayerAdded:Connect(PlayerAdded)
	Players.PlayerRemoving:Connect(PlayerRemoved)
end

function PlayerData.Init()
	if MOCK_STORE_IN_STUDIO and RunService:IsStudio() then
		DataStore = DataStore.Mock
	end
	Events.GetPlayerData.OnInvoke = GetValue
	Events.ChangePlayerData.OnInvoke = ApplyChange
	Remotes.GetPlayerSave.OnServerInvoke = GetProfile
	ProfileStore.OnCriticalToggle:Connect(CriticalStatusChanged)
end

return PlayerData