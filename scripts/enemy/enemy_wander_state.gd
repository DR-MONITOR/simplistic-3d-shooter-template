extends State

class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0
var y_wander_time: float = 0.0  # Time counter for Y-axis wandering
var y_wander_angle: float = 0.0  # Current random Y-axis pitch

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var animation_player: AnimationPlayer = enemy.get_node("AnimationPlayer")
@onready var HealthManager: Node3D = enemy.get_node("HealthManager")

var player: CharacterBody3D = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		print("Player not found!")

func randomize_variables():
	wander_direction = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0)).normalized()
	wander_time = randf_range(1.5, 4)
	y_wander_time = randf_range(1.0, 3.0)  # Randomize Y-wander interval
	y_wander_angle = randf_range(1.5, 2)  # Initial random Y-axis pitch angle

func enter():
	print("Entering EnemyWander state")
	randomize_variables()
	play_animation("Walk")

func process(delta):
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= delta
	if HealthManager.health <= 0:
		emit_signal("Transitioned", self, "EnemyDeath")
	if player != null and enemy.global_position.distance_to(player.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyChase")

func physics_process(delta):
	enemy.velocity = wander_direction * enemy.walk_speed
	
	# Make the enemy smoothly rotate to face the wandering direction
	enemy.look_at_y_smooth(enemy.global_position + wander_direction, delta, 5)
	
	if enemy.get_node_or_null("CameraHolder") != null:
		# Apply the randomized Y-axis pitch smoothly for additional head movement
		enemy.get_node_or_null("CameraHolder").look_at_x_smooth(enemy.global_position + Vector3(0, y_wander_angle, 0), delta, 5)
	
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()


func play_animation(anim_name: String):
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	else:
		#print("Animation '%s' not found!" % anim_name)
		pass
