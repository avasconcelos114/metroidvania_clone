extends Node2D

@onready var player_scene = preload("res://Scenes/Player/Player.tscn")
@onready var level_0_scene = preload("res://Levels/Level_00.tscn")
@onready var ingame_overlay_scene = preload("res://GUI/IngameOverlay.tscn")

var current_level
var current_player
var overlay

func load_level():
		# Load first level
	current_level = level_0_scene.instantiate()
	add_child(current_level)
	# Spawn in player
	var spawn = current_level.find_child("PlayerSpawnPoint") as Marker2D
	if spawn:
		current_player = player_scene.instantiate()
		current_player.global_position = spawn.global_position
		current_level.add_child(current_player)
		Global.set_player(current_player)
		
		overlay = ingame_overlay_scene.instantiate()
		$GUI.add_child(overlay)

	if not Global.PlayerDied.is_connected(display_game_over_screen):
		Global.PlayerDied.connect(display_game_over_screen)

func display_game_over_screen():
	$GUI/GameOverScreen.visible = true

func _on_game_over_screen_reload_level_pressed():
	$GUI/GameOverScreen.visible = false
	current_level.queue_free()
	current_player.queue_free()
	overlay.queue_free()
	load_level()

func _on_title_screen_start_button_pressed():
	load_level()
	$GUI/TitleScreen.visible = false

func _on_title_screen_quit_button_pressed():
	get_tree().quit()
