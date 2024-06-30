extends Control



@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"

#@onready var Yes: Button = $validation/Yes
@onready var No: Button =  $validation/No

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	
	$AnimationPlayer.play("pop_up")
	pass # Replace with function body.
	No.button_down.connect(on_no_pressed)
#	Yes.button_down.connect(on_yes_pressed)

func on_no_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed

func on_yes_pressed() -> void:
	save_data()

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	
	
	
	##GameManager.userInfo = userinfo
	Firebase.Auth.save_auth(auth_info)


func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var username = $TabContainer/Profile/vb_username/Username/TextEdit/usernameInput.text 
		var emailAdress = $TabContainer/Profile/vb_email/Email/TextEdit/emailInput.text
		#var document = firestore_collection.get_doc("VivaVocabulario")
		#collection.update(userinfo.emailAdress, 
		var data: Dictionary = {
		'username': username, 
	}
		Firebase.Auth.change_user_email(emailAdress)
		@warning_ignore("unused_variable")
		var task: FirestoreTask = collection.update(auth.localid,data)
		hide()




