local Players = game:GetService("Players")

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
		[StateEnums.Intermission] = {
			Duration = 30,
			NextState = StateEnums.Game,
		},
		[StateEnums.Game] = {
			Duration = 300,
			NextState = StateEnums.Intermission
		}
	},
	StateEnums = StateEnums,
	GameStates = GameStates,
}