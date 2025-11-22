local InterfaceController = {}

--Configuration
InterfaceController.Loaded = {} :: {[string]: InterfaceModule}
InterfaceController.DefaultInterface = "Lobby"
InterfaceController.SharedInterface = "Shared"
InterfaceController.CurrentInterface = nil :: string

--Dependancies
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local InterfaceFolder = Shared:WaitForChild("Interface")
local Controllers = InterfaceFolder:WaitForChild("Controllers")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

--Types
export type InterfaceModule = {
	SharedEnabled: boolean?,
	Init: () -> ()?,
	Start: () -> ()?,
	Stop: () -> ()?,
}

function InterfaceController.DisableInterface(InterfaceName: string)
	local InterfaceData = InterfaceController.Loaded[InterfaceName]
	if InterfaceName == nil then
		return;
	end
	if typeof(InterfaceData)~="table" then
		error(`Invalid interface name {InterfaceName} - interface not found.`)
		return
	end
	if InterfaceData.Stop then
		if InterfaceData._enabled ~= true then
			return;
		end
		InterfaceData.Stop()
	end
	InterfaceData._enabled = false
end

function InterfaceController.EnableInterface(InterfaceName: string)
	local InterfaceData = InterfaceController.Loaded[InterfaceName]
	if InterfaceName == nil then
		return;
	end
	if typeof(InterfaceData)~="table" then
		error(`Invalid interface name {InterfaceName} - interface not found.`)
		return
	end
	if InterfaceData.Start then
		if InterfaceData._enabled ~= false then
			return;
		end
		InterfaceData.Start()
	end
	InterfaceData._enabled = true
end

function InterfaceController.SwitchInterface(NewInterfaceName: string)
	--
	if typeof(NewInterfaceName)~="string" then
		return;
	end
	if NewInterfaceName == InterfaceController.CurrentInterface then
		warn(`{NewInterfaceName} is already active!`)
		return;
	end
	--
	InterfaceController.DisableInterface(InterfaceController.CurrentInterface)
	InterfaceController.EnableInterface(NewInterfaceName)
	InterfaceController.CurrentInterface = NewInterfaceName
	--
	if InterfaceController.Loaded[NewInterfaceName].SharedEnabled == false then
		InterfaceController.DisableInterface(InterfaceController.SharedInterface)
	else
		InterfaceController.EnableInterface(InterfaceController.SharedInterface)
	end
end

function InterfaceController.Init()
	for Index, InterfaceModule: ModuleScript in Controllers:GetChildren() do
		if not InterfaceModule:IsA("ModuleScript") then
			return;
		end
		InterfaceController.Loaded[InterfaceModule.Name] = require(InterfaceModule)
	end
	for InterfaceName, Data in InterfaceController.Loaded do
		if Data.Init then
			Data.Init()
		end
	end
end

return InterfaceController