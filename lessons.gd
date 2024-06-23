extends Button



#@onready var lessonView : RichTextLabel = $lessonView/RichTextLabel
# Called when the node enters the scene tree for the first time.
@export var email : String = "kazumirimurutempest@gmail.com"
@export var password : String = "password123"
var userinfo = null
var COLLECTION_ID = "professor"
var document_data
@onready var generate : Button = $"."
#@onready var notes: RichTextLabel = $lessonView/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	generate.button_up.connect(self._on_button_pressed)
	#pass # Replace with function body.

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	##GameManager.userInfo = userinfo
	
	Firebase.Auth.save_auth(auth_info)

func set_document_data(data):
	document_data = data

# Function to handle button press based on document data

func _on_button_pressed():
	load_data()
  # Handle button press logic here (e.g., navigate to document details)

func load_data():
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
