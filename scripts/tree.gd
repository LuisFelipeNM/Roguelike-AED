extends Node2D

const ROOM_SPACING_X = 150
const ROOM_SPACING_Y = 200
const MAX_DEPTH = 5

var root: TreeNode
var current_room_node: TreeNode


class TreeNode:
	var position: Vector2
	var order: String
	var height: int
	var children := []

	func initialize(pos: Vector2, height: int, order: String = "Left"):
		position = pos
		self.height = height
		self.order = order


func _ready():
	# Initialize the map structure and pre-generate up to MAX_DEPTH
	root = TreeNode.new()
	root.initialize(Vector2(400, 100), 1)
	current_room_node = root
	generate_tree(root, 1)
	render_room(current_room_node)
	move_to_child(1)
	move_to_child(1)

# Generate the tree based on the given rules
func generate_tree(node: TreeNode, height: int):
	if height >= MAX_DEPTH:
		return
	
	var child_positions = []
	var y_position = node.position.y + ROOM_SPACING_Y
	var orders := []

	# Compute child positions based on the level structure
	if (height == 1):
			# First branch with two rooms
			child_positions = [
				node.position + Vector2(-ROOM_SPACING_X, ROOM_SPACING_Y),
				node.position + Vector2(ROOM_SPACING_X, ROOM_SPACING_Y)
			]
			orders = ["Left", "Right"]
	else:
			# Generate three child positions for levels beyond height 2
			child_positions = [
				node.position + Vector2(-2 * ROOM_SPACING_X, ROOM_SPACING_Y),
				node.position + Vector2(0, ROOM_SPACING_Y),
				node.position + Vector2(2 * ROOM_SPACING_X, ROOM_SPACING_Y)
			]
			
			orders = ["Left", "Middle", "Right"]

	var i = 0;
	# Create and connect child nodes
	for pos in child_positions:
		var child_node = TreeNode.new()
		child_node.initialize(pos, height + 1, orders[i])
		node.children.append(child_node)
		generate_tree(child_node, height + 1)
		i += 1

# Render the current room and reveal the next level
func render_room(node: TreeNode):
	#clear_scene()
	current_room_node = node

	# Render current node
	generate_room(node.position)

	# Render children
	for child in node.children:
		# draw_connection(node.position, child.position)
		generate_room(child.position)
		
	print(node.order)
	
	match (node.order):
		"Left":
			draw_connection(node.position, node.children[0].position)
			draw_connection(node.position, node.children[1].position)
		"Middle":
			draw_connection(node.position, node.children[0].position)
			draw_connection(node.position, node.children[2].position)
		"Right":
			draw_connection(node.position, node.children[1].position)
			draw_connection(node.position, node.children[2].position)
		

# Instantiate and position a room
func generate_room(position: Vector2):
	var new_room = preload("res://scenes/room.tscn").instantiate()
	add_child(new_room)
	new_room.position = position

# Draw a line to represent a connection
func draw_connection(from_position: Vector2, to_position: Vector2):
	var line = Line2D.new()
	line.default_color = Color(1, 1, 1)
	line.add_point(from_position)
	line.add_point(to_position)
	line.show_behind_parent = true
	add_child(line)

# Navigate down the tree to the selected child
func move_to_child(index: int):
	if index >= 0 and index < current_room_node.children.size():
		render_room(current_room_node.children[index])

# Clear the scene before rendering the next set of rooms
func clear_scene():
	for child in get_children():
		child.queue_free()
