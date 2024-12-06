extends Node3D

class_name gun_manager
# Exports
@export var current_gun: String = ""  # Current gun identifier
@export var player_node: Player = null
# Signals
signal shoot_(bullet_capacity: int)
signal reload_(magazine_capacity: int)

# Variables
var guns: Array = []

func _ready():
	$AnimationPlayer.play("move_side")
	# Get all children that are of the class "Gun"
	guns = get_children().filter(func(child): return child is Gun)
	for gun in guns:
		# Connect signals from each gun
		gun.connect("shoot_", Callable(self, "_on_gun_shoot"))
		gun.connect("reload_", Callable(self, "_on_gun_reload"))

func ads(value: bool):
	print("ADS function triggered with value: ", value)  # Debug
	if value:  # Enter ADS
		$AnimationPlayer.play_backwards("move_side")
	else:  # Exit ADS
		$AnimationPlayer.play("move_side")

func _input(event):
	if player_node:
		if Input.is_action_just_pressed("lmb"):
			var gun = get_current_gun()
			if gun:
				current_gun_shoot()
		elif Input.is_action_just_pressed("reload"):
			var gun = get_current_gun()
			if gun:
				current_gun_reload()
		elif Input.is_action_just_pressed("rmb"):
			print("RMB pressed - Entering ADS")
			ads(true)
		elif Input.is_action_just_released("rmb"):
			print("RMB released - Exiting ADS")
			ads(false)

func get_current_gun() -> Gun:
	# Find and return the gun matching the current_gun identifier
	for gun in guns:
		if gun.name == current_gun:
			return gun
	return null


func current_gun_shoot():
	var gun = get_current_gun()
	gun.shoot()
	
func current_gun_reload():
	var gun = get_current_gun()
	gun.reload()

# Signal Handlers
func _on_gun_shoot(bullet_capacity):
	# Handle shoot signal, logic to manage ammo or UI updates can go here
	print("Shot fired. Remaining bullets: ", bullet_capacity)

func _on_gun_reload(magazine_capacity):
	# Handle reload signal, logic to reset magazine or UI updates
	print("Reloaded. Magazine capacity: ", magazine_capacity)
