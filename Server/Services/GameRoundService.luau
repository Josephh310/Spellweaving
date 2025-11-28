local GameRoundService = {}

--Dependancies
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)
local Maps = require(ReplicatedStorage.Shared.Data.Maps)

--Directories
local Events = ServerScriptService.Events
local Remotes = ReplicatedStorage.Remotes

--Constants
local RoundActive = false
local MapPool = {} :: {number}
local LastMap = nil :: number

--Functions

local function JoinRound(Player: Player)
	warn(`{Player} requested to join the round`)
end

local function EndRound()
	warn("Round ended")
end

local function StartRound()
	warn("Round started")
end

local function ObserveGameState(NewState: number)
	if NewState == GameStateUtils.StateEnums.Game then
		StartRound()
	elseif NewState == GameStateUtils.StateEnums.Intermission then
		EndRound()
	end
end

--Init functions
function GameRoundService.Start()
	Events.GameStateChanged.Event:Connect(ObserveGameState)
end

function GameRoundService.Init()
	Remotes.JoinRound.OnServerEvent:Connect(JoinRound)
end

return GameRoundService
