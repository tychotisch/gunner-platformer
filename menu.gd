extends Control

@onready var menu: Control = $"."
@onready var restart_button: Button = $RestartButton
@onready var start_button: Button = $StartButton


func _on_start_button_pressed() -> void:
	menu.visible = false




func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	menu.visible = false
