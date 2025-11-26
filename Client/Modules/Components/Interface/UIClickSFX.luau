--Dependancies
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Constants
local Assets = ReplicatedStorage.Assets
local SoundEffects = Assets.SoundEffects

--Configuration
local MOUSEDOWN_SFX_NAME = "ButtonCompress"
local MOUSEUP_SFX_NAME = "ButtonDecompress"

--Observer function
return function(Element: GuiButton)
	local MouseDownSound = SoundEffects[MOUSEDOWN_SFX_NAME] :: Sound
	local MouseUpSound = SoundEffects[MOUSEUP_SFX_NAME] :: Sound
	local MouseDownConnection = Element.MouseButton1Down:Connect(function()
		if MouseUpSound.Playing == true then
			MouseUpSound:Stop()
		end
		MouseDownSound:Play()
	end)
	local MouseUpConnection = Element.MouseButton1Up:Connect(function()
		if MouseDownSound.Playing == true then
			MouseDownSound:Stop()
		end
		MouseUpSound:Play()
	end)
	return function()
		MouseDownConnection:Disconnect()
		MouseUpConnection:Disconnect()
	end
end