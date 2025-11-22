local GameState = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Library.Signal)
local Observers = require(ReplicatedStorage.Library.Observers)

local function ObserveState(CurrentState: number)
	GameState.CurrentState = CurrentState
	GameState.StateChanged:Fire(CurrentState)
end

local function ObserveTimer(CurrentTime: number)
	GameState.CurrentTime = CurrentTime
	GameState.StateTick:Fire(GameState.CurrentState, CurrentTime)
end

function GameState.Start()
	Observers.observeAttribute(workspace, "State", ObserveState)
	Observers.observeAttribute(workspace, "StateTimer", ObserveTimer)
end

function GameState.Init()
	GameState.CurrentState = ""
	GameState.CurrentTime = ""
	GameState.StateChanged = Signal.new()
	GameState.StateTick = Signal.new()
end

return GameState