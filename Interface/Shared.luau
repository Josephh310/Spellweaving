local SharedUI = {}

--Dependancies
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateController = require(ReplicatedFirst.Client.GameStateController)
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)
local Observers = require(ReplicatedStorage.Library.Observers)

--Constants
local GuiDirectory = script.Parent.Parent.ScreenGuis
local ValueDirectory = script.Parent.Parent.Values
local SharedScreen = GuiDirectory.SharedUI
local GameStateDisplay = SharedScreen.GameState

--Helper functions
local function UpdateGameStateDisplay(CurrentState: number, CurrentTime: number)
	local StateName = GameStateUtils.GameStates[CurrentState]
	local FormattedTime = string.format("%02d:%02d", math.floor(CurrentTime / 60), CurrentTime % 60)
	GameStateDisplay.RoundState.Text = StateName
	GameStateDisplay.RoundTimer.Text = FormattedTime
end

local function ObserveSharedEnabled(Value: boolean)
	SharedScreen.Enabled = Value
	return function()
		SharedScreen.Enabled = not Value
	end	
end

function SharedUI.Start()
	GameStateController.StateTick:Connect(UpdateGameStateDisplay)
end

function SharedUI.Init()
	Observers.observeProperty(ValueDirectory.SharedEnabled, "Value", ObserveSharedEnabled)
end

return SharedUI
