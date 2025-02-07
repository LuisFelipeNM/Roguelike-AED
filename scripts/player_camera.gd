extends Camera2D

const MIN_ZOOM: float = 0.4
const MAX_ZOOM: float = 2
const ZOOM_INCREMENT: float = 0.1
const ZOOM_RATE: float = 8.0

const START_POSITION: Vector2 = Vector2(400, 100)
const BOUNDS_MIN: Vector2 = Vector2(-600, 100)
const BOUNDS_MAX: Vector2 = Vector2(1400, 5000)

var _target_zoom: float = 1.0

func _ready() -> void:
	position = START_POSITION

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative * (Vector2(1,1) / zoom)
			position.x = clamp(position.x, BOUNDS_MIN.x, BOUNDS_MAX.x)
			position.y = clamp(position.y, BOUNDS_MIN.y, BOUNDS_MAX.y)

	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)

		set_physics_process(true)

func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))
	
	# Reapply movement constraints after zoom
	position.x = clamp(position.x, BOUNDS_MIN.x, BOUNDS_MAX.x)
	position.y = clamp(position.y, BOUNDS_MIN.y, BOUNDS_MAX.y)
