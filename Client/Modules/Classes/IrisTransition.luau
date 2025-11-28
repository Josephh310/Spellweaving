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

return IrisTransition