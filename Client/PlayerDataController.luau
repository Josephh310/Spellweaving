local PlayerData = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Observers = require(ReplicatedStorage.Library.Observers)
local Signal = require(ReplicatedStorage.Library.Signal)
local PlayerDataUtils = require(ReplicatedStorage.Shared.Utilities.PlayerDataUtils)

--Remotes
local Remotes = ReplicatedStorage.Remotes
local GetPlayerSave = Remotes.GetPlayerSave
local ReplicateSaveChange = Remotes.ReplicateSaveChange

--Public functions
function PlayerData.SetLocalValue(Path: {string}, Value: any)
	local Success = PlayerDataUtils.SetNestedValue(PlayerData.Data, Path, Value)
	if Success ~= true then
		error(`Unable to set {table.concat(Path, "/")} to value {Value}`)
	end
	local PrimaryPath = Path[1]
	if PlayerData.ChangedSignals[PrimaryPath] then
		PlayerData.ChangedSignals[PrimaryPath]:Fire(Value)
	end
	return true
end

function PlayerData.GetLocalValue(Path: {string}, Value: any)
	return PlayerDataUtils.GetNestedValue(PlayerData.Data, Path, Value)
end

function PlayerData.ConnectToValueChanged(ValueName: string, Callback: () -> ()): Signal.Connection
	if not PlayerData.ChangedSignals[ValueName] then
		PlayerData.ChangedSignals[ValueName] = Signal.new()
	end
	if Callback then
		Callback(PlayerData.Data[ValueName])
		return PlayerData.ChangedSignals[ValueName]:Connect(Callback)
	end
end

function PlayerData.Init()
	repeat task.wait() until Player:GetAttribute("ProfileReady") == true -- Yield until the player's save is ready
	PlayerData.Data = GetPlayerSave:InvokeServer()
	ReplicateSaveChange.OnClientEvent:Connect(PlayerData.SetLocalValue)
	PlayerData.ChangedSignals = {}
end

return PlayerData