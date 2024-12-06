extends State

class_name EnemyDeath

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var animation_player: AnimationPlayer = enemy.get_node_or_null("AnimationPlayer")
@onready var HealthManager: Node3D =  enemy.get_node("HealthManager")

var player: CharacterBody3D = null
var animation_finished: bool = false  # Track animation completion

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		print("Player not found!")

func enter():
	if animation_player and animation_player.has_animation("Death"):
		animation_player.play("Death")
		animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	else:
		animation_finished = true  # No animation exists; skip directly to freeing the node

func process(delta):
	if animation_finished:
		enemy.queue_free()

func physics_process(delta):
	enemy.velocity = Vector3.ZERO
	# Gravity application if needed
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()

func _on_animation_finished(anim_name: String):
	# Check if the finished animation is "Death"
	if anim_name == "Death":
		animation_finished = true
