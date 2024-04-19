extends Control

var show_time = 1
@onready var exit = $validation/Yes as Button
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(show_time)
	exit.button_down.connect(exit_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_Timer_timeout():
	queue_free()

func exit_pressed() -> void:
	get_tree().quit()
