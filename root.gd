extends Node2D

@onready var player_scene = preload("res://Scenes/Player/Player.tscn")
@onready var level_0_scene = preload("res://Levels/Level_00.tscn")

func _ready():
	# Load first level
	var level_instance = level_0_scene.instantiate()
	add_child(level_instance)
	# Spawn in player
	var spawn = level_instance.find_child("PlayerSpawnPoint") as Marker2D
	if spawn:
		var player_instance = player_scene.instantiate()
		player_instance.global_position = spawn.global_position
		level_instance.add_child(player_instance)
		Global.set_player(player_instance)
	
	Global.PlayerDied.connect(display_game_over_screen)
	
func display_game_over_screen():
	$GUI/GameOverScreen.visible = true

func _on_game_over_screen_reload_level_pressed():
	$GUI/GameOverScreen.visible = false
	get_tree().reload_current_scene()
