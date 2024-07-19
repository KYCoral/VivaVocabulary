extends Node2D

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
@onready var entranceAny = $Marker2D
@onready var players = $worldPlayer
# Called when the node enters the scene tree for the first time.


func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	$npc/AnimationPlayer.play("interact")
	$worldPlayer/Control.visible = false
	players.global_position = entranceAny.global_position
	pass # Replace with function body.



func _on_lessons_pressed():
	get_tree().change_scene_to_file("res://lesson_classroom.tscn")
	pass # Replace with function body.


func _on_FirebaseAuth_login_succeeded(auth_info):
	$worldPlayer/Control.visible = false
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
			if document.doc_fields.score:
				if document.doc_fields.score > 0:
					$worldPlayer/Camera2D/profile/LabelPoints.text = "Novice"
				elif document.doc_fields.score >= 50:
					$worldPlayer/Camera2D/profile/LabelPoints.text = "Intermmediate"
				elif document.doc_fields.score >= 100: 
					$worldPlayer/Camera2D/profile/LabelPoints.score = "Expert"
				else:
					$worldPlayer/Camera2D/profile/LabelPoints.score = "Master"
				$worldPlayer/Camera2D/profile/ProgressBar.value = document.doc_fields.score
			print(finished_task.error)


func _on_scene_trigger_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://School_grounds.tscn")
	pass # Replace with function body.


func _on_interact_pressed():
	get_tree().change_scene_to_file("res://scenes/chat.tscn")
	pass # Replace with function body.



func _on_interact_detection_body_entered(body):
	$npc/interact.visible = true
	pass # Replace with function body.


func _on_interact_detection_body_exited(body):
	$npc/interact.visible = false
	pass # Replace with function body.


func _on_exit_body_entered(body):
	$exit/CollisionShape2D/exitsu.visible = true
	pass # Replace with function body.


func _on_exit_body_exited(body):
	$exit/CollisionShape2D/exitsu.visible = false
	pass # Replace with function body.


func _on_exitsu_pressed():
	get_tree().change_scene_to_file("res://School_grounds.tscn")
	pass # Replace with function body.
