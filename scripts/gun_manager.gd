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
var is_shooting: bool = false  # Tracks if the player is holding LMB for automatic guns
var gun_index: int = 0  # Current index of the active gun in the guns array

func _ready():
	$AnimationPlayer.play("move_side")
	# Get all children that are of the class "Gun"
	guns = get_children().filter(func(child): return child is Gun)
	
	# Set initial visible gun based on the current_gun
	update_current_gun_visibility()
	
	# Connect signals from each gun
	for gun in guns:
		gun.connect("shoot_", Callable(self, "_on_gun_shoot"))
		gun.connect("reload_", Callable(self, "_on_gun_reload"))

func ads(value: bool):
	print("ADS function triggered with value: ", value)  # Debug
	if value:  # Enter ADS
		$AnimationPlayer.play_backwards("move_side")
	else:  # Exit ADS
		$AnimationPlayer.play("move_side")

func _process(delta: float):
	# Check if the player is holding LMB for automatic guns
	if is_shooting:
		var gun = get_current_gun()
		if gun and gun.is_automatic:
			current_gun_shoot()

func _input(event):
	if player_node:
		if event.is_action_pressed("lmb"):
			var gun = get_current_gun()
			if gun:
				if gun.is_automatic:
					is_shooting = true  # Start shooting automatically
				else:
					current_gun_shoot()  # Shoot once for manual guns
		elif event.is_action_released("lmb"):
			is_shooting = false  # Stop automatic shooting
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
		# Scroll to change guns
		elif event.is_action_pressed("ui_up"):
			switch_gun(true)
		elif event.is_action_pressed("ui_down"):
			switch_gun(false)

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

# Scroll through guns by switching the gun index
func switch_gun(next: bool):
	if next:
		# Switch to the next gun
		gun_index = (gun_index + 1) % guns.size()
	else:
		# Switch to the previous gun
		gun_index = (gun_index - 1 + guns.size()) % guns.size()
	
	# Set the current gun based on the new index
	current_gun = guns[gun_index].name
	
	# Update the visibility of the guns
	update_current_gun_visibility()

# Make only the current gun visible
func update_current_gun_visibility():
	for gun in guns:
		if gun.name == current_gun:
			gun.visible = true
		else:
			gun.visible = false

# Signal Handlers
func _on_gun_shoot(bullet_capacity):
	# Handle shoot signal, logic to manage ammo or UI updates can go here
	print("Shot fired. Remaining bullets: ", bullet_capacity)

func _on_gun_reload(magazine_capacity):
	# Handle reload signal, logic to reset magazine or UI updates
	print("Reloaded. Magazine capacity: ", magazine_capacity)
