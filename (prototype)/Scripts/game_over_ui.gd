class_name GameOverUI
extends CanvasLayer

@onready var monster_label : Label = %MonsterCouterLabel
@onready var timer_label : Label = %TimeCouterLabel

@export var restart_delay : float = 5.0
var restart_cooldown : float
var time_survived : String
var monsters_defeated : int = 0

func _ready():
	restart_cooldown = restart_delay
	timer_label.text = time_survived
	monster_label.text = str(monsters_defeated)

func _process(delta):
	restart_delay -= delta
	if restart_delay<= 0.0 :
		restart_game()
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
	print("game Over")
	

