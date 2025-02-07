extends Sprite2D

var room: Node2D
var history := []
var elements = [0,0,0,0,0]
const orders = {"Left": ["Left", "Middle"], "Middle": ["Left", "Right"], "Right": ["Middle", "Right"]}


func pick_room(rooms):
	var valid_rooms := []
	
	for i in rooms:
		if i.order in orders[room.order]:
			valid_rooms.append(i)

	# Need to write an algorithm for picking the optimal room
	return valid_rooms.pick_random()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
