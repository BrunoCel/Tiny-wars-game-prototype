extends Node2D
@export var gold_amount : int = 20
@onready var area_2d = $Area2D

func _ready():
	area_2d.body_entered.connect(on_body_enter_2D)
	
func on_body_enter_2D(body : Node2D) -> void:
	if body.is_in_group("Player"):
		var player : Player = body
		player.gold_take()
		player.gold_collected.emit(gold_amount)
		queue_free()
	
