--[[
	@Title: 
		Player data controller
	@Author:
		Joseph (@BreakLoop)
	@Description:
		Handles player data on the client
		Loads player data from the server,
		Fires signals when player data notably changes
]]

local PlayerDataController = {}

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
function PlayerDataController.SetLocalValue(Path: {string}, Value: any)
	local Success = PlayerDataUtils.SetNestedValue(PlayerDataController.Data, Path, Value)
	if Success ~= true then
		error(`Unable to set {table.concat(Path, "/")} to value {Value}`)
	end
	local PrimaryPath = Path[1]
	if PlayerDataController.ChangedSignals[PrimaryPath] then
		PlayerDataController.ChangedSignals[PrimaryPath]:Fire(Value)
	end
	return true
end

function PlayerDataController.GetLocalValue(Path: {string}, Value: any)
	return PlayerDataUtils.GetNestedValue(PlayerDataController.Data, Path, Value)
end

function PlayerDataController.ConnectToValueChanged(ValueName: string, Callback: () -> ()): Signal.Connection
	if not PlayerDataController.ChangedSignals[ValueName] then
		PlayerDataController.ChangedSignals[ValueName] = Signal.new()
	end
	if Callback then
		Callback(PlayerDataController.Data[ValueName])
		return PlayerDataController.ChangedSignals[ValueName]:Connect(Callback)
	end
end

--Initialize
do
	if Player:GetAttribute("ProfileReady") ~= true then Player:GetAttributeChangedSignal("ProfileReady"):Wait() end --Yield until profile is ready
	PlayerDataController.Data = GetPlayerSave:InvokeServer()
	ReplicateSaveChange.OnClientEvent:Connect(PlayerDataController.SetLocalValue)
	PlayerDataController.ChangedSignals = {}
	PlayerDataController.Ready = true
end

return PlayerDataController