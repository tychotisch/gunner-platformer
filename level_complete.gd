extends Area2D

const LEVEL_PATH := "res://main_"

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player"):
		var current_level_path = get_tree().current_scene.scene_file_path
		var nex_level_number = current_level_path.to_int() + 1
		var next_level_path = LEVEL_PATH + str(nex_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
