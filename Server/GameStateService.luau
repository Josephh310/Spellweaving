local GameState = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)
local Signal = require(ReplicatedStorage.Library.Signal)

local StateFunctions = {
	[GameStateUtils.StateEnums.Intermission] = function()
		for _, Player in Players:GetPlayers() do
			Player.Team = Teams.Lobby
			Player.Character:MoveTo(workspace.Spawn.SpawnLocation.Position + Vector3.new(0, 10, 0))
		end
		workspace.Spawn.Portal.LockedDoor.Lock.Decal.Transparency = 0
		workspace.Spawn.Portal.LockedDoor.Background.Transparency = 0.8
		workspace.Spawn.Portal.LockedDoor.Background.CanCollide = true
	end,
	[GameStateUtils.StateEnums.Game] = function()
		workspace.Spawn.Portal.LockedDoor.Lock.Decal.Transparency = 1
		workspace.Spawn.Portal.LockedDoor.Background.Transparency = 1
		workspace.Spawn.Portal.LockedDoor.Background.CanCollide = false
	end,
}

function GameState.TransitionStates(CurrentState: number)
	local CurrentStateInfo = GameStateUtils.StateInfo[CurrentState]
	local NextState = CurrentStateInfo.NextState
	local NextStateInfo = GameStateUtils.StateInfo[NextState]
	workspace:SetAttribute("State", NextState)
	workspace:SetAttribute("StateTimer", NextStateInfo.Duration)
	GameState.StateChanged:Fire(NextState)
	if StateFunctions[NextState] then
		StateFunctions[NextState]()
	end
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
	if StateFunctions[GameStateUtils.DefaultState] then
		StateFunctions[GameStateUtils.DefaultState]()
	end
end

return GameState