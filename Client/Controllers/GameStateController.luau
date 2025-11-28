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
local StoredState = nil :: number
local StoredTime = nil :: number

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Observers = require(ReplicatedStorage.Library.Observers)

--Constants
local Events = ReplicatedFirst.Events

--Helper functions
local function ObserveState(CurrentState: number)
	StoredState = CurrentState
	Events.GameStateChanged:Fire(CurrentState)
end

local function ObserveTimer(CurrentTime: number)
	StoredTime = CurrentTime
	Events.GameStateTimerChanged:Fire(StoredState, CurrentTime)
end

---Functions
function GameStateController.Start()
	Observers.observeProperty(ReplicatedStorage.Values.State, "Value", ObserveState)
	Observers.observeProperty(ReplicatedStorage.Values.StateTimer, "Value", ObserveTimer)
end

return GameStateController