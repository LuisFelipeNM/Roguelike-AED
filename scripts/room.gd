class_name TreeNode
extends Node2D

var order: String
var height: int
var children := []
@onready var button = get_node("Button")

func initialize(pos: Vector2, height: int, order: String = "Left"):
	position = pos
	self.height = height
	self.order = order

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
