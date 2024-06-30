extends Node2D

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	pass # Replace with function body.



func _on_lessons_pressed():
	get_tree().change_scene_to_file("res://lesson_classroom.tscn")
	pass # Replace with function body.

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	
	Firebase.Auth.save_auth(auth_info)
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc(email)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.username:
				$worldPlayer/Camera2D/profile/username.text = document.doc_fields.username
			if document.doc_fields.points:
				var points= str(document.doc_fields.points)
				$worldPlayer/Camera2D/profile/points.text = points
				if document.doc_fields.points >= 0:
					$profile/LabelPoints.text = "Novice"
				elif document.doc_fields.points >= 50:
					$profile/LabelPoints.text = "Intermmediate"
				elif document.doc_fields.points >= 100:
					$profile/LabelPoints.text = "Expert"
				else:
					$profile/LabelPoints.text = "Master"
			print(finished_task.error)
