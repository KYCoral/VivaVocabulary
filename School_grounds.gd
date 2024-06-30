class_name School_grounds extends BaseScene

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
@onready var tile_map = $TileMap
@onready var camera: Camera2D = $worldPlayer/Camera2D
@onready var convo = $worldPlayer/convo
@onready var talkButton : Button = $"../../NPC/interact"
@onready  var talk: Button = $NPC/interact
@onready var progressBar : ProgressBar = $worldPlayer/Camera2D/profile/ProgressBar


func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	convo.hide()

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



func _on_option_button_down():
	$menu.show()


func _on_settings_button_down():
	$Camera2D/menu.hide()
	$Camera2D/settingsMenu.show()

func _on_map_button_down():
	$Camera2D/menu.hide()

func _on_area_2d_body_exited(body):
	if body is Player:
		Global.transition_scene = false
	pass # Replace with function

func change_scene():
	if Global.transition_scene == true:
		if Global.current_scene == "School_grounds":
			get_tree().change_scene_to_file("res://World_school.tscn")
			Global.finish_changescenes()



func _on_roof_body_entered(body):
	if body is Player :
		tile_map. set_layer_enabled(4, false)
	pass # Replace with function body.



func _on_roof_body_exited(body):
	if body is Player:
		tile_map.set_layer_enabled(4, true)
	pass # Replace with function body.


func _on_scene_trigger_body_entered(body):
	if body is Player:
		change_scene()
 
	pass # Replace with function body.


func _on_interact_pressed():
	camera.visible = false
	convo.show()
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
