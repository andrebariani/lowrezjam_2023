extends Camera2D

@export var SCROLL_MIN = 0.125
@export var SCROLL_MAX = 1
@export var SCROLL_SPEED = 8
@export var SCROLL_FACTOR = 0.125

func _process(_delta):
	var scroll_dir = Vector2.ZERO
	scroll_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	scroll_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom.x = clamp(zoom.x + SCROLL_FACTOR, SCROLL_MIN, SCROLL_MAX)
		zoom.y = clamp(zoom.y + SCROLL_FACTOR, SCROLL_MIN, SCROLL_MAX)
	if Input.is_action_just_pressed("zoom_out"):
		zoom.x = clamp(zoom.x - SCROLL_FACTOR, SCROLL_MIN, SCROLL_MAX)
		zoom.y = clamp(zoom.y - SCROLL_FACTOR, SCROLL_MIN, SCROLL_MAX)
	
	self.position += floor(scroll_dir * SCROLL_SPEED * 1)
