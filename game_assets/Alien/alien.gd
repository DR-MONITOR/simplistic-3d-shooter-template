extends CharacterBody3D

@export var health = 20
@export var walk_speed: float = 2.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@export var ChaseDistance: float = 15.0
@export var MeleeDamage: int = 2
@export var MeleeAttackDistance: float = 2

func _physics_process(delta):
	move_and_slide()
	
# Function to smoothly rotate the enemy towards the player on the Y-axis
func look_at_y_smooth(target_position: Vector3, delta: float, speed: float):
	var direction = (target_position - global_position).normalized()
	if direction.length() > 0:
		var target_yaw = atan2(direction.x, direction.z)
		var current_yaw = rotation.y
		
		# Interpolate the yaw smoothly using lerp_angle
		var smoothed_yaw = lerp_angle(current_yaw, target_yaw+PI, delta * speed)
		rotation.y = smoothed_yaw
