local GameState = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)

--Constants
local Values = ReplicatedStorage.Values
local Events = ServerScriptService.Events

--Functions
local function TransitionStates(CurrentState: number)
	local CurrentStateInfo = GameStateUtils.StateInfo[CurrentState]
	local NextState = CurrentStateInfo.NextState
	local NextStateInfo = GameStateUtils.StateInfo[NextState]
	ReplicatedStorage.Values.State.Value = NextState
	ReplicatedStorage.Values.StateTimer.Value = NextStateInfo.Duration
	Events.GameStateChanged:Fire(NextState)
end

function GameState.DecreaseStateTimer(CurrentState: number, CurrentTime: number)
	local NewTime = CurrentTime - 1
	ReplicatedStorage.Values.StateTimer.Value = NewTime
	Events.GameStateTimerChanged:Fire(CurrentState, NewTime)
end

function GameState.Start()
	--Main game loop
	while task.wait(1) do
		local CurrentState = ReplicatedStorage.Values.State.Value
		local CurrentTimer = ReplicatedStorage.Values.StateTimer.Value
		if (CurrentTimer - 1) < 0 then
			GameState.TransitionStates(CurrentState)
		else
			GameState.DecreaseStateTimer(CurrentState, CurrentTimer)
		end
	end
end

function GameState.Init()
	local DefaultState = GameStateUtils.DefaultState
	ReplicatedStorage.Values.State.Value = DefaultState
	ReplicatedStorage.Values.StateTimer.Value = GameStateUtils.StateInfo[DefaultState].Duration
end

return GameState