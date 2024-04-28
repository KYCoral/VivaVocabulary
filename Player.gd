extends CharacterBody2D

@onready var joystick = $"../Camera2D/joystick"
var speed = 300
@export var GRAVITY: int = 900

func _physics_process(delta):
	var direction = joystick.posVector.normalized()

	if direction.length() > 0.01:
		velocity = direction * speed
	else:
		velocity.x = 0

	velocity.y += GRAVITY * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		# Get the global position of the collision
		var collision_global_pos = to_global(collision.position)
		# Convert the global position to the local coordinates of the TileMap
		var collision_local_pos = get_node("../TileMap").to_local(collision_global_pos)
		# Get the cell position (grid position) of the TileMap corresponding to the
