class_name Player
extends CharacterBody2D

@onready var sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var sword_area = $SwordArea
@onready var hit_box_area = $HitBoxArea
@onready var progress_bar = $ProgressBar

var is_running: bool  = false
var is_attacking:bool = false

@export var attack_damage : int = 2
@export var health: int = 100
@export var max_health: int = 100
@export var death_prefab : PackedScene
@export_category("Ritual Atributes")
@export var ritual_prefab : PackedScene
@export var ritual_frequency : float = 20.0
@onready var coin_pick_up_sound = %CoinPickUpSound
@onready var heal_sound = %HealSound

var input_directions
@export_category("Movement Atributes")
@export var speed: float = 300
@export var lerp_factor: float = 0.5

var attack_cooldown : float = 0.0
var hitBox_cooldown : float = 0.0
var ritual_cooldown : float = 20.0

var attack_direction_anim: int = 3

signal meat_collected(value : int)
signal gold_collected(value : int)

func _ready():
	GameManager.player = self
	progress_bar.max_value = max_health
	progress_bar.value = health
func _process(delta: float) -> void:
	
	Reset_Attack_Cooldown(delta)
	update_hitbox_detection(delta)
	update_ritual_cooldown(delta)
	
func _physics_process(delta: float) -> void:
	GameManager.player_position = position
	input_directions = Input.get_vector("move_left","move_right","move_up","move_down",0.15)
	var target_velocity = input_directions * speed
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity,target_velocity,lerp_factor)
	
	move_and_slide()
	
	var was_running = is_running
	is_running = not input_directions.is_zero_approx()
	if !is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("Idle")
	if is_attacking == false:
		if input_directions.x >0:
			sprite2D.flip_h =false
		elif input_directions.x <0:
			sprite2D.flip_h =true
		
	if Input.is_action_just_pressed("attack"):
		Attack()

func Attack() -> void:
	if is_attacking:
		return
	else:
		attack_cooldown = 0.6
		is_attacking =!is_attacking
		var lucky = randi_range(0,1)
		if input_directions.is_zero_approx():
			if sprite2D.flip_h:
				animation_player.play("Attack_side1")
			else:
				animation_player.play("Attack_side2")
		else:
			if input_directions.x !=0 :
				if sprite2D.flip_h:
					animation_player.play("Attack_side1")
				else:
					animation_player.play("Attack_side2")
			elif input_directions.y < 0.15:
				
				if lucky ==1:
					animation_player.play("Attack_up1")
				else:
					animation_player.play("Attack_up2")
			elif input_directions.y >0.15:
				
				if lucky ==1:
					animation_player.play("Attack_down1")
				else:
					animation_player.play("Attack_down2")
		
	
func Reset_Attack_Cooldown(delta)-> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <0:
			is_attacking=false
			is_running =false;
			animation_player.play("Idle")
func Deal_Damage_To_Enemy()->void:
	var bodies = sword_area.get_overlapping_bodies()
	for bodie in bodies:
		if bodie.is_in_group("enemies"):
			var enemy: Enemy = bodie
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction : Vector2
			if  sprite2D.flip_h == true && animation_player.get_current_animation()=="Attack_side1" :
				attack_direction = Vector2.LEFT
				print(sprite2D.flip_h)
			elif  sprite2D.flip_h == false && animation_player.get_current_animation()=="Attack_side2":
				attack_direction = Vector2.RIGHT
				print(sprite2D.flip_h)
			elif animation_player.get_current_animation()=="Attack_up1"||animation_player.get_current_animation()=="Attack_up2":
				attack_direction = Vector2.UP
			elif animation_player.get_current_animation()=="Attack_down1"||animation_player.get_current_animation()=="Attack_down2":
				attack_direction = Vector2.DOWN
			
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >0.55:
				enemy.Take_Damage(attack_damage)
				print(dot_product)
				
			attack_direction = Vector2.LEFT
	
		
		
func update_hitbox_detection(delta : float) -> void:
	hitBox_cooldown -= delta
	if hitBox_cooldown >0:return
	
	hitBox_cooldown=0.5
	
	var bodies = hit_box_area.get_overlapping_bodies()
	for bodie in bodies:
		if bodie.is_in_group("enemies"):
			var enemy: Enemy = bodie
			var damage_amounnt = enemy.attack_damage
			Take_Damage(damage_amounnt)
	pass

func update_ritual_cooldown(delta : float)-> void:
	ritual_cooldown -= delta
	if ritual_cooldown >0:return
	
	ritual_cooldown=ritual_frequency
	
	if ritual_prefab:
		var ritual = ritual_prefab.instantiate()
		
		add_child(ritual)
	
	

func Take_Damage(amount: int) -> void:
	if health <=0: return
	
	health -= amount
	progress_bar.value = health
	print("player health " ,health)
	
	#faz o inimigo piscar-troca a cor pta vermelho cria uma curva de animação - 
	#coloca o controle pro começo - 
	#transforma num quint e depois aplica na animaçao variando a propriedade do objeto
	modulate = Color.RED
	var tween = create_tween() 
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.25)
	
	if health <=0:
		die()
		
func die():
	if death_prefab:
		var death = death_prefab.instantiate()
		death.position = position
		get_parent().add_child(death)
	GameManager.end_game()
	queue_free()

func heal(amount : int) -> int :
	heal_sound.play()
	health += amount
	progress_bar.value = health
	if health > max_health:
		health = max_health
	print("vida do player =",health)
	return health
func gold_take():
	coin_pick_up_sound.play()

