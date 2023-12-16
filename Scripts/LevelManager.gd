extends Node

signal ChangeLevelSignal
signal LevelLoadedSignal

var current_level_scn: Node2D
var current_level: String
var levels: Dictionary = {
	'tutorial': preload("res://Levels/DungeonTutorial.tscn"),
	'town': preload("res://Levels/Town.tscn"),
	'dungeon': preload("res://Levels/DungeonMid.tscn"),
}

func set_current_level(new_level: String, spawn_name: String = 'PlayerSpawnPoint'):
	if !new_level or not new_level in levels:
		return
	current_level = new_level
	load_level(spawn_name)

func load_level(spawn_name):
	# Load first level
	if current_level_scn:
		current_level_scn.queue_free()

	var new_level = levels[current_level].instantiate()
	add_child(new_level)
	current_level_scn = new_level

	# Spawn in player
	var spawn = current_level_scn.find_child(spawn_name) as Marker2D
	if spawn:
		var new_player = PlayerManager.instantiate_player()
		new_player.global_position = spawn.global_position
		current_level_scn.add_child(new_player)
	LevelLoadedSignal.emit()
