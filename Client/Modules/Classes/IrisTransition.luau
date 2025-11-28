local IrisTransition = {}
IrisTransition.__index = IrisTransition

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--Constants
local Assets = ReplicatedStorage.Assets
local TransitionUI = Assets.Interface.IrisTransition

--Enums
IrisTransition.TransitionState = {
	Created = 1,
	PlayingIn = 2,
	InComplete = 3,
	PlayingOut = 4,
	OutComplete = 5,
	Complete = 6
}

--Types
export type Configuration = {
	InSpeed: number?,
	OutSpeed: number?,
	InSize: UDim2?,
	OutSize: UDim2?,
	Color: Color3,
}
export type Transition = typeof(IrisTransition)

--Defaults
local DEFAULT_IN_SPEED = 0.5
local DEFAULT_OUT_SPEED = 0.5
local DEFAULT_IN_SIZE = UDim2.fromScale(0,0)
local DEFAULT_OUT_SIZE = UDim2.fromScale(2.5,2.5)
local DEFAULT_COLOR = Color3.fromRGB(28, 28, 28)

--Functions
function IrisTransition.Destroy(self: Transition)
	self.Instance:Destroy()
	self.InTween:Destroy()
	self.OutTween:Destroy()
end

function IrisTransition.SetColor(self: Transition, Color: Color3)
	self.Instance.Effect.ImageColor3 = Color
	for _, Frame: Frame in self.Instance.Effect:GetChildren() do
		if not Frame:IsA("Frame") then
			return;
		end
		Frame.BackgroundColor3 = Color
	end
	return self
end

function IrisTransition.SetState(self: Transition, State: number)
	self.CurrentState = State
	if State == 1 then
		self.Instance.Effect.Size = self.OutSize or DEFAULT_OUT_SIZE
		self.Instance.Enabled = false
	elseif State == 2 then
		self.Instance.Enabled = true
		self.InTween:Play()
		self.InTween.Completed:Wait()
	elseif State == 3 then
		self.Instance.Effect.Size = self.InSize or DEFAULT_IN_SIZE
		self.Instance.Enabled = true
	elseif State == 4 then
		self.OutTween:Play()
		self.OutTween.Completed:Wait()
	elseif State == 5 then
		self.Instance.Effect.Size = self.OutSize or DEFAULT_OUT_SIZE
		self.Instance.Enabled = true
	elseif State == 6 then
		self.Instance.Enabled = false
	end
	return self
end
function IrisTransition.new(Config: Configuration)
	local self = setmetatable(Config, IrisTransition) :: Transition
	self.State = self.TransitionState.Created
	self.Instance = TransitionUI:Clone()
	self.Instance.Enabled = false
	self.Instance.Parent = Players.LocalPlayer.PlayerGui
	self.InTween = TweenService:Create(self.Instance.Effect, TweenInfo.new(self.InSpeed or DEFAULT_IN_SPEED), {Size = self.InSize or DEFAULT_IN_SIZE})
	self.OutTween = TweenService:Create(self.Instance.Effect, TweenInfo.new(self.OutSpeed or DEFAULT_OUT_SPEED), {Size = self.OutSize or DEFAULT_OUT_SIZE})
	self:SetColor(self.Color or DEFAULT_COLOR)
	return self
end
return IrisTransition