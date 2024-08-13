extends Node
var animated_sprite_2d : AnimatedSprite2D 

@export var speed :float = 2.0
var direction :Vector2 = Vector2(0,0)

var enemy : Enemy

func _ready():
	enemy = get_parent()
	animated_sprite_2d = enemy.get_node("AnimatedSprite2D")
	pass

func _physics_process(delta:float) -> void:
	
	if GameManager.is_game_over : return
	
	direction = (GameManager.player_position - enemy.position) 
	var walk_direction = direction.normalized()
	enemy.velocity = walk_direction * speed * 100
	enemy.move_and_slide()
	
	if walk_direction.x >0:
		animated_sprite_2d.flip_h =false
	elif walk_direction.x <0:
		animated_sprite_2d.flip_h =true
