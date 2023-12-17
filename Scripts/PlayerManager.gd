extends Node

# Player Signals
signal PlayerDied
signal PlayerReceivedDamage
signal PowerupCollected

@onready var player_scene = preload("res://Scenes/Player/Player.tscn")

var player: Player
var collected_powerups: Array[PowerUpStats] = []

func instantiate_player():
	reset_player()

	var new_player = player_scene.instantiate()
	set_player(new_player)
	return new_player

func set_player(new_player: Player):
	player = new_player

func reset_player():
	if player != null:
		player.queue_free()
		player = null

func collect_powerup(powerup: PowerUpStats):
	collected_powerups.append(powerup)
	PowerupCollected.emit()
