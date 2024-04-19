class_name login_control
extends Control


# Define variables for login scene
@onready var forgotPassword: Button = $mcLogin/LoginScreen/vb_loginButton/forgotPassword
@onready var signupLogin: Button = $mcLogin/LoginScreen/Options/createAccount
@onready var settingLogin: Button = $mcLogin/LoginScreen/Options/Settings
@onready var exitLogin: Button = $mcLogin/LoginScreen/Options/Exit
@onready var forgotPassword_page: PackedScene = preload("res://forgot_password.tscn")
@onready var signup_page: PackedScene = preload("res://signup.tscn")
@export var display_time : float = 1
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")

func _ready():
# Connect signals for login scene
	forgotPassword.button_down.connect(on_forgotPassword_pressed)
	signupLogin.button_down.connect(on_createAccount_pressed)
	settingLogin.button_down.connect(on_setting_pressed)

func on_forgotPassword_pressed() -> void:
	get_tree().change_scene_to_packed(forgotPassword_page)

# Function to switch to login scene
func on_createAccount_pressed() -> void:
	get_tree().change_scene_to_packed(signup_page)

# Placeholder function for setting button action
func on_setting_pressed() -> void:
	pass
