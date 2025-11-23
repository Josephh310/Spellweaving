local PlayerCombat = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

local Remotes = ReplicatedStorage.Remotes
local JoinRound = ReplicatedStorage.Remotes.JoinRound

function PlayerCombat.JoinRound(Player: Player)
	Player.Team = Teams.Game
	
end

function PlayerCombat.Start()

end

function PlayerCombat.Init()
	JoinRound.OnServerEvent:Connect(PlayerCombat.JoinRound)
end

return PlayerCombat