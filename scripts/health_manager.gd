extends Node3D

@export var health = 20
@onready var label: Label3D = $health_label
@onready var anim_player:AnimationPlayer = get_parent().get_node_or_null("AnimationPlayer")
func _ready():
	label.text = str(health)

func take_damage(damage: int):
	if health > 0:
		health -= damage
		label.text = str(health)
		if anim_player and anim_player.has_animation("Hit"):
			anim_player.play("Hit")
		check_health()
	else:
		check_health()

func check_health():
	if health <= 0:
		if anim_player:
			var state_machine = get_parent().get_node_or_null("StateMachine")
			if state_machine:
				print("StateMachine will handle the death")
				pass
			pass
		else:
			# If no animation or AnimationPlayer exists, free immediately
			get_parent().queue_free()
