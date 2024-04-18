class_name signup_control
extends Control

@onready var Login = $mcSignup/SignupScreen/Options/Login as Button
@onready var Settings = $mcSignup/SignupScreen/Options/Settings as Button
@onready var Exit = $mcSignup/SignupScreen/Options/Exit as Button
@onready var login_page = preload("res://login.tscn") as PackedScene

func _ready():
	Login.button_down.connect(on_start_pressed)
	Settings.button_down.connect(on_setting_pressed)
	Exit.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(login_page)

func on_setting_pressed() -> void:
	pass

func on_exit_pressed() -> void:
	get_tree().quit()
