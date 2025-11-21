local PlayerData = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Observers = require(ReplicatedStorage.Library.Observers)
local Signal = require(ReplicatedStorage.Library.Signal)
local PlayerDataUtils = require(ReplicatedStorage.Shared.Modules.PlayerDataUtils)

--Remotes
local Remotes = ReplicatedStorage.Remotes
local GetPlayerSave = Remotes.GetPlayerSave
local ReplicateSaveChange = Remotes.ReplicateSaveChange

--Utiltiy functions
local function LoadProfile()
	local Profile = GetPlayerSave:InvokeServer()
	for Index, Value in Profile do
		if PlayerData.ChangedSignals[Index] then
			PlayerData.ChangedSignals[Index]:Fire()
		end
	end
end

--Public functions
function PlayerData.SetLocalValue(Path: {string}, Value: any)
	local CurrentDirectory = PlayerData.Profile
	for Index, DirectoryName in ipairs(Path) do
		if Index == #Path then
			CurrentDirectory[DirectoryName] = Value
			if PlayerData.ChangedSignals[Path[1]] then
				PlayerData.ChangedSignals[Path[1]]:Fire(Value)
			end
			return;
		end
		local NewDirectory = CurrentDirectory[DirectoryName]
		if not NewDirectory then
			error(`{DirectoryName} is not a valid member of {Path[Index-1]}`)
		end
		CurrentDirectory = NewDirectory
	end
end

function PlayerData.GetValueChangedSignal(ValueName: string): Signal.Signal<any>
	if not PlayerData.ChangedSignals[ValueName] then
		PlayerData.ChangedSignals[ValueName] = Signal.new()
	end
	task.defer(function()
		if PlayerData.Profile[ValueName] then
			PlayerData.ChangedSignals[ValueName]:Fire(PlayerData.Profile[ValueName])
		end
	end)
	return PlayerData.ChangedSignals[ValueName]
end

function PlayerData.Init()
	PlayerData.ChangedSignals = {}
	repeat task.wait() until Player:GetAttribute("ProfileReady") == true -- Yield until the player's save is ready
	PlayerData.Profile = LoadProfile()
	ReplicateSaveChange.OnClientEvent:Connect(PlayerData.SetLocalValue)
end

return PlayerData