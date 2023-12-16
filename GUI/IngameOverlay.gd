extends ColorRect

func _ready():
	if not PlayerManager.player:
		return
	$Margin/PlayerStats/HealthGlobe.connect_health_component(PlayerManager.player.health_component)
