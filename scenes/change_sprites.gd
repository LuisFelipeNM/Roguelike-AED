extends Node2D

@onready var ar = get_node("Ar")
@onready var fogo = get_node("Fogo")
@onready var agua = get_node("Agua")
@onready var raio = get_node("Raio")
@onready var terra = get_node("Terra")

var elements_sprites = []  # Stores the references to element sprites

func _ready() -> void:
	elements_sprites = [fogo, agua, ar, terra, raio]  # Order must match `player_elements`
	update_levels()  # Initial update
func _process(delta: float) -> void:
	if Global.update:
		update_levels()
		Global.update = false  # Reset the update flag

func update_levels():
	for i in range(Global.player_elements.size()):
		if elements_sprites[i] is AnimatedSprite2D:
			elements_sprites[i].frame = Global.player_elements[i]
