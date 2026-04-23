extends Area2D

var speed: int = 300
var max_distance = 800
var damage: int = 10
var start_position: Vector2

#TODO: Get Rid of debug messages when done
func setup(p_damage: int, p_speed: float, p_range: float) -> void:
	damage = p_damage
	speed = p_speed
	max_distance = p_range

func _ready():
	start_position = global_position
	body_entered.connect(_on_body_entered)
	print("Bullet spawned, mask: ", collision_mask)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
	if global_position.distance_to(start_position) > max_distance:
		queue_free()

func _on_body_entered(body: Node) -> void:
	print("Bullet hit: ", body.name, " | ", body.get_class())
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
