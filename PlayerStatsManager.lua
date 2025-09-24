game.Players.PlayerAdded:Connect(function(player)
	-- Creates a folder to store the player's stats
	local playerStats = Instance.new("Folder")
	playerStats.Name = "leaderstats"
	playerStats.Parent = player
	
	-- Adds Death Stat
	local deaths = Instance.new("IntValue")
	deaths.Name = "Deaths"
	deaths.Value = 0
	deaths.Parent = playerStats
	
	-- Adds Level Stat
	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = 1
	level.Parent = playerStats
end)


game.Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.Died:Connect(function()
				-- Increase the death counter
				local deaths = player:FindFirstChild("leaderstats"):FindFirstChild("Deaths")
				if deaths then
					deaths.Value += 1
				end
			end)
		end)
	end)