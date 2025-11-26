local ComponentController = {}

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
	print(ComponentController.Components)
	for Tag, ObserverFn in ComponentController.Components do
		warn(Tag)
		Observers.observeTag(Tag, ObserverFn)
	end
end

function ComponentController.Init()
	ComponentController.Components = Loader.LoadDirectory(Components, {})
end


return ComponentController