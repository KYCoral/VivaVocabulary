extends Control

#@onready var lessonView : RichTextLabel = $lessonView/RichTextLabel
# Called when the node enters the scene tree for the first time.

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "professor"
var document_data
var counter = 0
@onready var button_container: ScrollContainer = $ScrollContainer
@onready var goBack : Button = $goBack
@onready var school_page: PackedScene = preload("res://World_school.tscn")


#@onready var notes: RichTextLabel = $lessonView/RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	goBack.button_down.connect(_on_go_back_pressed)
	#pass # Replace with function body.


func _on_go_back_pressed():
	get_tree().change_scene_to_packed(school_page)
	#hide()
	pass # Replace with function body.	


func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success")
	var auth = Firebase.Auth.auth
	
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		
		var task: FirestoreTask = collection.get_doc("lessons")
		var finished_task: FirestoreTask = await task.task_finished
		if finished_task.error != Firebase.Error.OK:
			print("Error: ", finished_task.error)
			return
			
		var document = finished_task.document
		if document:
			for doc in document:
				create_button(doc.doc_fields)
			
			
		#var document = finished_task.document
		#if document && document.doc_fields:
		#	if document.doc_fields.notes:
		#		$lessonView/RichTextLabel.text = document.doc_fields.notes
		#	print(finished_task.error)

func create_button(doc_fields: String) -> void:
	var button = Button.new()
	button.name = "lesons"
	button.text = doc_fields
	button.button_pressed.connect(self._on_Button_pressed[doc_fields])
	button_container.add_child(button)  # Add the button to the ScrollContainer


func _on_lesons_pressed(doc_fields: String)-> void:
	counter += 1
	print("Button pressed for document: ", doc_fields, " Counter: ", counter)
	pass # Replace with function body.

