extends MarginContainer

func _ready():
	if not Global.player:
		return
	$PlayerStats/HealthGlobe.connect_health_component(Global.player.health_component)
