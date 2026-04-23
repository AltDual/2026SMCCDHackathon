class_name UpgradeResource
extends Resource

enum UpgradeType { MAX_HEALTH, SPEED, DAMAGE, FIRE_RATE, BULLET_SPEED, PIERCING, PELLET_COUNT }

@export var upgrade_name: String
@export var description: String
@export var icon: Texture2D
@export var type: UpgradeType
@export var value: float
