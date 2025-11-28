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
local LoadedComponents = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Observers = require(ReplicatedStorage.Library.Observers)

--Constants
local Modules = ReplicatedFirst.Modules
local Components = Modules.Components

--Functions
function ComponentController.Start()
	for Tag, ObserverFn in LoadedComponents do
		Observers.observeTag(Tag, ObserverFn)
	end
end

function ComponentController.Init()
	for _, Module: ModuleScript in Components:GetDescendants() do
		if Module:IsA("ModuleScript") then
			LoadedComponents[Module.Name] = require(Module)
		end
	end
end

return ComponentController