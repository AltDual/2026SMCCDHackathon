extends Control

const GAME_SCENE := "res://scenes/game.tscn"

@onready var start_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
    start_button.grab_focus()

func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_file(GAME_SCENE)

func _on_quit_button_pressed() -> void:
    get_tree().quit()
