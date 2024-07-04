class_name login_control extends Control


# Define variables for login scene
@onready var forgotPassword: Button = $mcLogin/LoginScreen/vb_loginButton/forgotPassword
var forgotPassword_instance : Node
@onready var signupLogin: Button = $mcLogin/LoginScreen/Options/createAccount
var signUp_instance: Node
@onready var exitLogin: Button = $mcLogin/LoginScreen/Options/Exit
@onready var forgotPassword_page: PackedScene = preload("res://forgot_password.tscn")
@onready var signup_page: PackedScene = preload("res://signup.tscn")
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")
var exit_instance: Node
@onready var login : Button = $mcLogin/LoginScreen/Options/Login

#@onready var game_page: PackedScene = preload("res://game.tscn")
#@onready var menu_page: PackedScene = preload("res://mainMenu.tscn")
var userinfo = null

func _ready():
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	Firebase.Auth.connect("login_failed", self._on_FirebaseAuth_login_failed)	
	# Connect signals for login scene
	signUp_instance = signup_page.instantiate()
	add_child(signUp_instance)
	signUp_instance.hide()
	
	forgotPassword_instance = forgotPassword_page.instantiate()
	add_child(forgotPassword_instance)
	forgotPassword_instance.hide()
	
# Instantiate exit popup and add it to the scene tree
	exit_instance = exitPopup.instantiate()
	add_child(exit_instance)
	exit_instance.hide()



func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	Firebase.Auth.save_auth(auth_info)
	get_tree().change_scene_to_file("res://mainMenu.tscn")


func _on_FirebaseAuth_login_failed(error_code, message):
	$errorMessage.text = "Invalid Email. Please try again."
	$errorMessage.show()
	print("error code: " + str(error_code))
	print("message: " + str(message))




func _on_create_account_pressed():
	#get_tree().change_scene_to_packed(signup_page)
	signUp_instance.show()
	#get_tree().change_scene_to_file("res://signup.tscn")
	pass # Replace with function body.


func _on_forgot_password_pressed():
	#get_tree().change_scene_to_packed(forgotPassword_page)
	#get_tree().change_scene_to_file("res://forgot_password.tscn")
	forgotPassword_instance.show()

	pass # Replace with function body.


func _on_login_pressed():
	var email = $mcLogin/LoginScreen/vb_account/Account/Email/emailEnter.text
	var password = $mcLogin/LoginScreen/vb_password/Password/password/passwordEnter.text
	$mcLogin/LoginScreen/vb_account/Account/Email/emailEnter.clear()
	$mcLogin/LoginScreen/vb_password/Password/password/passwordEnter.clear()
	Global.set_login_data(email,password)
	Firebase.Auth.login_with_email_and_password(email,password)
	pass # Replace with function body.


func _on_exit_pressed():
	exit_instance.show()
	pass # Replace with function body.
