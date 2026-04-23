extends Area2D

var speed: float = 400.0
var max_distance: float = 600.0
var damage: int = 8
var start_position: Vector2
 
func setup(p_damage: int, p_speed: float, p_range: float) -> void:
	damage = p_damage
	speed = p_speed
	max_distance = p_range
 
func _ready() -> void:
	start_position = global_position
	body_entered.connect(_on_body_entered)
 
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	if global_position.distance_to(start_position) > max_distance:
		queue_free()
 
func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
