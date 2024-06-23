extends Control

#@onready var lessonView : RichTextLabel = $lessonView/RichTextLabel
# Called when the node enters the scene tree for the first time.

@onready var goBack : Button = $goBack
@onready var school_page: PackedScene = preload("res://World_school.tscn")
@export var email : String = "kazumirimurutempest@gmail.com"
@export var password : String = "password123"
var userinfo = null
var COLLECTION_ID = "professor"
#@onready var notes: RichTextLabel = $lessonView/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	goBack.button_down.connect(_on_go_back_pressed)
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	#pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_go_back_pressed():
	get_tree().change_scene_to_packed(school_page)
	#hide()
	pass # Replace with function body.	


func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	
	
	
	##GameManager.userInfo = userinfo
	Firebase.Auth.save_auth(auth_info)
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		
		var task: FirestoreTask = collection.get_doc("lessons")
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.notes:
				$lessonView/RichTextLabel.text = document.doc_fields.notes
			print(finished_task.error)
			
			
func _on_get_documents_success(document):
	# Get existing button count (assuming buttons are children of a specific node)
	var button_parent = get_node("lesons")  # Replace with actual path
	var existing_button_count = button_parent.get_child_count()
	 # Get document count
	var document_count = document.size()
	# Check if we need to add more buttons
	if document_count > existing_button_count:
		# Loop through the difference and create buttons
		for i in range(existing_button_count, document_count):
			# Create a new button instance (replace with your button creation logic)
			var new_button = Button.new()
			# Configure the button (text, position, etc.)
			# Add the button as a child of the parent node
			button_parent.add_child(new_button)

# This function should be called after successfully retrieving documents from Firestore




