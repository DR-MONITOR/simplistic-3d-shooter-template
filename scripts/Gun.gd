extends Node3D
class_name Gun

# Exports
@export var magazine_capacity: int  # Bullets per magazine
@export var bullet_capacity: int # Total bullets available
@export var is_automatic:bool
@export var raycast:RayCast3D
@export var raycast_indicator:Label3D

# Signals
signal shoot_(bullet_capacity: int)
signal reload_(magazine_capacity: int)

# Variables
@onready var bullets_in_magazine: int = magazine_capacity
var bullet_damage : int = 10

func _ready():
	raycast.set_collide_with_areas(true)

func _process(_delta):
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider:
			raycast_indicator.text = collider.name
		else:
			raycast_indicator.text = "Collision but no collider"
	else:
		raycast_indicator.text = "nothing"

func shoot():
	if bullets_in_magazine > 0:
		if not $AnimationPlayer.is_playing():
			bullets_in_magazine -= 1
			$AnimationPlayer.play("shoot")
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				attack_target(collider)
			emit_signal("shoot_", bullets_in_magazine)
	else:
		if not $AnimationPlayer.is_playing():
			# Play "no ammo" animation only if one isn't already playing
			$AnimationPlayer.play("no_ammo")
			print("No ammo! Reload required.")

func reload():
	if bullet_capacity > 0 and bullets_in_magazine < magazine_capacity:
		if not $AnimationPlayer.is_playing():
			var bullets_to_reload = min(magazine_capacity - bullets_in_magazine, bullet_capacity)
			bullets_in_magazine += bullets_to_reload
			bullet_capacity -= bullets_to_reload
			# Play reload animation
			$AnimationPlayer.play("reload")
			emit_signal("reload_", bullets_in_magazine)
	else:
		print("No bullets left to reload or magazine is already full.")
		

func attack_target(target):
	if target.has_method("take_damage"):
		target.take_damage(bullet_damage)
