extends Node2D

var value : int = 0
@onready var label = $Node2D/Label


func update_label_text(damage:int)->void:
	value = damage
	
func get_value():
	label.text = str(value)
