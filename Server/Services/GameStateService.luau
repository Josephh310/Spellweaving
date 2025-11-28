local GameState = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)

--Constants
local Values = ReplicatedStorage.Values
local Events = ServerScriptService.Events

--[[local StateFunctions = {
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
}]]

function GameState.TransitionStates(CurrentState: number)
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