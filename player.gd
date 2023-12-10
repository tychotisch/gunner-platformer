extends CharacterBody2D

@onready var animation := $Animations
@onready var player: CharacterBody2D = $"."
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var menu: Control = $menu

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var Bullet = preload("res://bullet.tscn")
var Grenade = preload("res://grenade.tscn")
var projectile_direction = 1
var push_force := 80
var player_health := 100
var game_running := false
var grenades := 6


func _physics_process(delta: float) -> void:
	start_and_reset_game()
	if player_health > 0 and game_running:
		set_direction_and_animation()	
		
		if not is_on_floor():
			velocity.y += gravity * delta
			if velocity.y > 750:
				player_health = 0
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("shoot"):
			shoot()
		if Input.is_action_just_pressed("grenade"):
			throw_grenade()
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)	
		move_and_slide()
		pushing_rigids()
	
	if player_health <= 0:
		collision.disabled = true
		animation.play("death")

func set_direction_and_animation():
	if velocity.x < -1:
		animation.flip_h = true
		animation.play("run")
		projectile_direction = -1
	if velocity.x > 1:
		animation.flip_h = false
		animation.play("run")
		projectile_direction = 1
	if velocity.x == 0:
		animation.play("idle")
	if velocity.y < 0 :
		animation.play("jump")

func shoot() -> void:
	var bullet = Bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.sound.play()
	#bullet.global_transform = bullet_spawn_pos.global_transform
	bullet.position.x = player.position.x + 12 * projectile_direction
	bullet.position.y = player.position.y
	bullet.speed = bullet.speed * projectile_direction

func throw_grenade():
	grenades -= 1
	if grenades > 0:
		var grenade = Grenade.instantiate()
		get_tree().root.add_child(grenade)
		if velocity.x < -1:
			grenade.thrown_direction = "left"
		if velocity.x > 1:
			grenade.thrown_direction = "right"
		#grenade.global_transform = bullet_spawn_pos.global_transform
		grenade.position. x = player.position.x + 12 * projectile_direction
		grenade.position.y = player.position.y
		grenade.thrown = true

func pushing_rigids():
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func take_damage(amount):
	player_health -= amount

func take_health(amount):
	player_health += amount

func take_ammo(amount):
	grenades += amount

func _on_animations_animation_finished() -> void:
	animation.set_frame(7)
	game_running = false

func level_complete():
	pass

func start_and_reset_game():
	if not menu.visible:
		game_running = true
	if player_health <= 0:
		game_running = false
		menu.visible = true
		menu.start_button.visible = false
