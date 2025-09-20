extends CharacterBody2D

var speed := 300
var jump_force := -200
var gravity := 500
var facing_right := true
var health := 100
var movement_locked := false
var is_jumping := false

@onready var anim := $AnimatedSprite2D
@onready var phitbox := $PunchHitbox

func _ready() -> void:
	add_to_group("player")
	$AnimatedSprite2D.play("idle")
	phitbox.monitoring = false

func _physics_process(delta):
	var direction := 0
	
	# Add gravity every frame
	velocity.y += gravity * delta
	
	# Movement
	if Input.is_action_pressed("move_left") and !movement_locked:
		direction = -1
		if facing_right:
			anim.flip_h = true
			facing_right = false
		if !is_jumping:
			anim.play("run")
			
	if Input.is_action_pressed("move_right") and !movement_locked:
		direction = 1
		if !facing_right:
			anim.flip_h = false
			facing_right = true
		if !is_jumping:
			anim.play("run")
	
	velocity.x = direction * speed
	
	move_and_slide()
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		anim.play("jump")
		is_jumping = true
	
	# Punch
	if Input.is_action_just_pressed("punch"):
		punch()
	
	if health <= 0:
		die()

func punch():
		anim.play("punch")
		movement_locked = true
		phitbox.monitoring = true

func die():
	print("Player died")
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	anim.play("idle")
	movement_locked = false
	is_jumping = false
	phitbox.monitoring = false

func _on_punch_hitbox_area_entered(_area: Area2D) -> void:
	print("Hit!")
