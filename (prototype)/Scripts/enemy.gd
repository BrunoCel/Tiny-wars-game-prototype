class_name Enemy
extends Node2D

@export var health: int = 10
@export var death_prefab : PackedScene

@export var damage_UI : PackedScene
@export var attack_damage : int = 2
@onready var marker_2d = $Marker2D

@export_category("Drop")
@export var drop_chance : float = 0.1

@export var drop_itens : Array[PackedScene]
@export var drop_chances : Array[float]

func Take_Damage(amount: int) -> void:
	health -= amount
	if damage_UI:
			var ui = damage_UI.instantiate()
			ui.position = marker_2d.position
			ui.update_label_text(amount)
			add_child(ui)
	print(health)
	
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
	GameManager.monsters_defeated+=1
	if randf() <= drop_chance :
		var item =Drop_item()
		if item:
			var item_drop = item.instantiate()
			item_drop.position = position
			get_parent().add_child(item_drop)
	else:
		if death_prefab:
			var death = death_prefab.instantiate()
			death.position = position
			get_parent().add_child(death)
	
	
	queue_free()
	
func Drop_item():
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
		
	var lucky = randf() * max_chance
	
	var needle : float = 0.0
	for i in drop_itens.size():
		var drop_item = drop_itens[i]
		var drop_chance = drop_chances[i] if i< drop_chances.size() else 1
		if lucky <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
