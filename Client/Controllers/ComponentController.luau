--[[
	@Title:
		Client component controller
	@Author: 
		Joseph (@BreakLoop)
	@Desc: 
		Controller for client components
		Loads component modules at the start of the game,
		then observes their corresponding tags and runs the returned observer function
]]

local ComponentController = {}
ComponentController.Components = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Loader = require(ReplicatedStorage.Shared.Core.Loader)
local Observers = require(ReplicatedStorage.Library.Observers)

--Constants
local Modules = ReplicatedFirst.Modules
local Components = Modules.Components

--Functions
function ComponentController.Start()
	for Tag, ObserverFn in ComponentController.Components do
		Observers.observeTag(Tag, ObserverFn)
	end
end


for _, Module: ModuleScript in Components:GetDescendants() do
	if Module:IsA("ModuleScript") then
		ComponentController.Components[Module.Name] = require(Module)
	end
end

return ComponentController