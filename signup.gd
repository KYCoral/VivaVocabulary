class_name signup_control
extends Control

# Define variables for signup scene
@onready var agree_checkbox: CheckBox = $mcSignup/SignupScreen/vb_signupButton/cbTerms
@onready var loginSignup: Button = $mcSignup/SignupScreen/Options/Login 
@onready var settingSignup: Button = $mcSignup/SignupScreen/Options/Settings
@onready var exitSignup: Button = $mcSignup/SignupScreen/Options/Exit
@onready var login_page: PackedScene = preload("res://login.tscn")
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")
var exit_instance: Node
@onready var settings: PackedScene = preload("res://settings_startup.tscn")
var settings_instance: Node
var userinfo = null
signal signup_succeeded(user_info)  

func _ready():
	# Connect signals for signup scene
	loginSignup.button_down.connect(on_login_pressed)
	settingSignup.button_down.connect(on_setting_pressed)
	exitSignup.button_down.connect(on_exit_pressed)
	##Firebase.Auth.connect("signup_succeeded", self, "_on_FirebaseAuth_signup_succeeded")
	Firebase.Auth.connect("signup_succeeded", self._on_FirebaseAuth_signup_succeeded)

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
	#get_tree().change_scene_to_packed(login_page)
	hide()


# Placeholder function for setting button action
func on_setting_pressed() -> void:
	settings_instance.show()

# Function to quit the application
func on_exit_pressed() -> void:
	exit_instance.show()

func _on_sign_up_button_up():
	$errorMessage.hide()
	var email = $mcSignup/SignupScreen/vb_account/Email/emailEnter.text
	var password = $mcSignup/SignupScreen/vb_password/password/passwordEnter.text
	var confirmPassword =$mcSignup/SignupScreen/vb_confirmPassword/confirmPassword/confirmPasswordEnter.text 
	 # Get confirm password
	if password != confirmPassword:
		$errorMessage.text = "Password does not match"
		$errorMessage.show()
	elif not is_valid_email(email):
		$errorMessage.text = "Invalid email format"
		$errorMessage.show()
		return  # Exit the function if email is invalid
	elif not agree_checkbox.is_pressed():
		$errorMessage.text = "User must agree to the Terms and Services"
		$errorMessage.show()
		# Display error message (e.g., "Please agree to terms")
		return  # Exit the function if checkbox is not checked
	else:
		Firebase.Auth.signup_with_email_and_password(email,password)

func _on_FirebaseAuth_signup_succeeded(auth_info):
	#$TextureRect/AnimationPlayer.play("registered")
	print("signup successful " + str(auth_info))
	userinfo = auth_info
	Firebase.Auth.send_account_verification_email()
	$errorMessage.text = "Email was sent for email verification."
	
	# adding user to firestore
	var firestore_collection = Firebase.Firestore.collection("user_data")
	var document = firestore_collection.get_doc("VivaVocabulario")
	print(document)
	var add_task = firestore_collection.add(userinfo.email, 
	{
		'Username': "Username", 
		'Level' : 0,
		'Points' : 0,
		'score': 0
	})
	var addedUser = add_task
	print("User added successfully:", addedUser)


func _on_click(event):
	# Stop the animation if it's playing
	if has_node("$TextureRect/AnimationPlayer"):
		var animation_player = $TextureRect/AnimationPlayer
		if animation_player.is_playing():
			animation_player.stop()


func is_valid_email(email: String) -> bool:
	# Improved regular expression for email validation
	var pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
	return email.match(pattern) != null


