extends CenterContainer

var health_component = HealthComponent
var current_hp = 0
func connect_health_component(new_health_component: HealthComponent):
	health_component = new_health_component
	current_hp = health_component.current_health

	update_health_label(new_health_component.current_health)
	new_health_component.HealthChangedEvent.connect(update_health_label)

func update_health_label(target_hp):
	animate_to_number(current_hp, target_hp)
	
	var color = Color.WHITE
	var health_percent = health_component.current_health_percent()
	var should_play_low_hp = false
	if health_percent < 20:
		color = Color.CRIMSON
		should_play_low_hp = true
	elif health_percent < 50:
		color = Color.ORANGE
	
	if should_play_low_hp:
		$LowHPSound.play()

	$MarginContainer/HealthLabel.label_settings.font_color = color
	current_hp = target_hp

func animate_to_number(current_hp, target_hp):
	var increment = 1
	if current_hp == target_hp:
		return

	if target_hp < current_hp:
		increment = -1

	current_hp += increment
	$MarginContainer/HealthLabel.text = str(current_hp)
	# Continue to call with small delays until reached target HP
	await get_tree().create_timer(0.03).timeout
	animate_to_number(current_hp, target_hp)
