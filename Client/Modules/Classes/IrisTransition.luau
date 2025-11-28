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
return IrisTransition