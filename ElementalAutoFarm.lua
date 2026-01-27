local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local VirtualUser=game:GetService("VirtualUser")
local Workspace=game:GetService("Workspace")
local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")

for _,obj in ipairs(playerGui:GetChildren())do if obj.Name=="AutoTPGui"then obj:Destroy()end end

local character=player.Character or player.CharacterAdded:Wait()
local humanoid=character:WaitForChild("Humanoid")
local rootPart=character:WaitForChild("HumanoidRootPart")

for _,obj in ipairs(Workspace:GetDescendants())do if(obj.Name=="Diamond"or obj.Name=="AB")and(obj:IsA("BasePart")or obj:IsA("Model"))then obj:Destroy()end end

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="AutoTPGui"
ScreenGui.ResetOnSpawn=false
ScreenGui.Parent=playerGui

local MainFrame=Instance.new("Frame",ScreenGui)
MainFrame.Size=UDim2.new(0,300,0,160)
MainFrame.Position=UDim2.new(0,10,0,80)
MainFrame.BackgroundColor3=Color3.fromRGB(18,18,18)
MainFrame.BorderSizePixel=2
MainFrame.BorderColor3=Color3.fromRGB(100,100,100)
MainFrame.Active=true
MainFrame.Draggable=true
MainFrame.Visible=false
Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,12)

local Title=Instance.new("TextLabel",MainFrame)
Title.Size=UDim2.new(1,0,0,35)
Title.BackgroundTransparency=1
Title.Text="Auto Farm Controller"
Title.TextColor3=Color3.fromRGB(255,255,255)
Title.Font=Enum.Font.GothamBold
Title.TextSize=16

local DiamondToggle=Instance.new("TextButton",MainFrame)
DiamondToggle.Size=UDim2.new(0.9,0,0,40)
DiamondToggle.Position=UDim2.new(0.05,0,0,45)
DiamondToggle.BackgroundColor3=Color3.fromRGB(30,30,30)
DiamondToggle.BorderSizePixel=0
DiamondToggle.Text="Auto Farm Diamonds: OFF"
DiamondToggle.TextColor3=Color3.fromRGB(200,255,200)
DiamondToggle.Font=Enum.Font.Gotham
DiamondToggle.TextSize=14
Instance.new("UICorner",DiamondToggle).CornerRadius=UDim.new(0,8)

local ABToggle=Instance.new("TextButton",MainFrame)
ABToggle.Size=UDim2.new(0.9,0,0,40)
ABToggle.Position=UDim2.new(0.05,0,0,95)
ABToggle.BackgroundColor3=Color3.fromRGB(40,20,20)
ABToggle.BorderSizePixel=0
ABToggle.Text="Auto TP to Void Orb: OFF"
ABToggle.TextColor3=Color3.fromRGB(255,180,180)
ABToggle.Font=Enum.Font.Gotham
ABToggle.TextSize=14
Instance.new("UICorner",ABToggle).CornerRadius=UDim.new(0,8)

local StatusLabel=Instance.new("TextLabel",MainFrame)
StatusLabel.Size=UDim2.new(1,-20,0,20)
StatusLabel.Position=UDim2.new(0,10,1,-25)
StatusLabel.BackgroundTransparency=1
StatusLabel.Text="Status: Ready"
StatusLabel.TextColor3=Color3.fromRGB(150,255,150)
StatusLabel.Font=Enum.Font.Gotham
StatusLabel.TextSize=12

local ToggleButton=Instance.new("TextButton",ScreenGui)
ToggleButton.Size=UDim2.new(0,50,0,50)
ToggleButton.Position=UDim2.new(0,10,0,10)
ToggleButton.BackgroundColor3=Color3.fromRGB(30,30,30)
ToggleButton.BorderSizePixel=2
ToggleButton.BorderColor3=Color3.fromRGB(120,120,120)
ToggleButton.Active=true
ToggleButton.Draggable=true
ToggleButton.Text="Show"
ToggleButton.TextColor3=Color3.fromRGB(200,200,200)
ToggleButton.Font=Enum.Font.GothamBold
ToggleButton.TextSize=12
Instance.new("UICorner",ToggleButton).CornerRadius=UDim.new(1,0)

local diamondEnabled=false
local abEnabled=false
local guiVisible=false
local lastPosition=rootPart.Position
local isTeleporting=false
local currentTarget=nil

local diamondCache={}
local abCache={}

local function buildCache()
	diamondCache={}
	abCache={}
	for _,obj in ipairs(Workspace:GetDescendants())do
		if obj:IsA("BasePart")and obj.Parent then
			if obj.Name=="Diamond"then table.insert(diamondCache,obj)
			elseif obj.Name=="AB"then table.insert(abCache,obj)end
		end
	end
end
buildCache()

Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart")and obj.Parent then
		if obj.Name=="Diamond"then table.insert(diamondCache,obj)
		elseif obj.Name=="AB"then table.insert(abCache,obj)end
	end
end)

Workspace.DescendantRemoving:Connect(function(obj)
	if obj:IsA("BasePart")then
		if obj.Name=="Diamond"then
			for i=#diamondCache,1,-1 do if diamondCache[i]==obj then table.remove(diamondCache,i)end end
		elseif obj.Name=="AB"then
			for i=#abCache,1,-1 do if abCache[i]==obj then table.remove(abCache,i)end end
		end
	end
end)

local function findPart(name)
	return (name=="Diamond"and diamondCache[1])or(name=="AB"and abCache[1])or nil
end

local function returnToStart()
	if lastPosition and rootPart then
		rootPart.CFrame=CFrame.new(lastPosition)
		StatusLabel.Text="Returned."
		task.wait(0.3)
		isTeleporting=false
		currentTarget=nil
	end
end

local function teleportTo(part)
	if isTeleporting then return end
	isTeleporting=true
	currentTarget=part
	lastPosition=rootPart.Position
	rootPart.CFrame=CFrame.new(part.Position+Vector3.new(0,5,0))
	StatusLabel.Text="TP to "..part.Name.."!"
end

DiamondToggle.MouseButton1Click:Connect(function()
	diamondEnabled=not diamondEnabled
	DiamondToggle.Text="Auto Farm Diamonds: "..(diamondEnabled and"ON"or"OFF")
	DiamondToggle.BackgroundColor3=diamondEnabled and Color3.fromRGB(20,80,20)or Color3.fromRGB(30,30,30)
end)

ABToggle.MouseButton1Click:Connect(function()
	abEnabled=not abEnabled
	ABToggle.Text="Auto TP to Void Orb: "..(abEnabled and"ON"or"OFF")
	ABToggle.BackgroundColor3=abEnabled and Color3.fromRGB(100,20,20)or Color3.fromRGB(40,20,20)
end)

ToggleButton.MouseButton1Click:Connect(function()
	guiVisible=not guiVisible
	MainFrame.Visible=guiVisible
	ToggleButton.Text=guiVisible and"Hide"or"Show"
end)

RunService.Heartbeat:Connect(function()
	if not character or not character:FindFirstChild("HumanoidRootPart")then
		character=player.Character or player.CharacterAdded:Wait()
		rootPart=character:WaitForChild("HumanoidRootPart")
		humanoid=character:WaitForChild("Humanoid")
		return
	end

	if diamondEnabled and not isTeleporting then
		local d=findPart("Diamond")
		if d and d.Parent then teleportTo(d)end
	end

	if abEnabled and not isTeleporting then
		local a=findPart("AB")
		if a and a.Parent then teleportTo(a)end
	end

	if isTeleporting and currentTarget and not currentTarget.Parent then
		returnToStart()
	end
end)

player.CharacterAdded:Connect(function(newChar)
	character=newChar
	humanoid=character:WaitForChild("Humanoid")
	rootPart=character:WaitForChild("HumanoidRootPart")
end)
