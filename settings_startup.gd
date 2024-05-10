class_name settingsStartup
extends Control


@onready var Cancel: Button = $cancel


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("pop_up")
	Cancel.button_down.connect(on_cancel_pressed)



func on_cancel_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed
