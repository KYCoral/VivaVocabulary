class_name Player extends CharacterBody2D

#@onready var animation = $AnimationPlayer
@onready var sprite = $TopviewSprite
@onready var joystick = $Camera2D/joystick
const speed = 50
#const jump_velocity = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = 1


func _physics_process(_delta):
	var direction = joystick.posVector
	if direction: 
		velocity = direction * speed
	else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		velocity = Vector2()
	move_and_slide()

