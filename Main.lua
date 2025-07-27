-- SHADOW HUB PRO - Versão reduzida funcional
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local FOV = 150
local AimbotEnabled = true

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
circle.Radius = FOV
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 2
circle.Transparency = 0.5
circle.Visible = true
circle.Filled = false

-- Função para checar inimigos
local function IsEnemy(player)
	local myTeam = LocalPlayer.Team
	return player.Team ~= myTeam
end

-- Pega jogador mais perto do centro e visível
local function GetClosest()
	local closest = nil
	local shortest = math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and IsEnemy(player) then
			local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
			if onScreen then
				local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
				if dist < shortest and dist < FOV then
					shortest = dist
					closest = player
				end
			end
		end
	end
	return closest
end

-- Aimbot loop
RunService.RenderStepped:Connect(function()
	if AimbotEnabled then
		local target = GetClosest()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local headPos = Camera:WorldToScreenPoint(target.Character.Head.Position)
			mousemoverel((headPos.X - Camera.ViewportSize.X / 2), (headPos.Y - Camera.ViewportSize.Y / 2))
		end
	end
end)
