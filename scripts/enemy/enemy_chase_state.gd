extends State

class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var animation_player: AnimationPlayer = enemy.get_node("AnimationPlayer")
@onready var HealthManager: Node3D = enemy.get_node("HealthManager")
var player: CharacterBody3D = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		print("Player not found!")

func enter():
	play_animation("Sprint")  # Transition to Sprint animation
	print("Entering EnemyChase state")

func exit():
	print("Exiting EnemyChase state")

func process(delta):
	if !animation_player.is_playing():
		play_animation("Sprint") 
	if HealthManager.health <= 0:
		emit_signal("Transitioned", self, "EnemyDeath")
	
	if not player or not player.is_inside_tree():
		print("Player is no longer valid, exiting state")
		emit_signal("Transitioned", self, "EnemyWander")
		return
	
	enemy.navigation_agent.set_target_position(player.global_position)
	if enemy.navigation_agent.is_navigation_finished():
		return
	
	if enemy.global_position.distance_to(player.global_position) > enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyWander")
		
	if enemy.global_position.distance_to(player.global_position) < enemy.MeleeAttackDistance:
		emit_signal("Transitioned", self, "EnemyMeleeAttack")
	pass

func physics_process(delta):
	if not player or not player.is_inside_tree():
		# Exit the physics process if the player is no longer valid
		return
	
	var next_position: Vector3 = enemy.navigation_agent.get_next_path_position()
	enemy.velocity = enemy.global_position.direction_to(next_position) * enemy.walk_speed
	
	# Make the enemy look at the player smoothly
	enemy.look_at_y_smooth(player.global_position, delta, 5)
	
	if enemy.get_node_or_null("CameraHolder")!=null:
		# Make the enemy look at the player smoothly
		enemy.get_node("CameraHolder").look_at_x_smooth(player.global_position + Vector3(0, 2, 0), delta, 5)
		enemy.get_node("CameraHolder").get_node("GunManager").current_gun_shoot()

func play_animation(anim_name: String):
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	else:
		#print("Animation '%s' not found!" % anim_name)
		pass
