extends Area2D

signal CollectPowerupSignal

@export var stats: PowerUpStats
@export var notification: ScreenNotification
@export var unique := true

var time = 0
var frequency = 8
var default_position: Vector2

func _ready():
	# Remove powerup if it's a unique one and it has already been picked up
	if unique:
		for powerups in PlayerManager.collected_powerups:
			if powerups.powerup_id == stats.powerup_id:
				queue_free()
	
	default_position = position
	$Sprite2D.texture = stats.texture
	body_entered.connect(collect_powerup)

func _physics_process(delta):
	time += delta * frequency
	position.y = default_position.y + sin(time)

func collect_powerup(body):
	if body is Player:
		$PassiveSFX.stop()
		$ActiveSFX.play()
		PlayerManager.collect_powerup(stats)
		notification.emit_signal("ShowTextSignal", stats.collect_message, 3)
		visible = false
		$ActiveSFX.finished.connect(queue_free)
