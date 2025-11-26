local UserInterfaceController = {}

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui

function UserInterfaceController.Start()
	for Index, LoadedController in UserInterfaceController.LoadedControllers do
		if LoadedController.Start then
			LoadedController.Start()
		end
	end
end

function UserInterfaceController.Init()
	UserInterfaceController.InterfaceDirectory = PlayerGui:WaitForChild("Interface")
	UserInterfaceController.ControllerDirectory = UserInterfaceController.InterfaceDirectory:WaitForChild("Controllers")
	UserInterfaceController.ScreenGuiDirectory = UserInterfaceController.InterfaceDirectory:WaitForChild("ScreenGuis")
	UserInterfaceController.LoadedControllers = {}
	for Index, Controller: ModuleScript in UserInterfaceController.ControllerDirectory:GetChildren() do
		if not Controller:IsA("ModuleScript") then
			return;
		end
		UserInterfaceController.LoadedControllers[Controller.Name] = require(Controller)
	end
	for Index, LoadedController in UserInterfaceController.LoadedControllers do
		if LoadedController.Init then
			LoadedController.Init()
		end
	end
end

return UserInterfaceController