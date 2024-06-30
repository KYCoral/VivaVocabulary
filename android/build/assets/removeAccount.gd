extends Control

@onready var no : Button = $validation/No

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null

#@export var email : String = "kazumirimurutempest@gmail.com"
#@export var password : String = "password123"
#var userinfo = null

# Called when the node enters the scene tree for the first time.

func _ready():
	Firebase.Auth.login_with_email_and_password(email,password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	no.button_down.connect(no_pressed)
	pass # Replace with function body.

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	Firebase.Auth.save_auth(auth_info)

func no_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed

func _on_yes_button_up():
	Firebase.Auth.delete_user_account()
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('user_data')
	firestore_collection.delete(userinfo.email)
	print("Document deleted successfully")
	get_tree().change_scene_to_file("res://login.tscn")
