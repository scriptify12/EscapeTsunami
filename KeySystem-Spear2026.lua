-- Key system wrapper ──────────────────────────────────────────────

local correctKey = "spear001"
local realScript = "https://raw.githubusercontent.com/gumanba/Scripts/main/SpearTraining"
local keyLink    = "https://lootdest.org/s?zRIszMYv"

local setclip = setclipboard or toclipboard or (Clipboard and Clipboard.set) or function() end

local sg = Instance.new("ScreenGui", game.CoreGui) 
sg.Name = "KeySysSpear" 
sg.ResetOnSpawn = false

local f = Instance.new("Frame", sg) 
f.Size = UDim2.new(0, 300, 0, 165) 
f.Position = UDim2.new(0.5, -150, 0.5, -82.5)
f.BackgroundColor3 = Color3.fromRGB(18, 18, 23) 
f.BorderSizePixel = 0

local cr = Instance.new("UICorner", f) 
cr.CornerRadius = UDim.new(0, 10)

local t = Instance.new("TextLabel", f) 
t.Size = UDim2.new(1, 0, 0, 38) 
t.BackgroundTransparency = 1
t.Text = "Key System"
t.TextColor3 = Color3.fromRGB(225, 225, 235) 
t.TextSize = 22 
t.Font = Enum.Font.GothamBold

local st = Instance.new("TextLabel", f) 
st.Size = UDim2.new(1, -20, 0, 18) 
st.Position = UDim2.new(0, 10, 0, 38)
st.BackgroundTransparency = 1 
st.Text = "Enter key to unlock"
st.TextColor3 = Color3.fromRGB(150, 150, 165) 
st.TextSize = 14 
st.Font = Enum.Font.Gotham

local box = Instance.new("TextBox", f) 
box.Size = UDim2.new(0.92, 0, 0, 34) 
box.Position = UDim2.new(0.04, 0, 0, 62)
box.BackgroundColor3 = Color3.fromRGB(32, 32, 38) 
box.TextColor3 = Color3.fromRGB(240, 240, 245)
box.PlaceholderText = "key here..." 
box.Text = "" 
box.Font = Enum.Font.Gotham 
box.TextSize = 15 
box.ClearTextOnFocus = false

local bc = Instance.new("UICorner", box) 
bc.CornerRadius = UDim.new(0, 7)

local sub = Instance.new("TextButton", f) 
sub.Size = UDim2.new(0.44, 0, 0, 36) 
sub.Position = UDim2.new(0.04, 0, 0, 105)
sub.BackgroundColor3 = Color3.fromRGB(0, 162, 255) 
sub.Text = "Submit" 
sub.TextColor3 = Color3.new(1,1,1)
sub.Font = Enum.Font.GothamSemibold 
sub.TextSize = 15

local sc = Instance.new("UICorner", sub) 
sc.CornerRadius = UDim.new(0, 7)

local get = Instance.new("TextButton", f) 
get.Size = UDim2.new(0.44, 0, 0, 36) 
get.Position = UDim2.new(0.52, 0, 0, 105)
get.BackgroundColor3 = Color3.fromRGB(65, 65, 80) 
get.Text = "Get Key" 
get.TextColor3 = Color3.new(1,1,1)
get.Font = Enum.Font.GothamSemibold 
get.TextSize = 15

local gc = Instance.new("UICorner", get) 
gc.CornerRadius = UDim.new(0, 7)

local function verify()
    local inp = box.Text:lower():gsub("%s+", "")
    if inp == correctKey then
        sg:Destroy()
        loadstring(game:HttpGet(realScript, true))()
    else
        box.Text = "" 
        box.PlaceholderText = "Wrong key"
        box.PlaceholderColor3 = Color3.fromRGB(255, 90, 90)
        task.delay(1.2, function()
            box.PlaceholderText = "key here..." 
            box.PlaceholderColor3 = Color3.fromRGB(180, 180, 195)
        end)
    end
end

sub.MouseButton1Click:Connect(verify)
box.FocusLost:Connect(function(enterPressed)
    if enterPressed then verify() end
end)

get.MouseButton1Click:Connect(function()
    setclip(keyLink)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Link copied",
        Text = "Paste in browser → follow steps for key",
        Duration = 4
    })
end)
