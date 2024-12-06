extends Area3D

var head_damage_multiplier = 2

func take_damage(damage:int):
	get_parent().take_damage(int(damage*head_damage_multiplier))
