extends Control

@onready var no : Button = $validation/No
@export var email := ""
@export var password := ""
var userinfo = null
# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email,password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	$AnimationPlayer.play("pop_up")
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
