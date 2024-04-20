class_name signup_control
extends Control

# Define variables for signup scene
@onready var loginSignup: Button = $mcSignup/SignupScreen/Options/Login 
@onready var settingSignup: Button = $mcSignup/SignupScreen/Options/Settings
@onready var exitSignup: Button = $mcSignup/SignupScreen/Options/Exit
@onready var login_page: PackedScene = preload("res://login.tscn")
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")
var exit_instance: Node
@onready var settings: PackedScene = preload("res://settings_startup.tscn")
var settings_instance: Node

func _ready():
	# Connect signals for signup scene
	loginSignup.button_down.connect(on_login_pressed)
	settingSignup.button_down.connect(on_setting_pressed)
	exitSignup.button_down.connect(on_exit_pressed)
# Instantiate exit popup and add it to the scene tree
	exit_instance = exitPopup.instantiate()
	add_child(exit_instance)
	exit_instance.hide()
# Instantiate settings popup and add it to the scene tree
	settings_instance = settings.instantiate()
	add_child(settings_instance)
	settings_instance.hide()



# Function to switch to login scene
func on_login_pressed() -> void:
	get_tree().change_scene_to_packed(login_page)


# Placeholder function for setting button action
func on_setting_pressed() -> void:
	settings_instance.show()

# Function to quit the application
func on_exit_pressed() -> void:
	exit_instance.show()

