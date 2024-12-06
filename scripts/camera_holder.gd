extends Node3D

# Maximum up and down angles in radians
var max_pitch = deg_to_rad(80)  # Adjust as needed (e.g., 80 degrees)

# Smoothly rotate the X-axis (up/down) to look at the target position
func look_at_x_smooth(target_position: Vector3, delta: float, speed: float):
	# Calculate the direction vector from the enemy to the target
	var direction = (target_position - global_position).normalized()
	
	# Calculate the target pitch angle (X-axis rotation)
	var target_pitch = atan2(direction.y, sqrt(direction.x * direction.x + direction.z * direction.z))
	
	# Get the current pitch angle from the transform (rotation.x)
	var current_pitch = rotation.x
	
	# Smoothly interpolate between the current and target pitch
	var smoothed_pitch = lerp_angle(current_pitch, target_pitch, delta * speed)
	
	# Clamp the pitch to the specified limits
	smoothed_pitch = clamp(smoothed_pitch, -max_pitch, max_pitch)
	
	# Apply the clamped and smoothed pitch to the rotation
	rotation.x = smoothed_pitch

func _input(event):
	if event is InputEventMouseMotion:
		# Example input logic for mouse movement (if relevant)
		if get_parent().is_in_group("Player"):
			var pitch_delta = deg_to_rad(event.relative.y * -get_parent().mouse_sensitivity / 100)
			rotation.x = clamp(rotation.x + pitch_delta, -max_pitch, max_pitch)
