extends State

class_name EnemyMeleeAttack

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
	if animation_player and animation_player.has_animation("Punch"):
		animation_player.play("Punch")
		
		if not animation_player.is_connected("animation_finished", _on_animation_finished):
			animation_player.connect("animation_finished", _on_animation_finished)
			
		animation_player.play("Punch")
	else:
		animation_finished = true


func process(delta):
	if player != null and enemy.global_position.distance_to(player.global_position) > enemy.MeleeAttackDistance:
		emit_signal("Transitioned", self, "EnemyChase")
	pass

func physics_process(delta):
	enemy.velocity = Vector3.ZERO
	# Gravity application if needed
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()

func _on_animation_finished(anim_name: String):
	# Check if the finished animation is "Death"
	if anim_name == "Punch" and player != null:
		player.get_node("HealthManager").take_damage(enemy.MeleeDamage)
		emit_signal("Transitioned", self, "EnemyChase")
