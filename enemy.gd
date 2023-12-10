extends CharacterBody2D


const SPEED = 40.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var Bullet = preload("res://bullet.tscn")
var Grenade = preload("res://grenade.tscn")
var can_jump := false
var grenades := 3
var direction := 0
var enemy_health := 70
var push_force := 60
var last_shot = 0
var shoot_cooldown = 75

@onready var animation := $AnimatedSprite2D
@onready var enemy: CharacterBody2D = $"."
@onready var vision_left := $VisionLeft
@onready var vision_right := $VisionRight
@onready var edge_left: RayCast2D = $EdgeLeft
@onready var edge_right: RayCast2D = $EdgeRight
@onready var wall_left: RayCast2D = $EdgeLeft/WallLeft
@onready var wall_right: RayCast2D = $EdgeRight/WallRight
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health: Label = $Health
@onready var timer: Timer = $Timer



func _physics_process(delta: float) -> void:
	randomize()
	if enemy_health > 0:
		set_animation()
		enemy_edge_detection()
		enemy_player_detection()
		if not is_on_floor():
			velocity.y += gravity * delta
		# Handle Jump.
		if is_on_floor() and can_jump == true:
			velocity.y = JUMP_VELOCITY
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
	if enemy_health <= 0:
		collision.disabled = true

func take_damage(amount):
	enemy_health -= amount
	health.visible = true
	timer.start()
	health.set_text(str(-amount))
	if enemy_health <= 0:
		direction = 0
		animation.play("death")

func shoot():
	var bullet = Bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.sound.play()
	bullet.position.x = enemy.position.x + 12 * direction
	bullet.position.y = enemy.position.y
	bullet.speed = bullet.speed * direction

func _throw_grenade():
	grenades -= 1
	if grenades > 0:
		var grenade = Grenade.instantiate()
		get_tree().root.add_child(grenade)
		if direction -1:
			grenade.thrown_direction = "left"
			grenade.throw_force = 400
		if direction> 1:
			grenade.thrown_direction = "right"
			grenade.throw_force = 400
		#grenade.global_transform = bullet_spawn_pos.global_transform
		grenade.position. x = enemy.position.x + 12 * direction
		grenade.position.y = enemy.position.y
		grenade.thrown = true

func enemy_player_detection():
	var time = Time.get_ticks_msec()
	if vision_left.is_colliding() and direction == -1:
		if time - last_shot > shoot_cooldown:
			last_shot = time
			shoot()
	if vision_right.is_colliding() and direction == 1:
		if time - last_shot > shoot_cooldown:
			last_shot = time
			shoot()

func enemy_edge_detection():
	if not edge_left.is_colliding() or wall_left.is_colliding():
		direction = 1
	if not edge_right.is_colliding() or wall_right.is_colliding():
		direction = -1

func set_animation():
	if velocity.x < -1:
		animation.flip_h = true
		animation.play("run")
	if velocity.x > 1:
		animation.flip_h = false
		animation.play("run")
	if velocity.x == 0:
		animation.play("idle")
	if velocity.y < 0 :
		animation.play("jump")


func _on_timer_timeout() -> void:
	health.visible = false
