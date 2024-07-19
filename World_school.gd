extends BaseScene

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
@onready var level2: Button = $level2/CollisionShape2D/level2
@onready var level2_page: PackedScene = preload("res://levelMedium.tscn")
@onready var interact : Button = $NPC/interact
@onready var animationNPC : AnimationPlayer = $NPC/AnimationPlayer
@onready var entranceAny = $Marker2D
@onready var players = $worldPlayer
@onready var camera = $worldPlayer/Camera2D
@onready var convo = $worldPlayer/convo
# Called when the node enters the scene tree for the first time.

func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	animationNPC.play("nps")
	players.global_position = entranceAny.global_position
	$worldPlayer/Control.visible = false
	interact.hide()
	$level2/level2_play.stop()
	#$AudioStreamPlayer2D.play()
	pass # Replace with function body.r.player:


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
					$worldPlayer/howToPlay3.visible = true
					$worldPlayer/Camera2D/profile/LabelPoints.text = "Novice"
				elif document.doc_fields.score >= 50:
					$worldPlayer/Camera2D/profile/LabelPoints.text = "Intermmediate"
				elif document.doc_fields.score >= 100: 
					$worldPlayer/Camera2D/profile/LabelPoints.score = "Expert"
				else:
					$worldPlayer/Camera2D/profile/LabelPoints.score = "Master"
				$worldPlayer/Camera2D/profile/ProgressBar.value = document.doc_fields.score
			print(finished_task.error)


func _on_level_2_body_entered(_body):
	$level2/level2_play.play("level2")
	level2.show()
	pass # Replace with function body.


func _on_level_2_body_exited(_body):
	$level2/level2_play.stop()
	level2.hide()
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
	if body is Player:
		get_tree().change_scene_to_file("res://School_grounds.tscn")
	pass # Replace with function body.





func _on_level_2_pressed():
	get_tree().change_scene_to_packed(level2_page)
	pass # Replace with function body.


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://levelEasy.tscn")
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




func _on_doneso_pressed():
	$worldPlayer/howToPlay3.visible = false
	pass # Replace with function body.
