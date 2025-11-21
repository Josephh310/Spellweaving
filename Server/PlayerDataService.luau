local PlayerData = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ProfileStore = require(ReplicatedStorage.Library.ProfileStore)
local Observers = require(ReplicatedStorage.Library.Observers)
local Signal = require(ReplicatedStorage.Library.Signal)
local PlayerStats = require(ReplicatedStorage.Shared.Data.PlayerStats)
local PlayerDataUtils = require(ReplicatedStorage.Shared.Modules.PlayerDataUtils)

--Remotes
local Remotes = ReplicatedStorage.Remotes
local GetPlayerSave = Remotes.GetPlayerSave
local ReplicateSaveChange = Remotes.ReplicateSaveChange

--Vars
PlayerData.DataStore = ProfileStore.New("DataStore", PlayerStats.Template)
PlayerData.Profiles = {} :: {[Player]: Profile}

--Types
export type Profile = ProfileStore.Profile<typeof(PlayerStats.Template)>

--Config
local MOCK_STORE_IN_STUDIO = false

--Private functions
local function InitProfile(Player: Player, Profile: Profile)
	Profile:Reconcile()
	Profile.OnSessionEnd:Connect(function()
		PlayerData.Profiles[Player] = nil
		Player:Kick("Profile session ended, please rejoin.")
	end)
	if Player.Parent == Players then
		PlayerData.Profiles[Player] = Profile
		Player:SetAttribute("ProfileReady", true)
	else
		Profile:EndSession()
	end
end

local function LoadProfile(Player: Player)
	local ProfileKey = tostring(Player.UserId)
	local NewProfile = PlayerData.DataStore:StartSessionAsync(ProfileKey)
	if NewProfile == nil then
		Player:Kick("Profile load failed, please rejoin.")
		return;
	end
	InitProfile(Player, NewProfile)
end

local function RemoveProfile(Player: Player)
	local PlayerProfile = PlayerData.Profiles[Player]
	if PlayerProfile ~= nil then
		PlayerProfile:EndSession()
	end
end

local function CriticalStatusChanged(IsCritical: boolean)
	if IsCritical == true then
		print(`ProfileStore entered critical state`)
	else
		print(`ProfileStore critical state is over`)
	end
end

local function CreateLeaderstats(Player: Players)
	local leaderstats = Instance.new("Folder", Player)
	leaderstats.Name = "leaderstats"
	for Index, Leaderstat in PlayerStats.Leaderstats do
		local LeaderstatValue = Instance.new("IntValue", leaderstats)
		LeaderstatValue.Name = Leaderstat
		LeaderstatValue.Value = PlayerData.GetValue(Player, {Leaderstat})
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

--Public functions
function PlayerData.GetProfile(Player: Player)
	return PlayerData.Profiles[Player].Data
end

function PlayerData.GetValue(Player: Player, Path: {string})
	local PlayerSave = PlayerData.GetProfile(Player)
	return PlayerDataUtils.GetNestedValue(PlayerSave, Path)
end

function PlayerData.SetValue(Player: Player, Path: {string}, Value: any)
	local PlayerSave = PlayerData.GetProfile(Player)
	local Success = PlayerDataUtils.SetNestedValue(PlayerSave, Path, Value)
	if Success ~= true then
		error(`Unable to set {table.concat(Path, "/")} to value {Value}`)
	end
	ReplicateSaveChange:FireClient(Player, Path, Value)
	if #Path == 1 then
		local leaderstat = Player.leaderstats:FindFirstChild(Path[1])
		if leaderstat then
			leaderstat.Value = Value
		end
	end
	return true
end

function PlayerData.ApplyChange(Player: Player, Path: {string}, ChangeCallback: () -> (), ...)
	local PlayerProfile = PlayerData.Profiles[Player]
	if PlayerProfile and PlayerProfile:IsActive() then
		local PathValue = PlayerData.GetValue(Player, Path)
		local NewValue = ChangeCallback(PathValue, ...)
		PlayerData.SetValue(Player, Path, NewValue)
	end
end

function PlayerData.Init()
	if MOCK_STORE_IN_STUDIO and RunService:IsStudio() then
		PlayerData.DataStore = PlayerData.DataStore.Mock
	end
	GetPlayerSave.OnServerInvoke = PlayerData.GetProfile
	ProfileStore.OnCriticalToggle:Connect(CriticalStatusChanged)
	for _, Player in Players:GetPlayers() do
		PlayerAdded(Player)
	end
	Players.PlayerAdded:Connect(PlayerAdded)
	Players.PlayerRemoving:Connect(PlayerRemoved)
end

return PlayerData