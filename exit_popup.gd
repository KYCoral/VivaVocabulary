class_name exit_control
extends Control


@onready var exit: Button = $validation/Yes
@onready var notExit: Button = $validation/No 
# Called when the node enters the scene tree for the first time.
func _ready():
	#$validation/AnimationPlayer.play("pop_up")
	exit.button_down.connect(exit_pressed)
	notExit.button_down.connect(notExit_pressed)



func exit_pressed() -> void:
	get_tree().quit()

func notExit_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed
