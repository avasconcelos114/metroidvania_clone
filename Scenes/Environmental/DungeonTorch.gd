extends Node2D

var time = 0
var vertical_shift = 1.2
var amplitude = 0.15
var period = 7

func _ready():
	time = randi()

func _physics_process(delta):
	time += delta
	$PointLight2D.energy = Global.calculate_sine_wave(amplitude, time, period, vertical_shift)
