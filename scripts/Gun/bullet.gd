extends Area2D

var speed: float = 300.0
var max_distance: float = 800.0
var damage: int = 10
var start_position: Vector2

func setup(p_damage: int, p_speed: float, p_range: float) -> void:
	damage = p_damage
	speed = p_speed
	max_distance = p_range
	# --- CHANGED: Record the start position here, AFTER it is moved to the muzzle! ---
	start_position = global_position

# (Removed the _ready function completely)

func _process(delta: float) -> void:
	# Using global_position here is safer when working with Area2D nodes
	global_position += transform.x * speed * delta
	
	if global_position.distance_to(start_position) > max_distance:
		queue_free()

func on_hit(target) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
	queue_free()
