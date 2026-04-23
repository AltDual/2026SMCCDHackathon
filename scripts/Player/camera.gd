extends Camera2D

func _ready() -> void:
	make_current()
	zoom = Vector2.ONE
	position_smoothing_enabled = false
	drag_horizontal_enabled = false
	drag_vertical_enabled = false
	limit_enabled = true

func set_room_limits(room_top_left: Vector2, room_size: Vector2) -> void:
	limit_left = int(room_top_left.x)
	limit_top = int(room_top_left.y)
	limit_right = int(room_top_left.x + room_size.x)
	limit_bottom = int(room_top_left.y + room_size.y)

	print("Camera limits:",
		" L=", limit_left,
		" T=", limit_top,
		" R=", limit_right,
		" B=", limit_bottom
	)

	reset_smoothing()
	force_update_scroll()
