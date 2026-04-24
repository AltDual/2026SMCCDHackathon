extends Control


func _ready() -> void:
	# Unpause in case player died during upgrade screen
	get_tree().paused = false
	$VBoxContainer/Restart.pressed.connect(_on_restart)
	$VBoxContainer/MainMenu.pressed.connect(_on_main_menu)

func _on_restart() -> void:
	get_tree().change_scene_to_file("res://scenes/dungeon-test.tscn")

func _on_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
