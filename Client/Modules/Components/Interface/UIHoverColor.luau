--Dependancies
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InterfaceUtils = require(ReplicatedStorage.Shared.Utilities.InterfaceUtils)

--Configuration
local COLOR_MULTIPLIER = 0.8
local ANIMATION_SPEED = 0.1

--Observer function
return function(Element: GuiObject)
	local ColorProperty = InterfaceUtils.GetElementColorProperty(Element)
	local OriginalColor = Element[ColorProperty]
	local ColorOnHover = InterfaceUtils.MultiplyColor3(OriginalColor, COLOR_MULTIPLIER)
	local ColorModifyAnimation = TweenService:Create(Element, TweenInfo.new(ANIMATION_SPEED), {[ColorProperty] = ColorOnHover})
	local ColorRestoreAnimation = TweenService:Create(Element, TweenInfo.new(ANIMATION_SPEED), {[ColorProperty] = OriginalColor})
	local HoverConnection = Element.MouseEnter:Connect(function() ColorModifyAnimation:Play() end)
	local LeaveConnection = Element.MouseLeave:Connect(function() ColorRestoreAnimation:Play() end)
	return function()
		ColorModifyAnimation:Destroy()
		ColorRestoreAnimation:Destroy()
		HoverConnection:Disconnect()
		LeaveConnection:Disconnect()
	end
end