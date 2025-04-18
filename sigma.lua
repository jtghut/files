local function assassinscript()
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")

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

    local library, esps = loadstring(game:HttpGet("https://raw.githubusercontent.com/Trew1q/Mooning/refs/heads/main/lib.lua"))(), loadstring(game:HttpGet('https://raw.githubusercontent.com/Trew1q/Mooning/main/esp.lua'))()
    local Notif = library:InitNotifications()

     
     for i = 8,0,-1 do 
         task.wait(0.1)
         local loading = Notif:Notify("Loading Gingers_Scripts...", 3, "Please wait")-- notification, alert, error, success, information
     end 
     
     library.title = "Gingers Scripts"
     library:Introduction()
    wait(1)
    local Init = library:Init()

    local Main = Init:NewTab("Main")

    local AntiAFK_Toggle = Main:NewToggle("Anti AFK", false, function(value) AntiAFK = value end)

    local autoEquipToggle = Main:NewToggle("Autp Equip Knife", false, function(value) 
    AutoEquip = value 
    while AutoEquip == true do
        if game.Players.LocalPlayer.Backpack:FindFirstChild("Knife") and AutoEquip == true then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(Game.Players.LocalPlayer.Backpack.Knife)
        end
        wait(0)
    end
end)
    local SilentAimToggle = Main:NewToggle("Silent Aim", false, function(value) TPSilentAim = value end)
    local GhostCoinsToggle = Main:NewToggle("Auto Ghost Coins", false, function(value) GhostCoins = value end)
    local AutoFarmToggle = Main:NewToggle("Autofarm", false, function(value) AutofarmEnabled = value end)
    local Xslider = Main:NewSlider("X Offset", "", true, "/", {min = -6, max = 6, default = 0}, function(value) XOffset = value end)
    local Yslider = Main:NewSlider("Y Offset", "", true, "/", {min = -6, max = 6, default = 0}, function(value) YOffset = value end)
    local Zslider = Main:NewSlider("Z Offset", "", true, "/", {min = -6, max = 6, default = 0}, function(value) ZOffset = value end)

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
end

assassinscript()
