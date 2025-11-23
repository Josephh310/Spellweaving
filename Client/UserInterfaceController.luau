local UIController = {}

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui

function UIController.Start()
	for Index, LoadedController in UIController.LoadedControllers do
		if LoadedController.Start then
			LoadedController.Start()
		end
	end
end

function UIController.Init()
	UIController.InterfaceDirectory = PlayerGui:WaitForChild("Interface")
	UIController.ControllerDirectory = UIController.InterfaceDirectory:WaitForChild("Controllers")
	UIController.ScreenGuiDirectory = UIController.InterfaceDirectory:WaitForChild("ScreenGuis")
	UIController.LoadedControllers = {}
	for Index, Controller: ModuleScript in UIController.ControllerDirectory:GetChildren() do
		if not Controller:IsA("ModuleScript") then
			return;
		end
		UIController.LoadedControllers[Controller.Name] = require(Controller)
	end
	for Index, LoadedController in UIController.LoadedControllers do
		if LoadedController.Init then
			LoadedController.Init()
		end
	end
end

return UIController