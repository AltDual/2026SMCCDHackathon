class_name WeaponResource
extends Resource

@export var weapon_name: String = "Pistol"
@export var damage: int = 10
@export var fire_rate: float = 0.05
@export var bullet_speed: float = 300.0
@export var bullet_range: float = 800.0


@export var pattern: String = "circle"  # "single", "spread", "circle"
@export var pellet_count: int = 5
@export var spread_angle: float = 30.0

@export var is_automatic: bool = false
