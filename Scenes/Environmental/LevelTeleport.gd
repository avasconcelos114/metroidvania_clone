extends Area2D

@export var level_name: String
@export var spawn_point_name: String

func _ready():
	body_entered.connect(teleport_to_level)

func teleport_to_level(body):
	if body is Player:
		Global.emit_signal("LevelChangedSignal", level_name, spawn_point_name)
