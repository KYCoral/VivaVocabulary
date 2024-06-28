extends Control

# Import Firebase module (assuming it's a GDNative module or similar)
# Firebase.Auth and Firebase.Firestore or similar modules
# should be imported or initialized properly.

# Variables for Firebase
@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var COLLECTION_ID = "professor"
var CustomButton: PackedScene = preload("res://lessons.tscn")
# Godot UI elements
@onready var vbox_container = $ScrollContainer/VBoxContainer
@onready var school_page: PackedScene = preload("res://World_school.tscn")
@onready var lessonView : RichTextLabel = $lessonView/RichTextLabel

func _ready():
	# Authenticate with Firebase
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)

	# Connect goBack button press signal
	$goBack.button_down.connect(self._on_go_back_pressed)
	
# Function to handle Firebase login success
func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Firebase login success!")
	
	var auth = Firebase.Auth.auth
	
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc("lessons")
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			for field_name in document.doc_fields.keys():
				var button = CustomButton.instantiate()
				button.text = str(field_name)  # Initial text, assuming you want to start with 0
				button.pressed.connect(Callable(self, "_on_button_pressed").bind(field_name))
				vbox_container.add_child(button)
		else:
			print("Document or document fields are null.")

# Function to handle button press and update text
func _on_button_pressed(field_name):

		print("Button pressed for field:", field_name)
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc("lessons")
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields[field_name]:
				$lessonView/RichTextLabel.text =  str(document.doc_fields[field_name])
			print(finished_task.error)


func _on_go_back_pressed():
	# Navigate back to the school page
	get_tree().change_scene_to_packed(school_page)
