local GameState = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Signal = require(ReplicatedStorage.Library.Signal)
local Observers = require(ReplicatedStorage.Library.Observers)
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)
local UserInterfaceController = require(ReplicatedFirst.Client.UserInterfaceController)

local StateFunctions = {
	[GameStateUtils.StateEnums.Intermission] = function()
		UserInterfaceController.LoadedControllers["Lobby"].PlayButton:Disable()
		UserInterfaceController.LoadedControllers["Lobby"].PlayButton.Instance.BackgroundTransparency = 0.6
	end,
	[GameStateUtils.StateEnums.Game] = function()
		UserInterfaceController.LoadedControllers["Lobby"].PlayButton:Enable()
		UserInterfaceController.LoadedControllers["Lobby"].PlayButton.Instance.BackgroundTransparency = 0
	end,
}

local function ObserveState(CurrentState: number)
	GameState.CurrentState = CurrentState
	GameState.StateChanged:Fire(CurrentState)
	if StateFunctions[CurrentState] then
		StateFunctions[CurrentState]()
	end
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