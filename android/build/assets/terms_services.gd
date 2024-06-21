extends Node2D



@onready var goBack : Button = $goBack
@onready var signup_page: PackedScene = preload("res://signup.tscn")
var sign_instance : Node



# Called when the node enters the scene tree for the first time.
func _ready():
	goBack.button_down.connect(_on_go_back_pressed)
	sign_instance = signup_page.instantiate()
	add_child(sign_instance)
	sign_instance.hide()



func _on_go_back_pressed() -> void:
	sign_instance.show()
	pass # Replace with function body.
