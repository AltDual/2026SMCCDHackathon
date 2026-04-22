extends Node2D

@export var weapon_data: WeaponResource

const BULLET = preload("res://scenes/bullet.tscn")
@export var offset := 10.0
@onready var muzzle: Marker2D = $Marker2D

var current_ammo: int
var reserve_ammo: int
var can_fire: bool = true
var is_reloading: bool = false

func _ready() -> void:
	if weapon_data:
		current_ammo = weapon_data.mag_ammo
		reserve_ammo = weapon_data.reserve_ammo
		SignalBus.ammo_changed.emit(current_ammo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	var fire_input = Input.is_action_just_pressed("shoot") if not weapon_data.is_automatic else Input.is_action_pressed("shoot")
	
	if fire_input and can_fire and not is_reloading:
		if current_ammo > 0:
			fire()
		else:
			reload()
	
	if Input.is_action_just_pressed("reload") and not is_reloading:
		reload()
	#if Input.is_action_just_pressed("shoot"):
	#	var bullet_instance = BULLET.instantiate()
	#	get_tree().root.add_child(bullet_instance)
	#	bullet_instance.global_position = muzzle.global_position
	#	bullet_instance.rotation = rotation

func fire() -> void:
	can_fire = false
	current_ammo -= 1
	SignalBus.ammo_changed.emit(current_ammo, reserve_ammo)

	for i in weapon_data.pellet_count:
		var bullet = BULLET.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = muzzle.global_position
		bullet.rotation = rotation
	#	bullet.setup(weapon_data.damage, weapon_data.bullet_speed, weapon_data.bullet_range)

	await get_tree().create_timer(weapon_data.fire_rate).timeout
	can_fire = true

func reload() -> void:
	if reserve_ammo <= 0 or current_ammo == weapon_data.mag_ammo:
		return
	is_reloading = true
	# TODO: play reload animation here
	await get_tree().create_timer(weapon_data.reload_time).timeout
	var needed = weapon_data.mag_ammo - current_ammo
	var given = min(needed, reserve_ammo)
	current_ammo += given
	reserve_ammo -= given
	is_reloading = false
	SignalBus.ammo_changed.emit(current_ammo, reserve_ammo)
