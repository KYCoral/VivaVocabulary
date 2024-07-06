class_name School_grounds extends BaseScene

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
@onready var tile_map = $TileMap

@onready  var talk: Button = $NPC/interact
@onready var progressBar : ProgressBar = $worldPlayer/Camera2D/profile/ProgressBar
@onready var convo = $worldPlayer/convo
@onready var entranceAny = $Marker2D
@onready var players = $worldPlayer
@onready var camera = $worldPlayer/Camera2D
@onready var animationNPC : AnimationPlayer = $NPC/AnimationPlayer



func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	
	players.global_position = entranceAny.global_position
	animationNPC.play("nps")
	$worldPlayer/Control.visible = true



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
				progressBar.value = document.doc_fields.score
			print(finished_task.error)





func _on_roof_body_entered(body):
	if body is Player:
		tile_map. set_layer_enabled(4, false)
	pass # Replace with function body.



func _on_roof_body_exited(body):
	if body is Player:
		tile_map.set_layer_enabled(4, true)
	pass # Replace with function body.


func _on_scene_trigger_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://World_school.tscn")
	pass # Replace with function body.


func _on_interact_pressed():
	camera.visible = false
	convo.show()
	$NPC/AnimationPlayer.play("convo")
	pass # Replace with function body.


func _on_done_pressed():
	camera.visible = true
	convo.hide()
	$worldPlayer/convo/InputEdit/LineEdit.clear()
	$worldPlayer/convo/ResponseEdit.clear()
	pass # Replace with function body.



func _on_interact_detection_body_entered(body):
	talk.show()
	pass # Replace with function body.


func _on_interact_detection_body_exited(body):
	talk.hide()
	pass # Replace with function body.



func _on_scene_trigger_library_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://World_library.tscn")
	pass # Replace with function body.

