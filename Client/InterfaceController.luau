local InterfaceController = {}

--Configuration
InterfaceController.Loaded = {} :: {[string]: InterfaceModule}
InterfaceController.DefaultInterface = "Lobby"
InterfaceController.SharedInterface = "Shared"
InterfaceController.CurrentInterface = nil :: string

--Dependancies
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

--Types
export type InterfaceModule = {
	Interface: ScreenGui,
	Init: () -> (),
	Start: () -> (),
	Stop: () -> (),
}

function InterfaceController.Start()
	
end

function InterfaceController.Init()
	
end

return InterfaceController