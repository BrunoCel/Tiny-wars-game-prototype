class_name MobSpawner
extends Node2D

@onready var path_follow_2D : PathFollow2D = %PathFollow2D
@export var monsters : Array[PackedScene]
var monsters_per_minute : float = 60.0
var spawCooldown : float = 0

func _process(delta : float) :
	if GameManager.is_game_over : return
	
	# temporizador
	spawCooldown -= delta
	if spawCooldown > 0 : return
	
	#frequencia de spawn
	var frequency : float = 60.0 / monsters_per_minute
	spawCooldown = frequency
	
	#pega um ponto e check se o ponto é valido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result = world_state.intersect_point(parameters,1)
	if not result.is_empty(): return
	
	#estancia o mob
	var spawn_chance = randi_range(0,100)
	if spawn_chance >75:
		var index = randi_range(0, monsters.size()-1)
		var monster = monsters[index]
		var enemy = monster.instantiate()
		enemy.position = point
		get_parent().add_child(enemy)
	else :
		var index = randi_range(1, monsters.size()-1)
		var monster = monsters[index]
		var enemy = monster.instantiate()
		enemy.position = get_point()
		get_parent().add_child(enemy)
		
	
	
func get_point() -> Vector2:
	path_follow_2D.progress_ratio = randf()
	return path_follow_2D.global_position
