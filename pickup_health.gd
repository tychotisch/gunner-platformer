extends Area2D


var health_pick_up := 30


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_health"):
		body.take_health(health_pick_up)

	queue_free()
