class_name Player extends CharacterBody2D

#@onready var animation = $AnimationPlayer
@onready var sprite = $TopviewSprite
@onready var joystick = $Camera2D/joystick 
const speed = 300
#const jump_velocity = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = 1


func _physics_process(_delta):
	#if Input.is_action_just_pressed("left"):
	#	sprite.scale.x = abs(sprite.scale.x) * -1
	#if Input.is_action_just_pressed("right"):
	#	sprite.scale.x = abs(sprite.scale.x)
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = jump_velocity
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * speed
	#else:
	#	animation.play("idle")
	#	velocity.x = move_toward(velocity.x, 0, speed)

	#move_and_slide()
	
	var direction = joystick.posVector
	if direction: 
		velocity = direction * speed
	else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		velocity = Vector2()
	move_and_slide()
