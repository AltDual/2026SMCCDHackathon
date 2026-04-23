extends CharacterBody2D

const SPEED = 150.0

#var last_direction: Vector2 = Vector2.RIGHT
#var movement_locked: bool = false
#var require_input_release: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun = $Gun
@onready var reload_bar: ProgressBar = $ReloadBar
var reload_tween: Tween

var max_health: int = 100
var current_health: int = 100
var current_xp: int = 0

# --- WEAPON INVENTORY SYSTEM ---
@export var starting_weapons: Array[WeaponResource] = [null, null]
var weapon_inventory: Array[WeaponResource] = [null, null]
var active_weapon_index: int = 0

func _ready():
	SignalBus.health_changed.emit(current_health, max_health)
	SignalBus.xp_changed.emit(current_xp)
	
	# --- NEW: Connect to the gun's reload signals ---
	gun.reload_started.connect(_on_gun_reload_started)
	gun.reload_finished.connect(_on_gun_reload_finished)
	
	# --- CHANGED: Safely duplicate the actual resources, not just the array ---
	for i in range(starting_weapons.size()):
		if starting_weapons[i] != null:
			weapon_inventory[i] = starting_weapons[i].duplicate()
			
	if weapon_inventory[0] != null:
		equip_weapon(0)
		
	SignalBus.hotbar_updated.emit.call_deferred(weapon_inventory, active_weapon_index)

func _physics_process(_delta: float) -> void:
	var _move_input := Input.get_vector("left", "right", "up", "down")

	#if require_input_release:
		#if move_input == Vector2.ZERO:
			#require_input_release = false
		#else:
			#velocity = Vector2.ZERO
			#move_and_slide()
			#return

	#if movement_locked:
		#velocity = Vector2.ZERO
		#move_and_slide()
		#return

	process_movement()

	var aim_dir = get_aim_direction()
	$Gun.position.x = sign(aim_dir.x) * 3.5

	process_animation(aim_dir)
	move_and_slide()
	process_weapon_switching()

# --- NEW METHODS ---
func process_weapon_switching() -> void:
	if Input.is_action_just_pressed("equip_slot_1") and active_weapon_index != 0:
		equip_weapon(0) # 0 is the first array slot (AK67)
	elif Input.is_action_just_pressed("equip_slot_2") and active_weapon_index != 1:
		equip_weapon(1) # 1 is the second array slot (Pistol)

func equip_weapon(index: int) -> void:
	if weapon_inventory[index] != null:
		active_weapon_index = index
		gun.equip(weapon_inventory[index])
		SignalBus.hotbar_updated.emit(weapon_inventory, active_weapon_index)

func get_aim_direction() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	return (mouse_pos - global_position).normalized()

func process_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		#last_direction = direction
	else:
		velocity = Vector2.ZERO

func process_animation(aim_dir: Vector2) -> void:
	if velocity != Vector2.ZERO:
		play_animation("run", aim_dir)
	else:
		play_animation("idle", aim_dir)

func play_animation(prefix: String, dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play(prefix + "_right")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")
	else:
		animated_sprite_2d.play(prefix + "_down")

#Damage and XP
func take_damage(amount: int):
	current_health -= amount
	# Emit the signal to tell the rest of the game the health changed
	SignalBus.health_changed.emit(current_health, max_health)

func gain_xp(amount: int):
	current_xp += amount
	SignalBus.xp_changed.emit(current_xp)

func _on_gun_reload_started(duration: float) -> void:
	reload_bar.visible = true
	reload_bar.max_value = duration
	reload_bar.value = 0.0

	# Kill the old animation if one is somehow still running
	if reload_tween:
		reload_tween.kill()

	# Create a smooth animation from 0 to the reload time
	reload_tween = create_tween()
	reload_tween.tween_property(reload_bar, "value", duration, duration)

func _on_gun_reload_finished() -> void:
	reload_bar.visible = false
	if reload_tween:
		reload_tween.kill()
