local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Core = Shared:WaitForChild("Core")
local Loader = require(Core.Loader)

local function InitializeClient()
	local Services = Loader.LoadDirectory(script, {})
	Loader.BatchCall(Services, "Init", false)
	Loader.BatchCall(Services, "Start", true)
end

if RunService:IsStudio() then
	InitializeClient()
else
	local Success, Error = pcall(InitializeClient)
	if not Success then
		warn(("[Client] Startup error:\n%s"):format(debug.traceback(Error)))
	end
end

print("[Client]: Successfully loaded!")