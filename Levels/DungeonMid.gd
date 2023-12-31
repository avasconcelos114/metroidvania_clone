extends Node2D

func _ready():
	var boss_health = $Enemies/Demon/HealthComponent as HealthComponent
	if boss_health:
		boss_health.DiedEvent.connect(handle_boss_death)

func _on_area_2d_body_entered(body):
	if body is Player:
		play_boss_music()
		$Enemies/Demon/CanvasLayer.visible = true
		$BossFightTrigger.queue_free()

func handle_boss_death():
	await get_tree().create_timer(5).timeout
	$SFX/BossFightMusic.stop()
	$SFX/FoeVanquisedSound.play()

func play_boss_music():
	$SFX/BackgroundMusic.stop()
	$SFX/BossFightMusic.play()

func play_background_music():
	$SFX/BackgroundMusic.play()
	$SFX/BossFightMusic.stop()
