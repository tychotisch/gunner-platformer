extends Node2D

@onready var menu: Control = $menu
@onready var player: CharacterBody2D = $Player


func _process(_delta: float) -> void:
	show_start_menu()
	show_restart_button()

func show_start_menu():
	if menu.visible:
		player.game_running = false
	if not menu.visible:
		player.game_running = true

func show_restart_button():
	if player.player_health <= 0:
		menu.visible = true
		menu.start_button.visible = false
		menu.restart_button.visible = true
