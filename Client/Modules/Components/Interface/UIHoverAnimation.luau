--[[
	@Title: 
		Hover animation component
	@Author: 
		Joseph (@BreakLoop)
	@Description:
		Tag a UI object with HoverAnimation to use.
		All components are initialized through the ComponentController module.
		Uses sleitnick's observer module.
]]

--Dependancies
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InterfaceUtils = require(ReplicatedStorage.Shared.Utilities.InterfaceUtils)

--Helper functions
local function PlayAnimation(Animation: Tween)
	return function()
		if Animation then
			Animation:Play()
		end
	end
end

--Observer function
return function(Element: GuiObject)
	local OriginalSize = Element.Size
	local HoverSize = Element:GetAttribute("HoverSize") or 1.05
	local HoverAnimationSpeed = Element:GetAttribute("HoverAnimationSpeed") or 0.1
	local HoverAnimationTween = TweenService:Create(Element, TweenInfo.new(HoverAnimationSpeed), {Size = InterfaceUtils.MultiplyUdim2(OriginalSize, HoverSize)})
	local RestoreSizeTween = TweenService:Create(Element, TweenInfo.new(HoverAnimationSpeed), {Size = OriginalSize})
	local HoverConnection = Element.MouseEnter:Connect(PlayAnimation(HoverAnimationTween))
	local LeaveConnection = Element.MouseLeave:Connect(PlayAnimation(RestoreSizeTween))
	return function()
		Element.Size = OriginalSize
		HoverAnimationTween:Destroy()
		RestoreSizeTween:Destroy()
		HoverConnection:Disconnect()
		LeaveConnection:Disconnect()
	end
end