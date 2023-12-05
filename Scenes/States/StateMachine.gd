extends Node
class_name StateMachine

@export var initial_state : BaseState

var current_state : BaseState
var states : Dictionary = {}

# Get all State children to populate "states" with
func _ready():
	for child in get_children():
		if child is BaseState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)

	if initial_state:
		initial_state.enter_state()
		current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func get_current_state():
	return current_state

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit_state()
	
	new_state.enter_state()
	current_state = new_state
