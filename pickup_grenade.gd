extends Area2D

var grenade_pick_up := 5

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_ammo"):
		body.take_ammo(grenade_pick_up)
	queue_free()
