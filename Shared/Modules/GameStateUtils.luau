local Players = game:GetService("Players")

local StateEnums = {
	["Intermission"] = 1,
	["Game"] = 2,
}

return {
	DefaultState = StateEnums.Intermission,
	StateInfo = {
		[StateEnums.Intermission] = {
			Duration = 15,
			NextState = StateEnums.Game,
		},
		[StateEnums.Game] = {
			Duration = 300,
			NextState = StateEnums.Intermission
		}
	},
	StateEnums = StateEnums,
}