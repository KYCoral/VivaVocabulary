extends CharacterBody2D
class_name Player 
#@onready var animation = $AnimationPlayer
@onready var sprite = $TopviewSprite
@onready var joystick = $Camera2D/joystick
const speed = 300
@onready var label = $id
@onready var animation: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta):
	var direction = joystick.posVector
	if direction: 
		velocity = direction * speed
		animation.play("WALK")
		direction = direction.normalized()
	else:
		animation.play("IDLE")
	velocity = Vector2()
	move_and_slide()	


func set_player_name(player_name: String):
	label.text = player_name 

func set_color(color: Color):
	sprite.modulate = color
