local LobbyUI = {}

--Dependancies
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataController = require(ReplicatedFirst.Client.PlayerDataController)
local InterfaceUtils = require(ReplicatedStorage.Shared.Utilities.InterfaceUtils)
local Observers = require(ReplicatedStorage.Library.Observers)

--Constants
local GuiDirectory = script.Parent.Parent.ScreenGuis
local ValuesDirectory = script.Parent.Parent.Values
local LobbyScreen = GuiDirectory.LobbyUI
local GemsContainer = LobbyScreen.LeftContainer.Gems
local ShardsContainer = LobbyScreen.LeftContainer.Shards

--Helper functions
local function SetGemDisplay(Value: number)
	GemsContainer.GemsDisplay.Amount.Text = InterfaceUtils.FormatWithCommas(Value)
end

local function SetShardsDisplay(Value: number)
	ShardsContainer.ShardsDisplay.Amount.Text = InterfaceUtils.FormatWithCommas(Value)
end

local function ObserveCurrentScreen(Value: string)
	if Value == "Lobby" then
		LobbyScreen.Enabled = true
	else
		LobbyScreen.Enabled = false
	end
end

--Init functions
function LobbyUI.Start()
	PlayerDataController.ConnectToValueChanged("Gems", SetGemDisplay)
	PlayerDataController.ConnectToValueChanged("Shards", SetShardsDisplay)
end

function LobbyUI.Init()
	Observers.observeProperty(ValuesDirectory.CurrentScreen, "Value", ObserveCurrentScreen)
end

return LobbyUI
