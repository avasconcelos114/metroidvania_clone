extends ColorRect

func _ready():
	if not Global.player:
		return
	$Margin/PlayerStats/HealthGlobe.connect_health_component(Global.player.health_component)
