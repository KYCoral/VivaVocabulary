extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Area2D".body_entered.connect(_play_animation)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _play_animation(body):
	$level2.play("level2")
	#$"../Area2D".body_entered.disconnect(_play_animation)
