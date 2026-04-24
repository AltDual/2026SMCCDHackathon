extends CanvasLayer

@onready var panel = $Panel

func _ready() -> void:
	visible = false
	$Panel/MarginContainer/VBoxContainer/Resume.pressed.connect(_on_resume)
	$Panel/MarginContainer/VBoxContainer/MainMenu.pressed.connect(_on_main_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():  # Esc key
		if get_parent().upgrade_menu.visible:
			return
		if get_tree().paused and visible:
			_on_resume()
		elif not get_tree().paused:
			_pause()

func _pause() -> void:
	get_tree().paused = true
	visible = true

func _on_resume() -> void:
	get_tree().paused = false
	visible = false

func _on_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
