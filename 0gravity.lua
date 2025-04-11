-- UNIVERSAL ZERO GRAVITY SCRIPT WITH GUI
-- Place this in StarterPlayerScripts

-- CONFIGURATION
local toggleKey = "z" -- Key to toggle zero gravity
local floatSpeed = 5
local bounceFactor = 0.8

-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character
local humanoid
local rootPart
local isZeroGravity = false

-- GUI SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZeroGravityGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- DRAGGABLE FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 85)
mainFrame.Position = UDim2.new(1, -210, 1, -100)
mainFrame.AnchorPoint = Vector2.new(0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.4
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TITLE LABEL
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Custom 0 Gravity Script"
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.Gotham
titleLabel.TextSize = 16
titleLabel.TextStrokeTransparency = 0.7
titleLabel.Parent = mainFrame

-- TOGGLE BUTTON
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 50)
toggleButton.Position = UDim2.new(0, 0, 0, 30)
toggleButton.Text = "Zero Gravity: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.Parent = mainFrame

-- FUNCTION: Get character
local function getCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end

-- FUNCTION: Lay down
local function layDown()
	if humanoid then
		humanoid.Sit = true
	end
end

-- FUNCTION: Zero gravity physics loop
local function zeroGravityLoop()
	if isZeroGravity and rootPart then
		rootPart.Velocity = rootPart.Velocity + Vector3.new(0, floatSpeed, 0)

		local currentVelocity = rootPart.Velocity
		if math.abs(rootPart.Position.X) > 500 then
			rootPart.Velocity = Vector3.new(-currentVelocity.X * bounceFactor, currentVelocity.Y, currentVelocity.Z)
		end
		if math.abs(rootPart.Position.Z) > 500 then
			rootPart.Velocity = Vector3.new(currentVelocity.X, currentVelocity.Y, -currentVelocity.Z * bounceFactor)
		end
	end
end

-- FUNCTION: Update button text
local function updateButtonText()
	toggleButton.Text = "Zero Gravity: " .. (isZeroGravity and "ON" or "OFF")
end

-- FUNCTION: Toggle zero gravity
local function toggleZeroGravity()
	isZeroGravity = not isZeroGravity
	updateButtonText()

	if isZeroGravity then
		getCharacter()
		if character then
			layDown()
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
		else
			isZeroGravity = false
			warn("Character not found!")
		end
	else
		if humanoid then
			humanoid.Sit = false
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
			if rootPart then
				rootPart.Velocity = Vector3.new(0, 0, 0)
			end
		end
	end
end

-- CONNECT BUTTON & KEY TO TOGGLE FUNCTION
toggleButton.MouseButton1Click:Connect(toggleZeroGravity)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode[string.upper(toggleKey)] and not gameProcessed then
		toggleZeroGravity()
	end
end)

-- RUN PHYSICS LOOP
RunService.Stepped:Connect(zeroGravityLoop)

print("✅ Zero Gravity script with GUI loaded! Press '" .. toggleKey .. "' or use the button.")
