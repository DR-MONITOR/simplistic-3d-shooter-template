extends State

class_name EnemyShoot

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready():
	player = get_tree().get_first_node_in_group("Player") 

func enter():
	enemy.get_node("CameraHolder").get_node("GunManager").current_gun_shoot()
	pass

func exit():
	pass

func process(delta):
	enemy.navigation_agent.set_target_position(player.global_position)
	if enemy.navigation_agent.is_navigation_finished():
		return
	
	if enemy.global_position.distance_to(player.global_position) > enemy.ChaseDistance/2:
		emit_signal("Transitioned",self,"EnemyChase")
	
	pass

func physics_process(delta):
	var next_position: Vector3 = enemy.navigation_agent.get_next_path_position()
	enemy.velocity = enemy.global_position.direction_to(next_position) * enemy.walk_speed
	pass
