local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

-- Keeps track of what checkpoint each player has last touched
local lastCheckpointByPlayer: { [Player]: BasePart } = {}

local CHECKPOINT_TAG = "Checkpoint"


-- When a player spawns, teleport them to their last checkpoint
local function onCharacterAdded(character: Model)
	local player = Players:GetPlayerFromCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")

	local checkpoint = lastCheckpointByPlayer[player]
	if not checkpoint then
		-- This player has not touched any checkpoint yet, so we do nothing
		return
	end

	-- Wait for character to load into the game
	if not character.Parent then
		character.AncestryChanged:Wait()
		task.wait()
	end

	-- Determine the target location for the character
	local checkpointOffsetY = checkpoint.Size.Y / 2
	local hipHeightOffsetY = humanoid.HipHeight
	local rootPartOffsetY = humanoid.RootPart.Size.Y / 2
	local totalOffsetY = checkpointOffsetY + hipHeightOffsetY + rootPartOffsetY

	local targetCFrame = checkpoint.CFrame + totalOffsetY * Vector3.yAxis
	-- Flip the direction the player faces by 180 degrees
	targetCFrame = targetCFrame * CFrame.Angles(0, math.rad(180), 0)
	character:PivotTo(targetCFrame)
end

local function initializeCheckpoint(checkpoint: Instance)
	if not checkpoint:IsA("BasePart") then
		return
	end

	-- When a player touches a checkpoint, we update their last touched checkpoint
	local function onCheckpointTouched(hit: BasePart)
		local character = hit.Parent
		if not character then
			return
		end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if (not humanoid) or humanoid.Health <= 0 then
			-- Cannot switch checkpoints if the player is dead
			return
		end
		
		-- Gets the checkpoint number and the player's current level
		local checkpointNumber = checkpoint:FindFirstChild("LevelNumber")
		local levelStat = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level")
		
		-- If the checkpoint number is higher than the player's current level, update the player's level
		print(checkpointNumber.Value)
		print(levelStat.Value)
		print("Checking ifs")
		if checkpointNumber and levelStat then
			print("completed first")
			if checkpointNumber.Value + 1 > levelStat.Value then
				print("completed second")
				levelStat.Value = checkpointNumber.Value + 1
				lastCheckpointByPlayer[player] = checkpoint
			end
		end

		
	end

	checkpoint.Touched:Connect(onCheckpointTouched)
end

-- Connect the character added event for each player
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(onCharacterAdded)
end)

-- Clean up the player's checkpoint data when they leave
Players.PlayerRemoving:Connect(function(player)
	lastCheckpointByPlayer[player] = nil
end)


-- Gets all parts with the checkpoint tag and applies the initializeCheckpoint function
for _, checkpoint in CollectionService:GetTagged(CHECKPOINT_TAG) do
	initializeCheckpoint(checkpoint)
end

-- Connect the checkpoint touched event for new checkpoint parts as they are added
CollectionService:GetInstanceAddedSignal(CHECKPOINT_TAG):Connect(initializeCheckpoint)