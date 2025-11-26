local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Core = Shared:WaitForChild("Core")
local Loader = require(Core.Loader)

local function InitializeServer()
	local Services = Loader.LoadDirectory(script, {})
	Loader.BatchCall(Services, "Init", false)
	Loader.BatchCall(Services, "Start", true)
end

if RunService:IsStudio() then
	InitializeServer()
else
	local Success, Error = pcall(InitializeServer)
	if not Success then
		warn(("[Server] Startup error:\n%s"):format(debug.traceback(Error)))
	end
end

print("[Server]: Successfully loaded!")

do
	local HDAdmin = ServerStorage:WaitForChild("HD Admin")
	local HDAdminModule = require(3239236979)
	HDAdminModule:Initialize(HDAdmin)
	HDAdmin:Destroy()
end