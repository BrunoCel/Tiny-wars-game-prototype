extends CanvasLayer

@onready var timer_label : Label = %TimerLabel
@onready var meat_label : Label = %Meatlabel
@onready var gold_label : Label = %GoldLabel


var time_passed = 0.0
var time_passed_rounded
var seconds = 0
var minutes = 0
var hours = 0



func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	GameManager.player.gold_collected.connect(on_gold_collected)
	meat_label.text = str(GameManager.meat_counter)
	gold_label.text = str(GameManager.gold_counter)
	pass
func _process(delta)-> void:
	
	timer_label.text = GameManager.time_passed_string
	
func on_meat_collected(amount : int)->void:
	GameManager.meat_counter+=1
	meat_label.text = str(GameManager.meat_counter)
	
func on_gold_collected(amount : int)->void:
	GameManager.gold_counter+=10
	gold_label.text = str(GameManager.gold_counter)
