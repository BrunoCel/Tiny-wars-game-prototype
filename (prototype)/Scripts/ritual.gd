extends Node

@export var damage_amount : int = 1
@onready var area_2D = $Area2D


func Deal_Damge()->void:
	var bodies = area_2D.get_overlapping_bodies()
	for bodie in bodies:
		if bodie.is_in_group("enemies"):
			var enemy: Enemy = bodie
			enemy.Take_Damage(damage_amount)
