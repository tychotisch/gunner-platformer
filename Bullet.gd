extends Area2D

@export var speed := 300.00
@export var damage_dealt := 10

@onready var sound := $AudioStreamPlayer2D

var direction := 1
var travelled_distance = 0.0


func _process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	var motion := transform.x * speed * delta
	position += motion

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage_dealt)
		queue_free()
