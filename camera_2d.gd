extends Camera2D


@onready var pause =  $menu
@onready var leave = $validation
@onready var validation = $Control/settingsMenu/TabContainer/Profile/TextureRect
@onready var settings = $Control/settingsMenu
# Called when the node enters the scene tree for the first time.
@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"


func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	pause.hide()
	leave.hide()
	validation.hide()
	settings.hide()
	pass # Replace with function body.


func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	Firebase.Auth.save_auth(auth_info)

func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var username = $Control/settingsMenu/TabContainer/Profile/vb_username/Username/TextEdit/usernameInput.text 
		var emailAdress = $Control/settingsMenu/TabContainer/Profile/vb_email/Email/TextEdit/emailInput.text
		#var document = firestore_collection.get_doc("VivaVocabulario")
		#collection.update(userinfo.emailAdress, 
		var data: Dictionary = {
		'username': username, 
	}
		Firebase.Auth.change_user_email(emailAdress)
		@warning_ignore("unused_variable")
		var task: FirestoreTask = collection.update(auth.localid,data)
		hide()



func _on_map_pressed():
	leave.show()
	pass # Replace with function body.


func _on_settings_pressed():
	settings.show()
	pass # Replace with function body.


func _on_resume_pressed():
	pause.hide()
	pass # Replace with function body.


func _on_option_pressed():
	pause.show()
	pass # Replace with function body.


func _on_yes_pressed():
	get_tree().change_scene_to_file("res://login.tscn")
	pass # Replace with function body.


func _on_no_pressed():
	leave.hide()
	pass # Replace with function body.


func _on_save_changes_pressed():
	validation.show()
	pass # Replace with function body.


func _on_cancel_pressed():
	settings.hide()
	pass # Replace with function body.


func _on_save_pressed():
	save_data()
	pass # Replace with function body.


func _on_no_save_pressed():
	validation.hide()
	pass # Replace with function body.


func _on_delete_pressed():
	pass # Replace with function body.
