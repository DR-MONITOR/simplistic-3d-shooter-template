extends Label3D

# Reference to the gun (Gun node)
@export var gun: NodePath
@export var anim_player: AnimationPlayer

func _process(delta):
	# Get the gun instance
	var gun_instance = get_node_or_null(gun)
	if gun_instance and gun_instance is Gun:
		# Update the label text
		text = "%d / %d" % [gun_instance.bullets_in_magazine, gun_instance.bullet_capacity]
