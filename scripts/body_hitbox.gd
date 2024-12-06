extends Area3D

var body_damage_multiplier = 0.8

func take_damage(damage:int):
	get_parent().take_damage(int(damage*body_damage_multiplier))
