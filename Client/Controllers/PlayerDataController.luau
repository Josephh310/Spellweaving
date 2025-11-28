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
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local PlayerDataUtils = require(ReplicatedStorage.Shared.Utilities.PlayerDataUtils)

--Constants
local Remotes = ReplicatedStorage.Remotes
local Events = ReplicatedFirst.Events
local LoadedData = nil :: {}
local ChangedSignals = {}

--Functions
local function SetLocalValue(Path: {string}, Value: any)
	local Success = PlayerDataUtils.SetNestedValue(LoadedData, Path, Value)
	if Success ~= true then
		error(`Unable to set {table.concat(Path, "/")} to value {Value}`)
	end
	local PrimaryPath = Path[1]
	if ChangedSignals[PrimaryPath] then
		ChangedSignals[PrimaryPath]:Fire(Value)
	end
	return true
end

local function GetLocalValue(Path: {string}, Value: any)
	return PlayerDataUtils.GetNestedValue(LoadedData, Path, Value)
end

local function ConnectToValueChanged(ValueName: string, Callback: () -> ()): Signal.Connection
	if not ChangedSignals[ValueName] then
		ChangedSignals[ValueName] = Instance.new("BindableEvent")
	end
	if Callback then
		Callback(LoadedData[ValueName])
		return ChangedSignals[ValueName].Event:Connect(Callback)
	end
end

--Init functions
function PlayerDataController.Init()
	LoadedData = Remotes.GetPlayerSave:InvokeServer()
	Remotes.ReplicateSaveChange.OnClientEvent:Connect(SetLocalValue)
	Events.GetLocalStatValue.OnInvoke = GetLocalValue
	Events.ConnectToStatChanged.OnInvoke = ConnectToValueChanged
end

return PlayerDataController