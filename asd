-- FULL BRAINROT VISUAL DUPE - OWN BASE DUPER (Fixed)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Animals = require(ReplicatedStorage.Datas.Animals)
local Rarities = require(ReplicatedStorage.Datas.Rarities)

local traitMap = {
    ["rbxassetid://89041930759464"] = {name = "Taco", mult = 2},
    ["rbxassetid://104229924295526"] = {name = "Nyan", mult = 5},
    ["rbxassetid://99181785766598"] = {name = "Galactic", mult = 3},
    ["rbxassetid://121100427764858"] = {name = "Fireworks", mult = 5},
    ["rbxassetid://110723387483939"] = {name = "Zombie", mult = 4},
    ["rbxassetid://104964195846833"] = {name = "Claws", mult = 4},
    ["rbxassetid://121332433272976"] = {name = "Glitched", mult = 4},
    ["rbxassetid://100601425541874"] = {name = "Bubblegum", mult = 3},
    ["rbxassetid://118283346037788"] = {name = "Fire", mult = 5},
    ["rbxassetid://78474194088770"] = {name = "Wet", mult = 1.5},
    ["rbxassetid://83627475909869"] = {name = "Snowy", mult = 2},
    ["rbxassetid://127455440418221"] = {name = "Cometstruck", mult = 2.5},
    ["rbxassetid://97725744252608"] = {name = "Explosive", mult = 3},
    ["rbxassetid://82620342632406"] = {name = "Disco", mult = 4},
    ["rbxassetid://134655415681926"] = {name = "10B", mult = 3},
    ["rbxassetid://104985313532149"] = {name = "Shark Fin", mult = 3},
    ["rbxassetid://115664804212096"] = {name = "Matteo Hat", mult = 3.5},
    ["rbxassetid://75650816341229"] = {name = "Brazil", mult = 5},
    ["rbxassetid://115001117876534"] = {name = "Sleepy", mult = 0},
    ["rbxassetid://139729696247144"] = {name = "Lightning", mult = 5},
    ["rbxassetid://110910518481052"] = {name = "UFO", mult = 2},
    ["rbxassetid://117478971325696"] = {name = "Spider", mult = 3.5},
    ["rbxassetid://84731118566493"] = {name = "Strawberry", mult = 7},
    ["rbxassetid://119591742504251"] = {name = "Paint", mult = 5},
    ["rbxassetid://89591838221335"] = {name = "Skeleton", mult = 3},
    ["rbxassetid://95128039793845"] = {name = "Sombrero", mult = 4},
    ["rbxassetid://103610037004911"] = {name = "Tie", mult = 3.75},
    ["rbxassetid://123964048606874"] = {name = "Witch Hat", mult = 3},
    ["rbxassetid://93350414974589"] = {name = "Indonesia", mult = 4},
    ["rbxassetid://114748221761549"] = {name = "Meowl", mult = 6},
    ["rbxassetid://123115843719383"] = {name = "RIP Gravestone", mult = 3.5},
    ["rbxassetid://97054765273857"] = {name = "Jackolantern Pet", mult = 4.5},
    ["rbxassetid://88375043733582"] = {name = "Santa Hat", mult = 4}
}

local mutationMap = {
    ["Gold"] = {mult = 0.25, displayText = "Gold", color = Color3.fromRGB(255, 222, 89), icon = "rbxassetid://136133057822407"},
    ["Diamond"] = {mult = 0.5, displayText = "Diamond", color = Color3.fromRGB(37, 196, 254), icon = "rbxassetid://100875709547015"},
    ["Bloodrot"] = {mult = 1, displayText = "Bloodrot", color = Color3.fromRGB(145, 0, 27), icon = "rbxassetid://75212036784031"},
    ["Rainbow"] = {mult = 9, displayText = "Rainbow", color = Color3.fromRGB(255, 0, 251), icon = "rbxassetid://83078714090192"},
    ["Candy"] = {mult = 3, displayText = "Candy", color = Color3.fromRGB(255, 70, 246), icon = "rbxassetid://84797673698685"},
    ["Lava"] = {mult = 5, displayText = "Lava", color = Color3.fromRGB(255, 149, 0), icon = "rbxassetid://70800471498231"},
    ["Galaxy"] = {mult = 6, displayText = "Galaxy", color = Color3.fromRGB(170, 60, 255), icon = "rbxassetid://139331671405138"},
    ["Yin Yang"] = {mult = 6.5, displayText = "Yin Yang", color = Color3.fromRGB(255, 255, 255), icon = "rbxassetid://112996178302302"},
    ["YinYang"] = {mult = 6.5, displayText = "Yin Yang", color = Color3.fromRGB(255, 255, 255), icon = "rbxassetid://112996178302302"},
    ["Radioactive"] = {mult = 7.5, displayText = "Radioactive", color = Color3.fromRGB(104, 245, 0), icon = "rbxassetid://134809510446754"}
}

local LocalPlayer = Players.LocalPlayer

-- ==================== HELPERS ====================
local function parseGenerationValue(str)
    str = str:gsub("<[^>]+>", ""):gsub("%$", ""):gsub("/s", ""):gsub("%s", "")
    local num, suffix = str:match("(%d*%.?%d+)(%a*)")
    if not num then return 0 end
    num = tonumber(num)
    suffix = suffix:upper()
    local mult = ({K=1e3, M=1e6, B=1e9, T=1e12, Q=1e15})[suffix] or 1
    return num * mult
end

-- ==================== FIND OUR PLOT (GUID structure) ====================
local function findOurPlot()
    local myName = LocalPlayer.Name:lower()
    local myDisplay = LocalPlayer.DisplayName:lower()

    for _, guidFolder in ipairs(Workspace.Plots:GetChildren()) do
        local sign = guidFolder:FindFirstChild("PlotSign")
        if sign then
            for _, v in ipairs(sign:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextBox") then
                    local txt = v.Text:lower():gsub("^%s*(.-)%s*$", "%1")
                    if txt:find(myName, 1, true) or txt:find(myDisplay, 1, true) then
                        return guidFolder
                    end
                end
            end
        end
    end
    return nil
end

-- ==================== GET BRAINROTS (from Debris FastOverheadTemplate) ====================
local function getBrainrots()
    local list = {}
    local ourPlot = findOurPlot()
    if not ourPlot then return list end

    -- Get our plot bounds
    local minX, maxX = math.huge, -math.huge
    local minZ, maxZ = math.huge, -math.huge
    for _, part in ipairs(ourPlot:GetDescendants()) do
        if part:IsA("BasePart") then
            local cf, sz = part.CFrame, part.Size
            minX = math.min(minX, cf.X - sz.X/2)
            maxX = math.max(maxX, cf.X + sz.X/2)
            minZ = math.min(minZ, cf.Z - sz.Z/2)
            maxZ = math.max(maxZ, cf.Z + sz.Z/2)
        end
    end

    local debris = Workspace:FindFirstChild("Debris")
    if not debris then return list end

    local seen = {}
    for _, temp in ipairs(debris:GetChildren()) do
        if temp.Name == "FastOverheadTemplate" then
            local pos = temp.Position
            if pos.X >= minX and pos.X <= maxX and pos.Z >= minZ and pos.Z <= maxZ then
                local oh = temp:FindFirstChild("AnimalOverhead")
                if oh then
                    local nameLbl = oh:FindFirstChild("DisplayName")
                    local genLbl = oh:FindFirstChild("Generation")
                    if nameLbl and genLbl then
                        local key = math.floor(pos.X/5)*5 .. "_" .. math.floor(pos.Z/5)*5
                        if not seen[key] then
                            seen[key] = true

                            -- Find internal animal name from display name
                            local displayName = nameLbl.Text
                            local internalName = nil
                            for name, data in pairs(Animals) do
                                if data.DisplayName == displayName or name == displayName then
                                    internalName = name
                                    break
                                end
                            end

                            table.insert(list, {
                                name = displayName,
                                internalName = internalName,
                                genText = genLbl.Text,
                                genValue = parseGenerationValue(genLbl.Text),
                                overhead = oh,
                                template = temp,
                                position = pos,
                                plot = ourPlot,
                                key = key
                            })
                        end
                    end
                end
            end
        end
    end

    table.sort(list, function(a,b) return a.genValue > b.genValue end)
    return list
end

local function getTraitsFromOverhead(overhead)
    local traits = {}
    local traitFrame = overhead:FindFirstChild("Traits")
    if traitFrame then
        for _, img in ipairs(traitFrame:GetChildren()) do
            if img:IsA("ImageLabel") and traitMap[img.Image] then
                table.insert(traits, traitMap[img.Image].name)
            end
        end
    end
    return traits
end

local function getMutationFromOverhead(overhead)
    local mutFrame = overhead:FindFirstChild("Mutation")
    if mutFrame then
        for mutName, mutData in pairs(mutationMap) do
            local mutIcon = mutFrame:FindFirstChild("Icon")
            if mutIcon and mutIcon:IsA("ImageLabel") and mutIcon.Image == mutData.icon then
                return mutName
            end
        end
    end
    return "None"
end

-- ==================== SPAWN WITH ANIMATION ====================
local function spawnAnimal(internalName, selectedTraits, selectedMutation, sourcePosition, ourPlot)
    -- Resolve internal name if nil
    if not internalName then
        return false, "could not resolve animal name"
    end

    local animalModel = ReplicatedStorage.Models.Animals:FindFirstChild(internalName)
    if not animalModel then
        return false, "model not in ReplicatedStorage: " .. tostring(internalName)
    end

    -- Find empty podium slot on our plot
    local podiums = ourPlot:FindFirstChild("AnimalPodiums")
    if not podiums then return false, "no AnimalPodiums" end

    local podiumList = {}
    for _, child in ipairs(podiums:GetChildren()) do
        if tonumber(child.Name) then
            table.insert(podiumList, child)
        end
    end
    table.sort(podiumList, function(a, b) return tonumber(a.Name) < tonumber(b.Name) end)

    local spawnCFrame, spawnAttachment
    for _, podium in ipairs(podiumList) do
        local base = podium:FindFirstChild("Base")
        if base then
            local spawn = base:FindFirstChild("Spawn")
            if spawn then
                local hasAnimal = false
                for _, obj in ipairs(spawn:GetChildren()) do
                    if obj:IsA("Model") and obj.Name ~= "Attachment" then
                        hasAnimal = true
                        break
                    end
                end
                if not hasAnimal then
                    spawnCFrame = spawn.CFrame * CFrame.new(0, -1.5, 0)
                    spawnAttachment = spawn
                    break
                end
            end
        end
    end

    if not spawnAttachment then return false, "base is full" end

    -- Clone and place
    local clonedAnimal = animalModel:Clone()
    clonedAnimal:PivotTo(spawnCFrame)
    clonedAnimal.Parent = spawnAttachment

    -- Anchor all parts
    for _, d in ipairs(clonedAnimal:GetDescendants()) do
        if d:IsA("BasePart") then d.Anchored = true end
    end

    -- Play idle animation
    local animController = clonedAnimal:FindFirstChildOfClass("AnimationController")
    local idleFolder = ReplicatedStorage.Animations.Animals:FindFirstChild(internalName)
    local idleAnim = idleFolder and idleFolder:FindFirstChild("Idle")
    if animController and idleAnim then
        local track = animController:LoadAnimation(idleAnim)
        track:Play()
    end

    -- Play sound
    local soundFolder = ReplicatedStorage.Sounds:FindFirstChild("Animals")
    if soundFolder then
        local snd = soundFolder:FindFirstChild(internalName)
        if snd and snd:IsA("Sound") then
            local sc = snd:Clone()
            sc.Parent = clonedAnimal.PrimaryPart or clonedAnimal:FindFirstChildWhichIsA("BasePart")
            sc:Play()
            sc.Ended:Connect(function() sc:Destroy() end)
        end
    end

    -- Apply mutation color
    if selectedMutation and selectedMutation ~= "None" and mutationMap[selectedMutation] then
        for _, p in ipairs(clonedAnimal:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") then
                p.Color = mutationMap[selectedMutation].color
            end
        end
    end

    -- Apply trait models
    if selectedTraits then
        local traitsFolder = ReplicatedStorage.Models:FindFirstChild("Traits")
        for _, traitName in ipairs(selectedTraits) do
            local tm = traitsFolder and traitsFolder:FindFirstChild(traitName)
            if tm then tm:Clone().Parent = clonedAnimal end
        end
    end

    -- Attach overhead billboard
    local overheadTemplate = ReplicatedStorage.Overheads:FindFirstChild("AnimalOverhead")
    local head = clonedAnimal:FindFirstChild("Head") or clonedAnimal.PrimaryPart
    if overheadTemplate and head then
        local oh = overheadTemplate:Clone()
        oh.StudsOffset = Vector3.new(0, 7, 0)
        oh.Adornee = head
        oh.Parent = head
    end

    return true
end

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VisualDupe_OwnBase"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 440, 0, 580)
Main.Position = UDim2.new(0.5, -220, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(60, 60, 60)

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VisualDupe - Own Base Duper"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 28)
StatusLabel.Position = UDim2.new(0, 10, 0, 54)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready - Click Refresh"
StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusLabel.TextSize = 15
StatusLabel.Font = Enum.Font.Gotham

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 0, 390)
Scroll.Position = UDim2.new(0, 10, 0, 86)
Scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", Scroll).CornerRadius = UDim.new(0, 8)
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
local SPad = Instance.new("UIPadding", Scroll)
SPad.PaddingTop = UDim.new(0, 6)
SPad.PaddingLeft = UDim.new(0, 5)
SPad.PaddingRight = UDim.new(0, 5)

local RefreshBtn = Instance.new("TextButton", Main)
RefreshBtn.Size = UDim2.new(0.48, 0, 0, 44)
RefreshBtn.Position = UDim2.new(0.02, 0, 0, 490)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 40)
RefreshBtn.Text = "REFRESH LIST"
RefreshBtn.TextColor3 = Color3.new(1,1,1)
RefreshBtn.TextSize = 17
RefreshBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 8)

local DupeBtn = Instance.new("TextButton", Main)
DupeBtn.Size = UDim2.new(0.48, 0, 0, 44)
DupeBtn.Position = UDim2.new(0.5, 0, 0, 490)
DupeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
DupeBtn.Text = "DUPE SELECTED"
DupeBtn.TextColor3 = Color3.new(1,1,1)
DupeBtn.TextSize = 17
DupeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", DupeBtn).CornerRadius = UDim.new(0, 8)

local AutoBtn = Instance.new("TextButton", Main)
AutoBtn.Size = UDim2.new(0.96, 0, 0, 34)
AutoBtn.Position = UDim2.new(0.02, 0, 0, 538)
AutoBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AutoBtn.Text = "AUTO DUPE: OFF"
AutoBtn.TextColor3 = Color3.new(1,1,1)
AutoBtn.TextSize = 15
AutoBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 8)

-- ==================== LIST & BUTTON LOGIC ====================
local selected = nil
local buttons = {}
local autoEnabled = false

local function updateList()
    for _, obj in ipairs(buttons) do obj:Destroy() end
    buttons = {}
    selected = nil

    StatusLabel.Text = "Scanning..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 100)

    local list = getBrainrots()

    if #list == 0 then
        StatusLabel.Text = "No brainrots found on your base"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        return
    end

    StatusLabel.Text = #list .. " brainrot(s) found"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)

    for _, br in ipairs(list) do
        local btn = Instance.new("TextButton", Scroll)
        btn.Size = UDim2.new(1, 0, 0, 70)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Text = ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local nameLbl = Instance.new("TextLabel", btn)
        nameLbl.Size = UDim2.new(1, -10, 0.5, 0)
        nameLbl.Position = UDim2.new(0, 10, 0, 5)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = br.name .. (br.internalName and br.internalName ~= br.name and (" [" .. br.internalName .. "]") or "")
        nameLbl.TextColor3 = Color3.new(1,1,1)
        nameLbl.TextSize = 17
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local genLbl = Instance.new("TextLabel", btn)
        genLbl.Size = UDim2.new(1, -10, 0.5, 0)
        genLbl.Position = UDim2.new(0, 10, 0.5, 0)
        genLbl.BackgroundTransparency = 1
        genLbl.Text = br.genText
        genLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
        genLbl.TextSize = 15
        genLbl.Font = Enum.Font.Gotham
        genLbl.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseButton1Click:Connect(function()
            selected = br
            for _, b in ipairs(buttons) do b.BackgroundColor3 = Color3.fromRGB(35,35,35) end
            btn.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
            StatusLabel.Text = "Selected: " .. br.name
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
        end)
        table.insert(buttons, btn)
    end
end

RefreshBtn.MouseButton1Click:Connect(updateList)

DupeBtn.MouseButton1Click:Connect(function()
    if not selected then
        StatusLabel.Text = "No brainrot selected!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    StatusLabel.Text = "Duping " .. selected.name .. "..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 100)

    local traits = getTraitsFromOverhead(selected.overhead)
    local mutation = getMutationFromOverhead(selected.overhead)
    local success, err = spawnAnimal(
        selected.internalName,
        traits,
        mutation == "None" and nil or mutation,
        selected.position,
        selected.plot
    )

    if success then
        StatusLabel.Text = "✅ Duped " .. selected.name .. "!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(1.5)
        updateList()
    else
        StatusLabel.Text = "❌ Failed: " .. tostring(err)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

AutoBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    AutoBtn.Text = "AUTO DUPE: " .. (autoEnabled and "ON" or "OFF")
    AutoBtn.BackgroundColor3 = autoEnabled and Color3.fromRGB(40, 140, 40) or Color3.fromRGB(80, 80, 80)

    if autoEnabled then
        task.spawn(function()
            while autoEnabled do
                local list = getBrainrots()
                if #list > 0 then
                    local best = list[1]
                    local traits = getTraitsFromOverhead(best.overhead)
                    local mutation = getMutationFromOverhead(best.overhead)
                    local success, err = spawnAnimal(
                        best.internalName,
                        traits,
                        mutation == "None" and nil or mutation,
                        best.position,
                        best.plot
                    )
                    if success then
                        StatusLabel.Text = "✅ Auto-duped: " .. best.name
                        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                    else
                        StatusLabel.Text = "❌ Auto fail: " .. tostring(err)
                        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                else
                    StatusLabel.Text = "Auto: no targets, waiting..."
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                end
                task.wait(3)
            end
        end)
    end
end)

updateList()
