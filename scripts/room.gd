class_name TreeNode
extends Node2D

var order: String
var height: int
var children := []
var room_element : int

var player_elements = [0,0,0,0,0]
@onready var button = get_node("Button")
@onready var sprite = get_node("Elements")

func initialize(pos: Vector2, height: int, order: String = "Left"):
	position = pos
	self.height = height
	self.order = order
	
	room_element = randi_range(1, 5)
	print("Room element: ", room_element)
	if (Global.update):
		call_deferred("update_sprite", room_element)
	
	Global.update = true
# Called when the node enters the scene tree for the first time.
func update_sprite(element: int) -> void:
	if sprite:
		sprite.frame = element
		sprite.visible = true
		
func update_player_elements(element: int) -> void:
	print("Element: ", element)
	if element >= 1 and element <= 5:
		var index = element - 1
		Global.player_elements[index] = min(Global.player_elements[index] + 1, 4)
		print("Player elements: ", Global.player_elements)
	else:
		print("Element out of range.")

func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_button_pressed() -> void:
	print("Button pressed! Room element: ", room_element)
	update_player_elements(room_element)
