local PlayerData = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ProfileStore = require(ReplicatedStorage.Library.ProfileStore)
local Observers = require(ReplicatedStorage.Library.Observers)
local Signal = require(ReplicatedStorage.Library.Signal)
local PlayerSaveTemplate = require(ReplicatedStorage.Shared.Data.PlayerSaveTemplate)

--Types
export type Profile = ProfileStore.Profile<typeof(PlayerSaveTemplate)>

--Helper functions
function ObservePlayerAdded(Player: Player)
	print(`{Player} has joined the game.`)
	PlayerData._loadProfile(Player)
	return function(Reason: string)
		print(`{Player} has left the game. Reason: {Reason}`)
		PlayerData._removeProfile(Player)
	end
end

function CriticalStatusChanged(IsCritical: boolean)
	if IsCritical == true then
		print(`ProfileStore entered critical state`)
	else
		print(`ProfileStore critical state is over`)
	end
end

--Private functions
function PlayerData._initProfile(Player: Player, Profile: Profile)
	Profile:Reconcile()
	Profile.OnSessionEnd:Connect(function()
		PlayerData.Profiles[Player] = nil
		Player:Kick("Profile session ended, please rejoin.")
	end)
	if Player.Parent == Players then
		PlayerData.Profiles[Player] = Profile
		print(`Profile loaded for {Player}!`)
	else
		Profile:EndSession()
	end
end

function PlayerData._loadProfile(Player: Player)
	local ProfileKey = tostring(Player.UserId)
	local NewProfile = PlayerData.DataStore:StartSessionAsync(ProfileKey)
	if NewProfile == nil then
		Player:Kick("Profile load failed, please rejoin.")
		return;
	end
	PlayerData._initProfile(Player, NewProfile)
end

function PlayerData._removeProfile(Player: Player)
	local PlayerProfile = PlayerData.Profiles[Player]
	if PlayerProfile ~= nil then
		PlayerProfile:EndSession()
	end
end

--Public functions
function PlayerData.Start()
	Observers.observePlayer(ObservePlayerAdded)
	ProfileStore.OnCriticalToggle:Connect(CriticalStatusChanged)
end

function PlayerData.Init()
	PlayerData.DataStore = ProfileStore.New("DataStore", PlayerSaveTemplate)
	PlayerData.Profiles = {} :: {[Player]: Profile}
end

return PlayerData