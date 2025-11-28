--[[
	@Title:
		Client game state controller
	@Author:
		Joseph (@BreakLoop)
	@Description:
		Observes the game state replicated by the server,
		and fires signals when the state notably changes.
]]
local GameStateController = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Signal = require(ReplicatedStorage.Library.Signal)
local Observers = require(ReplicatedStorage.Library.Observers)
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)

--Constants
local Events = ReplicatedFirst.Events
local GameStateChanged = Events.GameStateChanged
local GameStateTimerChanged = Events.GameStateTimerChanged

--local UserInterfaceController = require(ReplicatedFirst.Client.UserInterfaceController)
--local StateFunctions = {
--	[GameStateUtils.StateEnums.Intermission] = function()
--		UserInterfaceController.LoadedControllers["Lobby"].PlayButton:Disable()
--		UserInterfaceController.LoadedControllers["Lobby"].PlayButton.Instance.BackgroundTransparency = 0.6
--	end,
--	[GameStateUtils.StateEnums.Game] = function()
--		UserInterfaceController.LoadedControllers["Lobby"].PlayButton:Enable()
--		UserInterfaceController.LoadedControllers["Lobby"].PlayButton.Instance.BackgroundTransparency = 0
--	end,
--}

--Helper functions
local function ObserveState(CurrentState: number)
	GameStateController.CurrentState = CurrentState
	GameStateChanged:Fire(CurrentState)
end

local function ObserveTimer(CurrentTime: number)
	GameStateController.CurrentTime = CurrentTime
	GameStateTimerChanged:Fire(GameStateController.CurrentState, CurrentTime)
end

---Functions
function GameStateController.Start()
	Observers.observeProperty(ReplicatedStorage.Values.State, "Value", ObserveState)
	Observers.observeProperty(ReplicatedStorage.Values.StateTimer, "Value", ObserveTimer)
end

function GameStateController.Init()
	GameStateController.CurrentState = nil :: number
	GameStateController.CurrentTime = nil :: number
end

return GameStateController