local function assassinscript()
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local ts = game:GetService("TeleportService")

    function getallplayers()
        local playerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            table.insert(playerList, player.Name)
        end
        return playerList
    end

    local playersInLobby = getallplayers()

    local Camera = game:GetService("Workspace").CurrentCamera
    local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
    local lp = Players.LocalPlayer

    local StabCooldown = false
    local chooseTarget = false
    local AutofarmEnabled = false
    local GhostCoins = false
    local TPSilentAim = false
    local AntiAFK = false
    local AutoEquip = false

    local infiniteJump = false
    local speedChange = false
    local speedValue = 16
    local jumpChange = false
    local jumpValue = 50

    local FOV_Circle = Drawing.new("Circle")
    FOV_Circle.Color = Color3.fromRGB(255,255,255)
    FOV_Circle.Thickness = 3
    FOV_Circle.NumSides = 50
    FOV_Circle.Radius = 150
    FOV_Circle.Filled = false
    FOV_Circle.Visible = false

    local XOffset = 0
    local YOffset = 0
    local ZOffset = 0

    game:GetService("RunService").Heartbeat:connect(function()
        if jumpChange == true then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = jumpValue
        else
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end)

    game:GetService("RunService").Heartbeat:connect(function()
        if speedChange == true then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)

    game:GetService("UserInputService").JumpRequest:Connect(function()
        if infiniteJump == true then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)

    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua"))() -- Could Also Save It In Your Workspace And Do loadfile("Library.lua")()
    local Window = Library:New({Name = "Moon | Assassin ", Accent = Color3.fromRGB(255,255,255)})

    local Main = Window:Page({Name = "Main"})
    local Settings = Window:Page({Name = "Misc"})

    local Silent_Aim = Main:Section({Name = "Main", Side = "Left"})
    local Server_Section = Main:Section({Name = "Server", Side = "Left"})
    local Other_Section = Main:Section({Name = "Other", Side = "Left"})
    local Auto_Farm = Main:Section({Name = "Farming Tools", Side = "Right"})
    local Client_Section = Main:Section({Name = "Client", Side = "Right"})

    local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})
    local SilentAimToggle = Silent_Aim:Toggle({Name = "TP Silent Aim", Default = false, Callback = function(value) TPSilentAim = value end, Pointer = "SilentAim_Enabled"})
    local FovCircleToggle = Silent_Aim:Toggle({Name = "FOV Circle", Default = false, Callback = function(value) FOV_Circle.Visible = value end, Pointer = "FovCircle_Enabled"})
    local RadiusSlider = Silent_Aim:Slider({Name = "FOV Circle Radius", Minimum = 1, Maximum = 400, Default = 200, Decimals = 1, Callback = function(value) FOV_Circle.Radius = value end, Pointer = "SilentAim_Radius"})
    local ThicknessSlider = Silent_Aim:Slider({Name = "FOV Circle Thickness", Minimum = 1, Maximum = 10, Default = 3, Decimals = 1,Callback = function(value) FOV_Circle.Thickness = value end, Pointer = "SilentAim_Thickness"})
    local NumSidesSlider = Silent_Aim:Slider({Name = "FOV Circle NumSides", Minimum = 5, Maximum = 50, Default = 50, Decimals = 1, Callback = function(value) FOV_Circle.NumSides = value end, Pointer = "SilentAim_NumSides"})

    local ServerHopButton = Server_Section:Button({Name = "Server Hop", Callback = function() ts:Teleport(game.PlaceId, lp) end})
    local JoinClassicButton = Server_Section:Button({Name = "Join Classic", Callback = function() ts:Teleport(379614936, lp) end})
    local JoinFreeplayButton = Server_Section:Button({Name = "Join Freeplay", Callback = function() ts:Teleport(5006801542, lp) end})
    local JoinProButton = Server_Section:Button({Name = "Join Pro", Callback = function() ts:Teleport(860428890, lp) end})

    local Discord = Other_Section:Button({Name = "Copy Discord Link", Callback = function() setclipboard("https://discord.gg/TdaMJXXf") end})
    local AfkToggle = Other_Section:Toggle({Name = "Anti AFK", Default = false, Callback = function(value) AntiAFK = value end, Pointer = "AntiAFK_Enabled"})

    local autoEquipToggle = Auto_Farm:Toggle({Name = "Auto Equip Knife", Default = false, Callback = function(value) 
    AutoEquip = value 
    while AutoEquip == true do
        if game.Players.LocalPlayer.Backpack:FindFirstChild("Knife") and AutoEquip == true then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(Game.Players.LocalPlayer.Backpack.Knife)
        end
        wait(0)
    end
    end, Pointer = "AutoEquip_Knife"})
    local GhostCoinsToggle = Auto_Farm:Toggle({Name = "Auto Ghost Coins", Default = false, Callback = function(value) GhostCoins = value end, Pointer = "GhostCoins_Enabled"})
    local AutoFarmToggle = Auto_Farm:Toggle({Name = "TP Auto Farm", Default = false, Callback = function(value) AutofarmEnabled = value end, Pointer = "TP_AutoFarm"})
    local Xslider = Auto_Farm:Slider({Name = "X Offset", Minimum = -6, Maximum = 6, Default = 0, Decimals = 0.5, Callback = function(value) XOffset = value end, Pointer = "X_Farming"})
    local Yslider = Auto_Farm:Slider({Name = "Y Offset", Minimum = -6, Maximum = 6, Default = 0, Decimals = 0.5, Callback = function(value) YOffset = value end, Pointer = "Y_Farming"})
    local Zslider = Auto_Farm:Slider({Name = "Z Offset", Minimum = -6, Maximum = 6, Default = 0, Decimals = 0.5, Callback = function(value) ZOffset = value end, Pointer = "Z_Farming"})
    --local autofarmDropdown = Auto_Farm:Dropdown({Name = "Players", Options = playersInLobby, Default = lp.Name, Pointer = "Target_Players"})
    --local chooseTargetToggle = Auto_Farm:Toggle({Name = "Choose Farming Target", Default = false, Callback = function(value) chooseTarget = value end, Pointer = "Choose_Target"})

    local infiniteJumpToggle = Client_Section:Toggle({Name = "Infinite Jump", Default = false, Callback = function(value) infiniteJump = value end, Pointer = "InfiniteJump_Toggle"})
    local ModifyWalkspeedToggle = Client_Section:Toggle({Name = "Modify WalkSpeed", Default = false, Callback = function(value) speedChange = value end, Pointer = "Modify_SpeedToggle"})
    local WalkspeedSlider = Client_Section:Slider({Name = "WalkSpeed", Minimum = 5, Maximum = 300, Default = 16, Decimals = 1, Callback = function(value) speedValue = value end, Pointer = "Modify_SpeedSlider"})
    local ModifyJumpToggle = Client_Section:Toggle({Name = "Modify JumpPower", Default = false, Callback = function(value) jumpChange = value end, Pointer = "Modify_JumpToggle"})
    local JumpSlider = Client_Section:Slider({Name = "JumpPower", Minimum = 10, Maximum = 350, Default = 50, Decimals = 1, Callback = function(value) jumpValue = value end, Pointer = "Modify_JumpSlider"})

    --Aimbot_Extra:Colorpicker({Name = "Locking-Color", Info = "Aimbot Locked Color", Alpha = 0.5, Default = Color3.fromRGB(255, 0, 0), Pointer = "AimbotExtra_Color"})

    local configBox = Settings_Main:ConfigBox({})
    local loadConfig = Settings_Main:ButtonHolder({Buttons = {{"Load", function() end}, {"Save", function() end}}})
    local unloadLabel = Settings_Main:Label({Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.", Middle = true})
    local unloadButton = Settings_Main:Button({Name = "Unload", Callback = function() Window:Unload() end})

    local AutofarmLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if AutofarmEnabled then
            if game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("UI").Target.Visible and game.Workspace[game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.UI.Target.TargetText.Text] then -- if target frame visible and target exists
                wait(8)
                local AutofarmTween = game:GetService('TweenService'):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0,Enum.EasingStyle.Linear), {CFrame = game.Workspace[game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.UI.Target.TargetText.Text].HumanoidRootPart.CFrame * CFrame.new(XOffset ,YOffset, ZOffset)})
                AutofarmTween:Play()
            end   

            if StabCooldown == false and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("UI").Target.Visible and game.Workspace[game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.UI.Target.TargetText.Text] then
                local TargetMagnitude = (game.Workspace[game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.UI.Target.TargetText.Text].HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if TargetMagnitude <= 20 then
                    StabCooldown = true
                    game:GetService("Players").LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(game.Workspace[game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.UI.Target.TargetText.Text])
                    wait(0.73)
                    StabCooldown = false
                end
            end
        end
    end)

    local fovCirclePos = game:GetService("RunService").Stepped:connect(function()
        FOV_Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 37)
    end)

    local function ClosestPlayerToMouse()
        local Closest = nil
        local Distance = 9e9
        for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
            if Player ~= game:GetService("Players").LocalPlayer then
                local Character = workspace:FindFirstChild(Player.Name)
                if Character then
                    local Head = Character:FindFirstChild("HumanoidRootPart")
                    if Head then
                        local ScreenPos, OnScreen = Camera:WorldToScreenPoint(Head.Position)
                        if OnScreen then
                            local Magnitude = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                            if Magnitude < Distance and Magnitude < FOV_Circle.Radius then
                                Closest = Character
                                Distance = Magnitude
                            end
                        end
                    end
                end
            end
        end
        return Closest
    end

    game:GetService("RunService").Heartbeat:connect(function()
        if TPSilentAim then
            local ClosestToMouse = ClosestPlayerToMouse()
            if ClosestToMouse then
            wait(0.09)
            for i,v in pairs(game:GetService("Workspace").KnifeHost:GetDescendants()) do
                if v:IsA("Part") and TPSilentAim == true then
                    v.CFrame = ClosestToMouse.Head.CFrame
                end
            end
        else 
            return end
        end
    end)

    local AutofarmLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if AutofarmEnabled == true then
            if game:GetService("Workspace").Gravity ~= 20 then
                game:GetService("Workspace").Gravity = 20
            end
        elseif AutofarmEnabled == false then
            game:GetService("Workspace").Gravity = 196.2
        end
    end)


    local AutofarmLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if AutofarmEnabled == true then
            for i,v in pairs(game.Workspace.GameMap.IGNORE:GetDescendants()) do
                if v:IsA("Part") then
                    v:Destroy()
                end
            end 
        end
    end)

    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
        if GhostCoins == true then
            game:GetService("ReplicatedStorage").Remotes.RequestGhostSpawn:InvokeServer()
            task.spawn(function()
                game:GetService("RunService").Heartbeat:connect(function()
                    for i,v in pairs(game:GetService("Workspace").GhostCoins:GetDescendants()) do
                        if v:IsA("TouchTransmitter") then
                            firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, v.Parent, 0) 
                            task.wait()
                            firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                        end
                    end
                end)
            end)
        end
    end)

    local AFKCooldown = false

    local XenowareAutofarm = game:GetService("RunService").Heartbeat:Connect(function()
	    if AntiAFK == true then
		    if AFKCooldown == false then
			    AFKCooldown = true
                game:GetService("VirtualUser"):SetKeyDown("w")
                task.wait(2)
                game:GetService("VirtualUser"):SetKeyUp("w")
                task.wait(2)
                game:GetService("VirtualUser"):SetKeyDown("a")
                task.wait(2)
                game:GetService("VirtualUser"):SetKeyUp("a")
                task.wait(2)
                game:GetService("VirtualUser"):SetKeyDown("s")
                task.wait(2)
                game:GetService("VirtualUser"):SetKeyUp("s")
                task.wait(2)
                game:GetService("VirtualUser"):SetKeyDown("d")
                task.wait(2)
                game:GetService("VirtualUser"):SetKeyUp("d")
                wait(10)
                AFKCooldown = false
            end
        end
    end)

    Window:Initialize()
end

assassinscript()
