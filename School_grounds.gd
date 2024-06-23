class_name School_grounds extends BaseScene



@export var email : String = "kazumirimurutempest@gmail.com"
@export var password : String = "password123"
var userinfo = null
var COLLECTION_ID = "user_data"
##@onready var locationPointer : Label = $locationPointer/CollisionShape2D/Label
@onready var tile_map = $TileMap
#@onready var rooftop: Area2D = $rooftop
#@onready var entrance: Area2D = $entrance
#var username = $worldPlayer/Camera2D/profile/username.text


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	##GameManager.userInfo = userinfo
	
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
			print(finished_task.error)



func _on_option_button_down():
	$menu.show()


func _on_settings_button_down():
	$Camera2D/menu.hide()
	$Camera2D/settingsMenu.show()


func _on_map_button_down():
	$Camera2D/menu.hide()


#func _on_entrance_body_entered(body):
#	if body is Player:
#		tile_map.set_layer_enabled(7, false)
#	pass # Replace with function body.



#func _on_entrance_body_exited(body):
#	if body is Player:
#		tile_map.set_layer_enabled(7, true)
#	pass # Replace with function body.


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
		tile_map. set_layer_enabled(7, false)
	pass # Replace with function body.



func _on_roof_body_exited(body):
	if body is Player:
		tile_map.set_layer_enabled(7, true)
	pass # Replace with function body.


func _on_scene_trigger_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://World_school.tscn")
		change_scene()
		pass # Replace with function body.
	pass # Replace with function body.
