extends Control

@onready var no : Button = $validation/No

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("pop_up")
	no.button_down.connect(no_pressed)
	pass # Replace with function body.



func no_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed

func _on_yes_button_up():
	Firebase.Auth.delete_user_account()
