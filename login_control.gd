class_name login_control
extends Control

@onready var Signup = $mcLogin/LoginScreen/Options/SignUp as Button
@onready var Settings = $mcLogin/LoginScreen/Options/Settings as Button
@onready var Exit = $mcLogin/LoginScreen/Options/Exit as Button
@onready var signup_page = preload("res://signup.tscn") as PackedScene

func _ready():
	Signup.button_down.connect(on_start_pressed)
	Settings.button_down.connect(on_setting_pressed)
	Exit.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(signup_page)

func on_setting_pressed() -> void:
	pass


func on_exit_pressed() -> void:
	get_tree().quit()
