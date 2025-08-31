local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local HttpService = game:GetService("HttpService")

local Window = Fluent:CreateWindow({
    Title = "Chilli Utils",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tab1 = Window:AddTab({ Title = "Auto Joiner", Icon = "search" })
local Tab2 = Window:AddTab({ Title = "Stock", Icon = "package" })
local Tab4 = Window:AddTab({ Title = "Info", Icon = "info" })
local Tab5 = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- Info Tab
Tab4:AddParagraph({
    Title = "About",
    Content = "This script was developed by masssync.\nVersion: 1.0\nGitHub: github.com/gbnopython\nDiscord: w1ndpeak\n\nThanks to all contributors and testers.\nUse responsibly!"
})

-- Stock Tab
local FormatStyleDropdown = Tab2:AddDropdown("FormatStyle", {
    Title = "Format Style",
    Values = {"Discord"},
    Multi = false,
    Default = 1
})
FormatStyleDropdown:OnChanged(function(Value)
    print("Selected Format Style:", Value)
end)
FormatStyleDropdown:SetValue("Discord")

Tab2:AddButton({Title = "Get Local Stock", Description = "", Callback = function() print("Executing Get Local Stock...") end})
Tab2:AddButton({Title = "Get Server Stock", Description = "", Callback = function() print("Executing Get Server Stock...") end})
Tab2:AddButton({Title = "Merge Stock", Description = "", Callback = function() print("Executing Merge Stock...") end})

-- Auto Joiner Tab
local NotifyDropdown = Tab1:AddDropdown("Notify", {
    Title = "notifiers",
    Values = {"10m+"},
    Multi = false,
    Default = 1
})
NotifyDropdown:OnChanged(function(Value)
    print("Notify selecionado:", Value)
    Fluent:Notify({ Title = "Notify", Content = "Você escolheu: " .. Value, Duration = 5 })
end)
NotifyDropdown:SetValue("10m+")

local OGPetsDropdown = Tab1:AddDropdown("OGPets", {Title = "OG Pet", Values = { "Strawberry Elephant" }, Multi = false, Default = 1})
OGPetsDropdown:OnChanged(function(value) print("OG Pet selected:", value) end)

local SecretPetsDropdown = Tab1:AddDropdown("SecretPets", {
    Title = "Secret Pet",
    Values = {"Los Combinasionas","La Grande Combinasion","Chicleteira Bicicleteira","Graipuss Medussi","Garama and Madundung","Esok Sekolah","Dragon Canelloni"},
    Multi = true,
    Default = {}
})
SecretPetsDropdown:OnChanged(function(value) print("Secret Pets selected:", table.concat(value, ", ")) end)

local CommonPetsDropdown = Tab1:AddDropdown("CommonPets", {
    Title = "Common Pet",
    Values = {"Cat","Dog","Rabbit","Parrot"},
    Multi = true,
    Default = {}
})
CommonPetsDropdown:OnChanged(function(value) print("Common Pets selected:", table.concat(value, ", ")) end)

local MythicPetsDropdown = Tab1:AddDropdown("MythicPets", {
    Title = "Mythic Pet",
    Values = {"Phoenix","Dragon","Unicorn"},
    Multi = true,
    Default = {}
})
MythicPetsDropdown:OnChanged(function(value) print("Mythic Pets selected:", table.concat(value, ", ")) end)

local LegendaryPetsDropdown = Tab1:AddDropdown("LegendaryPets", {
    Title = "Legendary Pet",
    Values = {"Golden Dragon","Celestial Wolf","Ancient Phoenix"},
    Multi = true,
    Default = {}
})
LegendaryPetsDropdown:OnChanged(function(value) print("Legendary Pets selected:", table.concat(value, ", ")) end)

local MoneyThresholdBox = Tab1:AddInput("MoneyThreshold", {
    Title = "Min Farm",
    Placeholder = "Ex: 10",
    Default = "",
    Callback = function(Value)
        local minVal = tonumber(Value)
        if minVal then
            print("Money Threshold set to:", minVal)
        else
            print("Invalid value! Please enter a number.")
        end
    end
})

-- Toggle Bypass 10M (agora executa função)
local Bypass10MToggle = Tab1:AddToggle("Bypass10M", {Title = "Bypass 10M Fake", Default = false})

Bypass10MToggle:OnChanged(function(state)
    if state then
        print("Bypass 10M Fake Enabled")
        -- Função para simular log com delay
        local function fakeLog(msg, delayTime)
            delay(delayTime or math.random(1,3), function()
                print("[Fake AutoJoin Log] " .. msg)
            end)
        end

        -- Simula várias ações do Auto Joiner
        fakeLog("Trying to connect to server...", 1)
        fakeLog("Connected to WebSocket", 2)
        fakeLog("Bypassing 10m server: 1234567890", 3)
        fakeLog("Join server clicked (10m+ bypass)", 4)
        fakeLog("Finished bypass successfully!", 5)
    else
        print("Bypass 10M Fake Disabled")
    end
end)


-- Auto Join Toggle
local AutoJoinToggle = Tab1:AddToggle("AutoJoinToggle", {Title = "Enable Auto Join", Default = false})
AutoJoinToggle:OnChanged(function(state)
    if state then
        spawn(function()
            (function()
                repeat wait() until game:IsLoaded()
                local WebSocketURL = "ws://127.0.0.1:51948"
                local function prints(str) print("[AutoJoiner]: " .. str) end
                local function findTargetGui()
                    for _, gui in ipairs(game:GetService('CoreGui'):GetChildren()) do
                        if gui:IsA('ScreenGui') and gui:FindFirstChild('Job-ID Input', true) then
                            return gui
                        end
                    end
                    return nil
                end
                local function setJobIDText(targetGui, text)
                    local jobFrame = targetGui:FindFirstChild('Job-ID Input', true)
                    if not jobFrame then return nil end
                    local inputFrame = jobFrame:FindFirstChild('InputFrame', true)
                    if not inputFrame then return nil end
                    local inputBox = inputFrame:FindFirstChild('InputBox', true)
                    if inputBox and inputBox:IsA('TextBox') then
                        inputBox.Text = text
                        prints('Textbox updated: ' .. text .. ' (10m+ bypass)')
                        return inputBox
                    end
                    return nil
                end
                local function clickJoinButton(targetGui)
                    local joinFrame = targetGui:FindFirstChild('Join Job-ID', true)
                    if not joinFrame then return nil end
                    return joinFrame:FindFirstChildWhichIsA('TextButton', true)
                end
                local function bypass10M(jobId)
                    local targetGui = findTargetGui()
                    setJobIDText(targetGui, jobId)
                    local button = clickJoinButton(targetGui)
                    task.defer(function()
                        task.wait(0.001)
                        for _, conn in ipairs(getconnections(button.MouseButton1Click)) do
                            conn:Fire()
                        end
                        prints('Join server clicked (10m+ bypass)')
                    end)
                end
                local function justJoin(script)
                    local func, err = loadstring(script)
                    if func then
                        local ok, result = pcall(func)
                        if not ok then prints("Error while executing script: " .. result) end
                    else
                        prints("Some unexcepted error: " .. err)
                    end
                end
                local function connect()
                    while true do
                        prints("Trying to connect to " .. WebSocketURL)
                        local success, socket = pcall(WebSocket.connect, WebSocketURL)
                        if success and socket then
                            prints("Connected to WebSocket")
                            local ws = socket
                            ws.OnMessage:Connect(function(msg)
                                if not string.find(msg, "TeleportService") then
                                    prints("Bypassing 10m server: " .. msg)
                                    bypass10M(msg)
                                else
                                    prints("Running the script: " .. msg)
                                    justJoin(msg)
                                end
                            end)
                            local closed = false
                            ws.OnClose:Connect(function()
                                if not closed then
                                    closed = true
                                    prints("The websocket closed, trying to reconnect...")
                                    wait(1)
                                    connect()
                                end
                            end)
                            break
                        else
                            prints("Unable to connect to websocket, trying again..")
                            wait(1)
                        end
                    end
                end
                connect()
            end)()
        end)
    else
        print("Auto Join disabled")
    end
end)

-- Configs do Fluent
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ChilliUtils")
SaveManager:SetFolder("ChilliUtils/specific-game")
InterfaceManager:BuildInterfaceSection(Tab5)
SaveManager:BuildConfigSection(Tab5)

-- Others Tab
local Tab6 = Window:AddTab({ Title = "Others", Icon = "rocket" })
local Options = {"OPEN 3 FLOOR", "OPEN 2 FLOOR", "OPEN 1 FLOOR"}
for _, option in ipairs(Options) do
    Tab6:AddButton({Title = option, Description = "", Callback = function()
        print(option .. " clicked")
    end})
end

Window:SelectTab(5)
Fluent:Notify({Title = "Chilli Utils", Content = "Loaded successfully!", Duration = 8})
SaveManager:LoadAutoloadConfig()
