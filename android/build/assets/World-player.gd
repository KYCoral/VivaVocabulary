extends CharacterBody2D

class_name Player 

#@onready var animation = $AnimationPlayer
@onready var sprite = $TopviewSprite
@onready var joystick = $Camera2D2/joystick
const speed = 300
@onready var label = $id
const RANDOM_SPAWN_RADIUS: float = 100
#const jump_velocity = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = 1

func _ready():
	global_position = Vector2(randf_range(-RANDOM_SPAWN_RADIUS, RANDOM_SPAWN_RADIUS), randf_range(-RANDOM_SPAWN_RADIUS, RANDOM_SPAWN_RADIUS))
	

func _physics_process(_delta):
	var direction = joystick.posVector
	var input_direction = direction
	if direction: 
		velocity = direction * speed
	else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		velocity = Vector2()
	
	move_and_slide()
	input_direction = input_direction.normalized()

func set_player_name(player_name: String):
	label.text = player_name
	
func set_color(color: Color):
	sprite.modulate = color
