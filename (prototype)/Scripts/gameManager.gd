extends Node

signal game_over

var player : Player
var player_position : Vector2
var is_game_over : bool = false
var monsters_defeated : int = 0
var meat_counter : int = 0
var gold_counter : int = 0

var time_passed = 0.0
var time_passed_string : String 
var time_passed_rounded
var seconds = 0
var minutes = 0
var hours = 0

func _process(delta):
	time_passed += delta
	time_passed_rounded = floori(GameManager.time_passed)
	
	seconds = time_passed_rounded % 60
	minutes = time_passed_rounded / 60
	hours = time_passed_rounded/3600
	
	time_passed_string = "%02d:%02d:%02d" % [hours,minutes,seconds]

func end_game():
	if is_game_over:return
	is_game_over = true
	game_over.emit()
	
func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	monsters_defeated = 0
	time_passed = 0.0
	gold_counter = 0
	meat_counter = 0
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
