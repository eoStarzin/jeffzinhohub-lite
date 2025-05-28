-- Jeffzinho Hub Lite - Feito por IsStar
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")

-- UI simples
loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Library = Library or {}
local Window = Library.CreateLib("Jeffzinho Hub Lite", "DarkTheme")

-- Farm Tab
local FarmTab = Window:NewTab("Farm")
local FarmSection = FarmTab:NewSection("Auto Farm")

FarmSection:NewToggle("Auto Farm", "", function(state)
    _G.AutoFarm = state
    while _G.AutoFarm do
        pcall(function()
            local enemies = workspace.Enemies:GetChildren()
            for _, enemy in pairs(enemies) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and hrp then
                        char.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
                        VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                        task.wait(0.2)
                        VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- FPS Tab
local FPSTab = Window:NewTab("FPS")
local FPSSection = FPSTab:NewSection("Boost FPS")

FPSSection:NewButton("Ativar FPS Boost", "", function()
    -- Tirar neblina
    game:GetService("Lighting").FogEnd = 1e10
    game:GetService("Lighting").FogStart = 1e10
    sethiddenproperty(game:GetService("Lighting"), "Technology", Enum.Technology.Compatibility)

    -- Reduzir gráficos
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end

    -- Otimizar ilhas (não renderizar longe)
    local function optimizeDistance()
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart

        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part:IsDescendantOf(workspace) and not part:IsDescendantOf(char) then
                local dist = (part.Position - root.Position).Magnitude
                if dist > 1200 then
                    part.Transparency = 1
                    if part:FindFirstChild("Decal") then part.Decal:Destroy() end
                else
                    part.Transparency = 0
                end
            end
        end
    end

    RunService.RenderStepped:Connect(optimizeDistance)
end)
