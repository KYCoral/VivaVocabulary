extends CharacterBody2D
class_name Player 

#@onready var animation = $AnimationPlayer
@onready var sprite = $TopviewSprite
@onready var joystick = $Camera2D/joystick
const speed = 300
@onready var label: Label = $id
@onready var animation: AnimationPlayer = $AnimationPlayer

const RANDOM_SPAWN_RADIUS: float = 100

func _ready():
	global_position = Vector2(randf_range(-RANDOM_SPAWN_RADIUS, RANDOM_SPAWN_RADIUS), randf_range(-RANDOM_SPAWN_RADIUS, RANDOM_SPAWN_RADIUS))


func _physics_process(_delta):
	var direction = Vector2(joystick.posVector) 
	if direction: 
		velocity = direction * speed 
		animation.play("WALK")
		#velocity = velocity.normalized()
	else:
		animation.play("IDLE")
		velocity = Vector2()
	direction = direction.normalized()
	move_and_slide()


func set_player_name(player_name: String):
	label.text = player_name 

func set_color(color: Color):
	sprite.modulate = color
