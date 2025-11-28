local IrisTransition = {}
IrisTransition.__index = IrisTransition

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--Constants
local Assets = ReplicatedStorage.Assets
local TransitionUI = Assets.Interface.IrisTransition

return IrisTransition