local RoundService = {}

--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local GameStateUtils = require(ReplicatedStorage.Shared.Utilities.GameStateUtils)
local MapData = require(ReplicatedStorage.Shared.Data.Maps)
local Observers = require(ReplicatedStorage.Library.Observers)
local Signal = require(ReplicatedStorage.Library.Signal)

--Constants
local Remotes = ReplicatedStorage.Remotes
local JoinRound = ReplicatedStorage.Remotes.JoinRound

--Helper functions
local function ObserveGameState(Value: number)
	if Value ~= GameStateUtils.StateEnums.Game then
		return;
	end
	RoundService.StartRound()
	
	return function()
		RoundService.EndRound()
	end
end

local function SelectMap(LastMap: number)
	local SelectedMap = nil
	repeat task.wait()
		SelectedMap = math.random(1, #MapData)
	until SelectedMap ~= LastMap
	return SelectedMap
end

--Public functions

function RoundService.JoinRound(Player: Player)
	Player.Team = Teams.Game
	
end

function RoundService.EndRound()
	if not RoundService.RoundActive then
		return;
	end
	print("Ended")
end

function RoundService.StartRound()
	if RoundService.RoundActive then
		return;
	end
	print("Started")
end

function RoundService.Start()
	Observers.observeAttribute(workspace, "State", ObserveGameState)
end

--Initialize
do
	RoundService.RoundActive = false
	RoundService.LastMap = nil
	RoundService.RoundStarted = Signal.new()
	RoundService.RoundEnded = Signal.new()
	JoinRound.OnServerEvent:Connect(RoundService.JoinRound)
end

return RoundService