extends BaseScene

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
@onready var level2: Button = $level2/CollisionShape2D/level2
@onready var level2_page: PackedScene = preload("res://levelMedium.tscn")
@onready var interact : Button = $npc/interact
@onready var chat_page: PackedScene = preload("res://scenes/chat.tscn")
@onready var animationNPC : AnimationPlayer = $npc/AnimationPlayer
@onready var entranceAny = $Marker2D
@onready var players = $worldPlayer
# Called when the node enters the scene tree for the first time.

func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	level2.button_up.connect(_on_level_2_button_up)	
	animationNPC.play("nps")
	players.global_position = entranceAny.global_position
	$worldPlayer/Control.visible = true
	interact.hide()
	$level2/level2_play.stop()
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


func _on_interact_pressed():
	get_tree().change_scene_to_packed(chat_page)
	pass # Replace with function body.
