extends Node2D

signal battle_ended
signal game_over

@onready var health = get_node("Health")
@onready var enemy_health = get_node("EnemyHealth")
@onready var enemy = get_node("Enemy")

var hero: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func initialize(original_hero: Node2D):
	hero = original_hero.duplicate()
	add_child(hero)
	hero.position = Vector2(160, 480)
	enemy.set_frame(randi_range(0, 1))


func _on_button_pressed() -> void:
	# var attack_chance = hero.attack()
	var hero_hit;

	if hero_hit:
		update_health(enemy)
	
	var enemy_hit;

	if enemy_hit:
		update_health(hero)
	
	pass # Replace with function body.

func update_health(target: Node2D):
	target.health -= 1;
	
	if target == hero:
		health.set_frame(3 - hero.health)
	
		if (hero.health == 0):
			emit_signal("game_over")
			return

	elif target == enemy:
		enemy_health.set_frame(3 - enemy.health)
		
		if(enemy.health == 0):
			emit_signal("battle_ended")
			return
