class_name login_control extends Control

# Define variables for login scene
@onready var forgotPassword: Button = $mcLogin/LoginScreen/vb_loginButton/forgotPassword
@onready var signupLogin: Button = $mcLogin/LoginScreen/Options/createAccount
@onready var settingLogin: Button = $mcLogin/LoginScreen/Options/Settings
@onready var exitLogin: Button = $mcLogin/LoginScreen/Options/Exit
@onready var forgotPassword_page: PackedScene = preload("res://forgot_password.tscn")
@onready var signup_page: PackedScene = preload("res://signup.tscn")
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")
var exit_instance: Node
@onready var settings: PackedScene = preload("res://settings_startup.tscn")
##@onready var game_page: PackedScene = preload("res://game.tscn")
@onready var menu_page: PackedScene = preload("res://World_Scene-school.tscn")
var settings_instance: Node
var userinfo = null

func _ready():
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	Firebase.Auth.connect("login_failed", self._on_FirebaseAuth_login_failed)	
	# Connect signals for login scene
	forgotPassword.button_down.connect(on_forgotPassword_pressed)
	signupLogin.button_down.connect(on_createAccount_pressed)
	settingLogin.button_down.connect(on_setting_pressed)
	exitLogin.button_down.connect(on_exit_pressed)
# Instantiate exit popup and add it to the scene tree
	exit_instance = exitPopup.instantiate()
	add_child(exit_instance)
	exit_instance.hide()
# Instantiate settings popup and add it to the scene tree
	settings_instance = settings.instantiate()
	add_child(settings_instance)
	settings_instance.hide()

# Function to switch to forgot password scene
func on_forgotPassword_pressed() -> void:
	get_tree().change_scene_to_packed(forgotPassword_page)

# Function to switch to signup scene
func on_createAccount_pressed() -> void:
	get_tree().change_scene_to_packed(signup_page)

# Placeholder function for setting button action
func on_setting_pressed() -> void:
	settings_instance.show()


# Function to show exit popup
func on_exit_pressed() -> void:
	exit_instance.show()


func _on_login_button_up():
	var email = $mcLogin/LoginScreen/vb_account/Email/emailEnter.text
	var password = $mcLogin/LoginScreen/vb_password/password/passwordEnter.text
	Firebase.Auth.login_with_email_and_password(email,password)

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	##GameManager.userInfo = userinfo
	Firebase.Auth.save_auth(auth_info)
	get_tree().change_scene_to_packed(menu_page)

func _on_FirebaseAuth_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))
