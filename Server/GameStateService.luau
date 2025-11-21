local GameState = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateUtils = require(ReplicatedStorage.Shared.Modules.GameStateUtils)
local Signal = require(ReplicatedStorage.Library.Signal)

function GameState.TransitionStates(CurrentState: number)
	local CurrentStateInfo = GameStateUtils.StateInfo[CurrentState]
	local NextState = CurrentStateInfo.NextState
	local NextStateInfo = GameStateUtils.StateInfo[NextState]
	workspace:SetAttribute("State", NextState)
	workspace:SetAttribute("StateTimer", NextStateInfo.Duration)
	GameState.StateChanged:Fire(NextState)
end

function GameState.DecreaseStateTimer(CurrentState: number, CurrentTime: number)
	local NewTime = CurrentTime - 1
	workspace:SetAttribute("StateTimer", NewTime)
	GameState.StateTick:Fire(CurrentState, NewTime)
end

function GameState.Start()
	while task.wait(1) do
		local CurrentState = workspace:GetAttribute("State")
		local CurrentTimer = workspace:GetAttribute("StateTimer")
		if (CurrentTimer - 1) < 0 then
			GameState.TransitionStates(CurrentState)
		else
			GameState.DecreaseStateTimer(CurrentState, CurrentTimer)
		end
	end
end

function GameState.Init()
	GameState.StateChanged = Signal.new()
	GameState.StateTick = Signal.new()
	local DefaultState = GameStateUtils.DefaultState
	workspace:SetAttribute("State", DefaultState)
	workspace:SetAttribute("StateTimer", GameStateUtils.StateInfo[DefaultState].Duration)
end

return GameState