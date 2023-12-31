extends BaseState

@export var enemy: BaseEnemy

var timer: Timer

func enter_state():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.1
	enemy.add_child(timer)
	timer.timeout.connect(transition_to_idle)
	timer.start()

func exit_state():
	timer.stop()
	timer.queue_free()

func physics_update(delta):
	enemy.gravity(delta)
	enemy.move_and_slide()

func transition_to_idle():
	Transitioned.emit(self, 'idle')
