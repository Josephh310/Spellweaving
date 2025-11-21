local GameState = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateUtils = require(ReplicatedStorage.Shared.Modules.GameStateUtils)
local Signal = require(ReplicatedStorage.Library.Signal)

function GameState.TransitionStates(CurrentState: number)
	local CurrentStateInfo = GameStateUtils.StateInfo[CurrentState]
	local NextState = CurrentStateInfo.NextState
	local NextStateInfo = GameStateUtils.StateInfo[NextState]
	game:SetAttribute("State", NextState)
	game:SetAttribute("StateTimer", NextStateInfo.Duration)
	GameState.StateChanged:Fire(NextState)
end

function GameState.DecreaseStateTimer(CurrentState: number, CurrentTime: number)
	local NewTime = CurrentTime - 1
	game:SetAttribute("StateTimer", NewTime)
	GameState.StateTick:Fire(CurrentState, NewTime)
end

function GameState.Start()
	while task.wait(1) do
		local CurrentState = game:GetAttribute("State")
		local CurrentTimer = game:GetAttribute("StateTimer")
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
	game:SetAttribute("State", DefaultState)
	game:SetAttribute("StateTimer", GameStateUtils.StateInfo[DefaultState].Duration)
end

return GameState