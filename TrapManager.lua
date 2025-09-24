local CollectionService = game:GetService("CollectionService")

local TRAP_TAG = "KillTrap"

-- Ensures that the event only applies to players
function onTouch(otherPart: BasePart)
	if otherPart and otherPart.Parent then
		local player = otherPart.Parent:FindFirstChild("Humanoid")
		if player then
			player.Health = 0
		end
	end
end

-- Adds the touched event to the trap part
function initializeTrap(trap: Instance)
	if not trap:IsA("BasePart") then
		-- If the trap part is not a BasePart, we cannot connect the Touched event
		-- Defends against if a tag is misapplied to a non-part object
		return
	end

	-- Connect the Touched event to handle when a player touches the trap
	trap.Touched:Connect(onTouch)
end

-- Gets all parts with the trap tag and applies the initializeTrap function
for _, trap in CollectionService:GetTagged(TRAP_TAG) do
	initializeTrap(trap)
end

-- Connect the trap touched event for new trap parts as they are added
CollectionService:GetInstanceAddedSignal(TRAP_TAG):Connect(initializeTrap)