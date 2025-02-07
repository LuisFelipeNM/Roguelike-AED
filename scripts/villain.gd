extends Sprite2D

var room: Node2D
var history := []
var elements = [0,0,0,0,0]
const orders = {"Left": ["Left", "Middle"], "Middle": ["Left", "Right"], "Right": ["Middle", "Right"]}
const weaknesses = {2: 0, 0: 1, 4: 2, 1: 3, 3: 4} # Ar <- Fogo, Fogo <- Água, Raio <- Ar, Água <- Terra, Terra <- Raio

func pick_room(rooms, hero_elements):
	var valid_rooms := []
	for i in rooms:
		if i.order in orders[room.order]:
			valid_rooms.append(i)

<<<<<<< HEAD
	# Get all the best elements to counter the hero
	var villain_best_choices = get_best_counters(hero_elements)

	# Prioritize a room that counters at least one hero element
	var best_room = null
	var best_score = -1
	for r in valid_rooms:
		var room_element_index = r.room_element - 1  # Adjust to zero-based index

		# Check if this room contains a counter element
		if room_element_index in villain_best_choices:
			return r  # Immediate best choice

		# If no counter exists, pick the strongest available element for the villain
		elif elements[room_element_index] > best_score:
			best_score = elements[room_element_index]
			best_room = r

	# If no counter was found, return the best reinforcement or a random choice
	return best_room if best_room else valid_rooms.pick_random()

func get_best_counters(hero_elements):
	var best_counters = []
	for i in range(hero_elements.size()):
		if hero_elements[i] > 0:  # The hero has this element
			var counter = weaknesses.get(i, null)  # Find what beats this element
			if counter != null and counter not in best_counters:
				best_counters.append(counter)  # Store the correct index (1-5 range)
	return best_counters
=======
	# Need to write an algorithm for picking the optimal room
	return valid_rooms.pick_random()

>>>>>>> e13225cd82644ce7aceaabd0764f32ea06014a1f

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
