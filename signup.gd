class_name signup_control
extends Control

# Define variables for signup scene
@onready var loginSignup: Button = $mcSignup/SignupScreen/Options/Login 
@onready var settingSignup: Button = $mcSignup/SignupScreen/Options/Settings
@onready var exitSignup: Button = $mcSignup/SignupScreen/Options/Exit
@onready var login_page: PackedScene = preload("res://login.tscn")

func _ready():
	# Connect signals for signup scene
	loginSignup.button_down.connect(on_login_pressed)
	settingSignup.button_down.connect(on_setting_pressed)
	exitSignup.button_down.connect(on_exit_pressed)


# Function to switch to login scene
func on_login_pressed() -> void:
	get_tree().change_scene_to_packed(login_page)

# Placeholder function for setting button action
func on_setting_pressed() -> void:
	pass

# Function to quit the application
func on_exit_pressed() -> void:
	get_tree().quit()
