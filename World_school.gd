extends BaseScene

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
@onready var level2: Button = $level2/CollisionShape2D/level2
@onready var level2_page: PackedScene = preload("res://levelMedium.tscn")
@onready var interact : Button = $Untitled12720240510130540/interact
@onready var chat_page: PackedScene = preload("res://scenes/chat.tscn")

@onready var entranceAny = $Marker2D
@onready var players = $worldPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	level2.button_up.connect(_on_level_2_button_up)	
	interact.button_down.connect(_on_interact_button_up)
	

	players.global_position = entranceAny.global_position
	
	interact.hide()
	$level2/level2_play.stop()
	pass # Replace with function body.r.player:


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
			if document.doc_fields.score:
				if document.doc_fields.score > 0:
					$profile/LabelPoints.score = "Novice"
				elif document.doc_fields.score >= 50:
					$profile/LabelPoints.text = "Intermmediate"
				elif document.doc_fields.score >= 100:
					$profile/LabelPoints.score = "Expert"
				else:
					$profile/LabelPoints.score = "Master"
			print(finished_task.error)


func _on_level_2_button_up():
	get_tree().change_scene_to_packed(level2_page)
	#level2_instance.show()
	pass # Replace with function body.


func _on_level_2_body_entered(_body):
	$level2/level2_play.play("level2")
	level2.show()
	pass # Replace with function body.


func _on_level_2_body_exited(_body):
	$level2/level2_play.stop()
	level2.hide()
	pass # Replace with function body.


func _on_interact_button_up():
	get_tree().change_scene_to_packed(chat_page)
	pass # Replace with function body.


func _on_interact_detection_body_entered(_body):
	interact.show()
	$level2/level2_play.play("interact")
	pass # Replace with function body.


func _on_interact_detection_body_exited(_body):
	interact.hide()
	$level2/level2_play.stop()
	pass # Replace with function body.




func _on_scene_trigger_body_entered(body):
	get_tree().change_scene_to_file("res://School_grounds.tscn")
	pass # Replace with function body.
