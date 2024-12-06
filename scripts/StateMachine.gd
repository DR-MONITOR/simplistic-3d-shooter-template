extends Node
class_name StateMachine

@export var InitialState: State
var is_running: bool = true
var current_state: State = null
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(Callable(self, "on_child_transitioned"))

	if InitialState:
		current_state = InitialState
		current_state.enter()

func _process(delta):
	if is_running and current_state:
		current_state.process(delta)

func _physics_process(delta):
	if is_running and current_state:
		current_state.physics_process(delta)

func on_child_transitioned(state, new_state_name):
	if not is_running or state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return

	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
