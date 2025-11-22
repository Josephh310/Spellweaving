local LobbyUI = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local Interface = Assets.Interface
local LobbyScreenGui = Interface.LobbyUI

function LobbyUI.Stop()

end

function LobbyUI.Start()

end

function LobbyUI.Init()
	LobbyUI.Interface = LobbyScreenGui:Clone()
	LobbyUI.Interface.Parent = 
end

return LobbyUI