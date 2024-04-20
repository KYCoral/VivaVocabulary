class_name settingsMenu
extends Control

@onready var Cancel: Button = $cancel


# Called when the node enters the scene tree for the first time.
func _ready():
	Cancel.button_down.connect(on_cancel_pressed)



func on_cancel_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed
