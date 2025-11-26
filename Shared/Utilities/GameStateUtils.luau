local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local StateEnums = {
	["Intermission"] = 1,
	["Game"] = 2,
}

local GameStates = {
	[1] = "Intermission",
	[2] = "Game"
}

return {
	DefaultState = StateEnums.Intermission,
	StateInfo = {
		[1] = {
			Duration = 30,
			NextState = StateEnums.Game,
		},
		[2] = {
			Duration = 300,
			NextState = StateEnums.Intermission,
		}
	},
	StateEnums = StateEnums,
	GameStates = GameStates,
}