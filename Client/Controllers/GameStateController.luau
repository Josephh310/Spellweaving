local GameStateController = {}

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
	GameStateController.CurrentState = CurrentState
	GameStateController.StateChanged:Fire(CurrentState)
	if StateFunctions[CurrentState] then
		StateFunctions[CurrentState]()
	end
end

local function ObserveTimer(CurrentTime: number)
	GameStateController.CurrentTime = CurrentTime
	GameStateController.StateTick:Fire(GameStateController.CurrentState, CurrentTime)
end

function GameStateController.Start()
	Observers.observeAttribute(workspace, "State", ObserveState)
	Observers.observeAttribute(workspace, "StateTimer", ObserveTimer)
end

function GameStateController.Init()
	GameStateController.CurrentState = ""
	GameStateController.CurrentTime = ""
	GameStateController.StateChanged = Signal.new()
	GameStateController.StateTick = Signal.new()
end

return GameStateController