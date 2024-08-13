extends Node2D

@export var game_ui : CanvasLayer
@export var game_over_ui : PackedScene

func _ready():
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	
		
	var game_overUI : GameOverUI = game_over_ui.instantiate()
	game_overUI.monsters_defeated = GameManager.monsters_defeated
	game_overUI.time_survived = GameManager.time_passed_string
	
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	add_child(game_overUI)
	
