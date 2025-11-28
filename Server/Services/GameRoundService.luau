local GameRoundService = {}

--Dependancies
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)
local Maps = require(ReplicatedStorage.Shared.Data.Maps)

--Directories
local Events = ServerScriptService.Events
local Remotes = ReplicatedStorage.Remotes

--Constants
local GameTeam = Teams.Game
local LobbyTeam = Teams.Lobby
local RoundActive = false
local MapPool = {} :: {number}
local LastMap = nil :: number

--Functions
local function SelectMap()
	if #MapPool == 0 then
		for Index, Value in Maps do
			table.insert(MapPool, Index)
		end
		local NewRandom = Random.new()
		NewRandom:Shuffle(MapPool)
	end
	local Selected = MapPool[1] do
		table.remove(MapPool, 1)
	end
	return Selected
end

local function SelectSpawn(MapID: number)
	local SpawnFolder = Maps[MapID].Spawns
	local SelectedSpawn = nil :: BasePart
	local BestDistance = math.huge
	for _, PlayerSpawn in SpawnFolder:GetChildren() do
		local CombinedDistance = 0
		for _, Player in GameTeam:GetPlayers() do
			local Character = Player.Character
			if not Character then
				return;
			end
			local Root = Character.PrimaryPart
			if not Root then
				return;
			end
			CombinedDistance += (Root.Position - PlayerSpawn.Position).Magnitude
		end
		if CombinedDistance < BestDistance then
			SelectedSpawn = PlayerSpawn
			BestDistance = CombinedDistance
		end
	end
end

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
	if NewState == GameStateUtils.StateEnums.Game then StartRound() end
	if NewState == GameStateUtils.StateEnums.Intermission then EndRound() end
end

--Init functions
function GameRoundService.Start()
	Events.GameStateChanged.Event:Connect(ObserveGameState)
end

function GameRoundService.Init()
	Remotes.JoinRound.OnServerEvent:Connect(JoinRound)
end

return GameRoundService
