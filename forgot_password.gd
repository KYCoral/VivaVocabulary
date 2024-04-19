class_name forgotPassword_control
extends Control

@onready var goBack : Button = $MarginContainer/background/goBack
@onready var login_page: PackedScene = preload("res://login.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	goBack.button_down.connect(on_goBack_pressed)


func on_goBack_pressed() -> void:
	get_tree().change_scene_to_packed(login_page)
