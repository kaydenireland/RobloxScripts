game.Players.PlayerAdded:Connect(function(player)
	local playerStats = Instance.new("Folder")
	playerStats.Name = "leaderstats"
	playerStats.Parent = player
	
	local deaths = Instance.new("IntValue")
	deaths.Name = "Deaths"
	deaths.Value = 0
	deaths.Parent = playerStats
end)