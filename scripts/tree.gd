extends Node2D

const ROOM_SPACING_X = 300
const ROOM_SPACING_Y = 300
const MAX_HEIGHT = 9

var node_scene = preload("res://scenes/room.tscn")
var root: Node2D
var current_room_node: Node2D
var height = 1

@onready var hero = get_node("../Hero")
@onready var camera = get_node("../PlayerCamera")


func _ready():
	root = node_scene.instantiate()
	root.initialize(Vector2(400, 100), 1)
	root.get_node("Button").disabled = true
	add_child(root)
	current_room_node = root
	hero.history.append(current_room_node)
	hero.position = root.position
	camera.position = root.position
	generate_tree(root, 1)


func generate_tree(node, type: int):
	if height >= MAX_HEIGHT:
		# Generate boss room
		return

	var child_positions = []
	var y_position = node.position.y + ROOM_SPACING_Y
	var orders := []
	
	hero.history.append(node)

	# Compute child positions based on the level structure
	if (height == 1):
			# First branch with two rooms (type 1)
			child_positions = [
				node.position + Vector2(-ROOM_SPACING_X, ROOM_SPACING_Y),
				node.position + Vector2(ROOM_SPACING_X, ROOM_SPACING_Y)
			]
			orders = ["Left", "Right"]
	else:
			# Subsequent levels (Type 2)
			child_positions = [
				Vector2(root.position.x-ROOM_SPACING_X, (height) * ROOM_SPACING_Y + root.position.y),
				Vector2(root.position.x, (height)*ROOM_SPACING_Y + root.position.y),
				Vector2(root.position.x+ROOM_SPACING_X, (height) * ROOM_SPACING_Y + root.position.y)
			]
			orders = ["Left", "Middle", "Right"]

	# Create and connect child nodes
	for pos in child_positions:
		var child = node_scene.instantiate()
		child.initialize(pos, height, orders.pop_front())
		node.children.append(child)
		child.get_node("Button").pressed.connect(_on_button_pressed_from_node_scene.bind(child))
		add_child(child)
	
	# Lines for nodes that cannot be reached
	for child in node.children:
		draw_connection(node.position, child.position, Color(0.4, 0.4, 0.4))
	
	for child in current_room_node.children:
		draw_connection(current_room_node.position, child.position, Color(0.4, 0.4, 0.4))
	
	for i in range(0, len(hero.history)-1):
		draw_connection(hero.history[i].position, hero.history[i+1].position, Color(0.6, 0.6, 0))
	
	# Lines for nodes that can be reached
	match (node.order):
		"Left":
			draw_connection(node.position, node.children[0].position)
			draw_connection(node.position, node.children[1].position)
			if (len(node.children) > 2):
				node.children[2].get_node("Button").disabled = true
		"Middle":
			draw_connection(node.position, node.children[0].position)
			draw_connection(node.position, node.children[2].position)
			node.children[1].get_node("Button").disabled = true
		"Right":
			draw_connection(node.position, node.children[1].position)
			draw_connection(node.position, node.children[2].position)
			if (len(node.children) > 2):
				node.children[0].get_node("Button").disabled = true
	
	height += 1
	current_room_node = node


# Draw a line to represent a connection
func draw_connection(from_position: Vector2, to_position: Vector2, color: Color = Color(1, 1, 1)):
	var line = Line2D.new()
	line.default_color = color
	line.add_point(from_position)
	line.add_point(to_position)
	line.show_behind_parent = true
	add_child(line)


# Clear the scene before rendering the next set of rooms
func clear_scene():
	for child in get_children():
		child.queue_free()


func _on_button_pressed_from_node_scene(node: Node2D):
	#node.get_node("Button").disabled = true
	hero.position = node.position
	camera.position = node.position
	
	for child in get_children():
		print(child)
		if child.has_node("Button"):
			child.get_node("Button").disabled = true

	print("Button pressed in the node scene!")
	generate_tree(node, 2)
