class_name settingsMenu
extends Control



@export var email : String = "kazumirimurutempest@gmail.com"
@export var password : String = "password123"
var userinfo = null
var COLLECTION_ID = "user_data"

@onready var Cancel: Button = $TabContainer/Profile/cancel
@onready var Save: Button = $TabContainer/Profile/saveChanges
@onready var DeleteAccount : Button = $TabContainer/General/VBoxContainer/delete
@onready var progressPopup: PackedScene = preload("res://saveProgress.tscn")
var saveProgress_instance : Node
@onready var accountDeletePopup: PackedScene = preload("res://removeAccount.tscn")
var accountDelete_instance : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	
	Cancel.button_down.connect(on_cancel_pressed)
	Save.button_down.connect(on_save_pressed)
	DeleteAccount.button_down.connect(_on_delete_button_up)
		# Instantiate exit popup and add it to the scene tree
	saveProgress_instance = progressPopup.instantiate()
	add_child(saveProgress_instance)
	saveProgress_instance.hide()
	
	accountDelete_instance = accountDeletePopup.instantiate()
	add_child(accountDelete_instance)
	accountDelete_instance.hide()


func on_cancel_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed

func on_save_pressed() -> void:
	saveProgress_instance.show()


func _on_delete_button_up():
	accountDelete_instance.show()



func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	##GameManager.userInfo = userinfo
	
	Firebase.Auth.save_auth(auth_info)
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc(email)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.username:
				$TabContainer/Profile/vb_username/Username/TextEdit/usernameInput.text = document.doc_fields.username
				$TabContainer/Profile/vb_email/Email/TextEdit/emailInput.text = email
			print(finished_task.error)




