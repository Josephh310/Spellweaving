local Button = {}
Button.__index = Button
Button.__className = "Button"

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundEffects = ReplicatedStorage.Assets.SoundEffects
local InterfaceUtil = require(ReplicatedStorage.Shared.Utilities.InterfaceUtils)

--Types
export type ButtonSettings = {
	Instance: TextButton|ImageButton,
	AnimationEnabled: boolean,
	AnimationSpeed: number,
	AutoButtonColor: boolean,
	SoundEnabled: boolean,
	OnPressed: () -> (),
	OnReleased: () -> (),
}
export type Button = typeof(Button)

--Helper functions
local function GetColorProperty(object)
	if object:IsA("ImageLabel") or object:IsA("ImageButton") then return "ImageColor3" end
	if object:IsA("TextLabel") or object:IsA("TextButton") then return "BackgroundColor3" end
end

--Private functions
function Button._playAnimation(self: Button, tween: Tween)
	if self.AnimationEnabled ~= false and tween ~= nil then
		tween:Play()
	end
end

function Button._playSound(self: Button, Sound: Sound)
	if self.SoundEnabled ~= false then
		Sound:Play()
	end
end

function Button._changeColor(self: Button, changeUnit: number)
	-- Prepare for application
	local ColorProperty = GetColorProperty(self.Instance)
	local NewColor = Color3.new(
		self._originalColor.r * changeUnit, 
		self._originalColor.g * changeUnit, 
		self._originalColor.b * changeUnit
	)
	-- Apply change
	self.Instance[ColorProperty] = NewColor
end

-- Click functions
function Button._onMouseEnter(self: Button)
	-- Animation
	self:_playAnimation(self._mouseEnterTween)
end

function Button._onMouseLeave(self: Button)
	-- Animation
	self:_playAnimation(self._mouseLeaveTween)
end

function Button._onMouseDown(self: Button)
	-- Animation
	self:_playAnimation(self._mouseDownTween)
	self:_changeColor(0.8)
	self:_playSound(SoundEffects.ButtonCompress)
	-- Callback
	if self.OnPressed then 
		self:OnPressed() 
	end
end

function Button._onMouseUp(self: Button)
	-- Animation
	self:_playAnimation(self._mouseUpTween)
	self:_changeColor(1)
	self:_playSound(SoundEffects.ButtonDecompress)
	-- Callback
	if self.OnReleased then 
		self:OnReleased() 
	end
end

--Public functions
function Button.Bind(self: Button, bindType: "OnPressed"|"OnReleased", _function: () -> ())
	if not _function then
		warn(`Error when binding {self.Instance} - no function provided`)
		return;
	end
	if bindType == "OnPressed" then
		self.OnPressed = _function
	elseif bindType == "OnReleased" then
		self.OnReleased = _function
	end
	return self
end

--Lifecycle functions
function Button.Destroy(self: Button)
	self:Disable()
	self._mouseEnterTween:Destroy()
	self._mouseLeaveTween:Destroy()
	self._mouseDownTween:Destroy()
	self._mouseUpTween:Destroy()
	table.clear(self)
end

function Button.Disable(self: Button)
	self._mouseEnterConnection:Disconnect()
	self._mouseLeaveConnection:Disconnect()
	self._mouseDownConnection:Disconnect()
	self._mouseUpConnection:Disconnect()
end

function Button.Enable(self: Button)
	self._mouseEnterConnection = self.Instance.MouseEnter:Connect(function() self:_onMouseEnter() end)
	self._mouseLeaveConnection = self.Instance.MouseLeave:Connect(function() self:_onMouseLeave() end)
	self._mouseDownConnection = self.Instance.MouseButton1Down:Connect(function() self:_onMouseDown() end)
	self._mouseUpConnection = self.Instance.MouseButton1Up:Connect(function() self:_onMouseUp() end)
end

function Button.new(config: ButtonSettings)
	
	if typeof(config.Instance) ~= "Instance" and config.Instance:IsA("GuiButton") then
		error("Config.Instance is not a valid GuiButton.")
	end
	
	local self = setmetatable(config, Button) :: Button
	--Configuration
	self.Instance = config.Instance
	self.AnimationEnabled = config.AnimationEnabled
	self.AnimationSpeed = config.AnimationSpeed or 0.1
	self.AutoButtonColor = config.AutoButtonColor
	self.SoundEnabled = config.SoundEnabled
	self.OnPressed = config.OnPressed
	self.OnReleased = config.OnReleased
	--Constants
	self._originalColor = self.Instance[GetColorProperty(self.Instance)]
	self._originalSize = self.Instance.Size
	--Sizes
	self._mouseEnterSize = InterfaceUtil.MultiplyUdim2(self._originalSize, 1.05)
	self._mouseLeaveSize = self._originalSize
	self._mouseDownSize =  InterfaceUtil.MultiplyUdim2(self._originalSize, 0.95)
	self._mouseUpSize = self._originalSize
	--Tweens
	self._mouseEnterTween = TweenService:Create(self.Instance, TweenInfo.new(self.AnimationSpeed), {Size = self._mouseEnterSize})
	self._mouseLeaveTween = TweenService:Create(self.Instance, TweenInfo.new(self.AnimationSpeed), {Size = self._mouseLeaveSize})
	self._mouseDownTween = TweenService:Create(self.Instance, TweenInfo.new(self.AnimationSpeed), {Size = self._mouseDownSize})
	self._mouseUpTween = TweenService:Create(self.Instance, TweenInfo.new(self.AnimationSpeed), {Size = self._mouseUpSize})
	-- Modifications
	self.Instance.AutoButtonColor = false
	
	return self
end

return Button