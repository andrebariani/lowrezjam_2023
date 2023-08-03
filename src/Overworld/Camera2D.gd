extends Camera2D

@export var SCROLL_SPEED = 2
@export var SCROLL_FACTOR = 0.25

func _process(delta):
	var scroll_dir = Vector2.ZERO
	scroll_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	scroll_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom.x = clamp(zoom.x + SCROLL_FACTOR, 0.25, 1)
		zoom.y = clamp(zoom.y + SCROLL_FACTOR, 0.25, 1)
	if Input.is_action_just_pressed("zoom_out"):
		zoom.x = clamp(zoom.x - SCROLL_FACTOR, 0.25, 1)
		zoom.y = clamp(zoom.y - SCROLL_FACTOR, 0.25, 1)
	
	self.position += scroll_dir * SCROLL_SPEED * 1
