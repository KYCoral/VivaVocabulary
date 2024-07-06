class_name signup_control
extends Control

# Define variables for signup scene
@onready var agree_checkbox: CheckBox = $mcSignup/SignupScreen/signup/vb_confirmPassword/ConfirmPassword/vb_signupButton/cbTerms
@onready var loginSignup: Button = $mcSignup/SignupScreen/signup/Options/Login
@onready var exitSignup: Button = $mcSignup/SignupScreen/signup/Options/Exit
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")
var exit_instance: Node


@onready var terms : Button = $mcSignup/SignupScreen/signup/vb_confirmPassword/ConfirmPassword/vb_signupButton/cbTerms/termsServices
@onready var terms_page: PackedScene = preload("res://terms_services.tscn")
var terms_instance : Node
@onready var login_page: PackedScene = preload("res://login.tscn")
var login_instance : Node
@onready var signup : Button = $mcSignup/SignupScreen/signup/vb_confirmPassword/ConfirmPassword/vb_signupButton/signUp
@onready var signup_complete : CanvasLayer = $CanvasLayer
@onready var signUp_loading: PackedScene = preload("res://loadingLogin.tscn")
var loading_instance: Node

var userinfo = null
signal signup_succeeded(user_info)  

func _ready():
	# Connect signals for signup scene
	loginSignup.button_down.connect(on_login_pressed)
	exitSignup.button_down.connect(on_exit_pressed)
	signup.button_up.connect(_on_sign_up_button_up)
	terms.button_down.connect(_on_terms_services_pressed)

	Firebase.Auth.connect("signup_succeeded", self._on_FirebaseAuth_signup_succeeded)

	# Instantiate exit popup and add it to the scene tree
	exit_instance = exitPopup.instantiate()
	add_child(exit_instance)
	exit_instance.hide()
	
	signup_complete.hide()
	
	terms_instance = terms_page.instantiate()
	add_child(terms_instance)
	terms_instance.hide()
	
	loading_instance = signUp_loading.instantiate()
	add_child(loading_instance)
	loading_instance.hide()
	
	login_instance = login_page.instantiate()
	add_child(login_instance)
	login_instance.hide()


func _on_terms_services_pressed() -> void:
	terms_instance.show()
	pass # Replace with function body.

# Function to switch to login scene
func on_login_pressed() -> void:
	get_tree().change_scene_to_packed(login_page)
	#login_instance.show()
	#hide()
	#get_tree().change_scene_to_file("res://login.tscn")
	pass


# Function to quit the application
func on_exit_pressed() -> void:
	exit_instance.show()

func _on_sign_up_button_up() -> void:
	loading_instance.show()
	$errorMessage.hide()
	var email = $mcSignup/SignupScreen/signup/vb_account/Account/signup/Email/emailEnter.text
	var password = $mcSignup/SignupScreen/signup/vb_password/Password/password/passwordEnter.text
	var confirmPassword = $mcSignup/SignupScreen/signup/vb_confirmPassword/ConfirmPassword/confirmPassword/confirmPasswordEnter.text 
	var username = str(email).split("@")[-1]
	var valid = email.find("@")
	#var special_characters = [" ", "!", "#", "$", "%", "^", "&", "*", "(", ")", "+", "=", "{", "}", "|", "\\", ":", ";", "'", "\"", "<", ">", ",", "/", "?", "`", "~"]

	#for char in special_characters:
	#	if password.find(char) != -1:
	#		loading_instance.hide()
	#		$errorMessage.text = "Password must contrain atleast  1 special characters."
	#		$errorMessage.show()
	#		return  
	#	break

	 # Get confirm password
	if password != confirmPassword:
		loading_instance.hide()
		$errorMessage.text = "Password does not match"
		$errorMessage.show()
		return  # Exit the function if email is invalid
	elif email == "":
		loading_instance.hide()
		$errorMessage.text = "Please enter your email."
		$errorMessage.show()
		return  # Exit the function if email is invalid
	elif password == "":
		loading_instance.hide()
		$errorMessage.text = "Please enter your password."
		$errorMessage.show()
		return  # Exit the function if email is invalid
	elif confirmPassword == "":
		loading_instance.hide()
		$errorMessage.text = "Password must be confirmed."
		$errorMessage.show()
		return  # Exit the function if email is invalid
	elif not agree_checkbox.is_pressed():
		loading_instance.hide()
		$errorMessage.text = "User must agree to the Terms and Services"
		$errorMessage.show()
		return  # Exit the function if checkbox is not checked
	elif valid == -1:
		loading_instance.hide()
		$errorMessage.text = "Not a valid email address."
		$errorMessage.show()
	else:
		if username != "gmail.com":
			loading_instance.hide()
			$errorMessage.text = "Not valid email format: ex. Email@gmail.com"
			$errorMessage.show()
		else:
			Firebase.Auth.signup_with_email_and_password(email,password)

func _on_FirebaseAuth_signup_succeeded(auth_info):
	loading_instance.hide()
	$mcSignup/SignupScreen/signup/vb_account/Account/signup/Email/emailEnter.clear()
	$mcSignup/SignupScreen/signup/vb_password/Password/password/passwordEnter.clear()
	$mcSignup/SignupScreen/signup/vb_confirmPassword/ConfirmPassword/confirmPassword/confirmPasswordEnter.clear()
	$mcSignup/SignupScreen/signup/vb_confirmPassword/ConfirmPassword/vb_signupButton/cbTerms.button_pressed = false
	print("signup successful " + str(auth_info))
	userinfo = auth_info
	Firebase.Auth.send_account_verification_email()
	#$errorMessage.text = "Email was sent for email verification."
	
	# adding user to firestore
	var firestore_collection = Firebase.Firestore.collection("user_data")
	var document: FirestoreTask = await firestore_collection.get_doc("VivaVocabulario")
	print(document)
	var add_task = firestore_collection.add(userinfo.email, 
	{
		'username': "Username", 
		'level' : 0,
		'points' : 0,
		'score': 0
	})
	var addedUser = add_task
	print("User added successfully:", addedUser)
	signup_complete.show()



func _on_close_button_down():
	get_tree().change_scene_to_file("res://login.tscn")
	#signup_complete.hide()
	pass # Replace with function body.

