extends RigidBody2D

var throw_force := 300
var thrown := false
var thrown_direction := ""
var explosion_force := 400

@onready var animation := $AnimatedSprite2D
@onready var sound := $AudioStreamPlayer2D
@onready var damage_area: CollisionShape2D = $Damage/DamageArea
@export var damage_dealt := 60



func _process(_delta: float) -> void:
	if thrown:
		apply_central_impulse(Vector2.UP * throw_force)
		if thrown_direction == "right":
			apply_central_impulse(Vector2.RIGHT * throw_force)	
		if thrown_direction == "left":
			apply_central_impulse(Vector2.LEFT * throw_force)	
		thrown = false

func _on_explode_timer_timeout() -> void:
	damage_area.disabled = false
	animation.play()
	sound.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	animation.stop()
	queue_free()


func _on_damage_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage_dealt)
		
		
