--Dependancies
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InterfaceUtils = require(ReplicatedStorage.Shared.Utilities.InterfaceUtils)

--Configuration
local COLOR_MULTIPLIER = 0.6
local ANIMATION_SPEED = 0.1

--Observer function
return function(Element: GuiButton)
	local ColorProperty = InterfaceUtils.GetElementColorProperty(Element)
	local OriginalColor = Element[ColorProperty]
	local ColorOnHover = InterfaceUtils.MultiplyColor3(OriginalColor, COLOR_MULTIPLIER)
	local ColorModifyAnimation = TweenService:Create(Element, TweenInfo.new(ANIMATION_SPEED), {[ColorProperty] = ColorOnHover})
	local ColorRestoreAnimation = TweenService:Create(Element, TweenInfo.new(ANIMATION_SPEED), {[ColorProperty] = OriginalColor})
	local MouseDownConnection = Element.MouseButton1Down:Connect(function() ColorModifyAnimation:Play() end)
	local MouseUpConnection = Element.MouseButton1Up:Connect(function() ColorRestoreAnimation:Play() end)
	return function()
		ColorModifyAnimation:Destroy()
		ColorRestoreAnimation:Destroy()
		MouseDownConnection:Disconnect()
		MouseUpConnection:Disconnect()
	end
end