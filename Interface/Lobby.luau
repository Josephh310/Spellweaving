local LobbyUI = {}

--Dependancies
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataController = require(ReplicatedFirst.Client.PlayerDataController)
local InterfaceUtils = require(ReplicatedStorage.Shared.Utilities.InterfaceUtils)
local Observers = require(ReplicatedStorage.Library.Observers)
local ButtonClass = require(ReplicatedStorage.Shared.Classes.ButtonClass)

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
		LobbyUI.EquipmentButton:Enable()
		LobbyUI.ClassesButton:Enable()
		LobbyUI.PotionsButton:Enable()
		LobbyUI.GemsButton:Enable()
		LobbyUI.ShardsButton:Enable()
		LobbyUI.PlayButton:Enable()
	else
		LobbyScreen.Enabled = false
		LobbyUI.EquipmentButton:Disable()
		LobbyUI.ClassesButton:Disable()
		LobbyUI.PotionsButton:Disable()
		LobbyUI.GemsButton:Disable()
		LobbyUI.ShardsButton:Disable()
		LobbyUI.PlayButton:Disable()
	end
end

local function GetInventoryOpenFunction(PageName: string)
	if PageName == "Equipment" then
		return function()
			warn("Equipment")
		end
	elseif PageName == "Classes" then
		return function()
			warn("Classes")
		end
	elseif PageName == "Potions" then
		return function()
			warn("Potions")
		end
	end
end

local function GetProductBuyFunction(ProductName: string)
	if ProductName == "Shards" then
		return function()
			warn("Buying shards")
		end
	elseif ProductName == "Gems" then
		return function()
			warn("Buying gems")
		end
	end
end

local function SpawnIntoMatch()
	print("Spawning into the match..")
end

--Init functions
function LobbyUI.Start()
	PlayerDataController.ConnectToValueChanged("Gems", SetGemDisplay)
	PlayerDataController.ConnectToValueChanged("Shards", SetShardsDisplay)
	LobbyUI.EquipmentButton:Bind("OnReleased", GetInventoryOpenFunction("Equipment"))
	LobbyUI.ClassesButton:Bind("OnReleased", GetInventoryOpenFunction("Classes"))
	LobbyUI.PotionsButton:Bind("OnReleased", GetInventoryOpenFunction("Potions"))
	LobbyUI.GemsButton:Bind("OnReleased", GetProductBuyFunction("Gems"))
	LobbyUI.ShardsButton:Bind("OnReleased", GetProductBuyFunction("Shards"))
	LobbyUI.PlayButton:Bind("OnReleased", SpawnIntoMatch)
end

function LobbyUI.Init()
	LobbyUI.EquipmentButton = ButtonClass.new { Instance = LobbyScreen.RightContainer.Equipment }
	LobbyUI.ClassesButton = ButtonClass.new { Instance = LobbyScreen.RightContainer.Classes }
	LobbyUI.PotionsButton = ButtonClass.new { Instance = LobbyScreen.RightContainer.Potions }
	LobbyUI.GemsButton = ButtonClass.new { Instance = LobbyScreen.LeftContainer.Gems }
	LobbyUI.ShardsButton = ButtonClass.new { Instance = LobbyScreen.LeftContainer.Shards }
	LobbyUI.PlayButton = ButtonClass.new { Instance = LobbyScreen.Play }
	LobbyUI.StopObserving = Observers.observeProperty(ValuesDirectory.CurrentScreen, "Value", ObserveCurrentScreen)
end

return LobbyUI
