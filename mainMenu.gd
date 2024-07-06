class_name main_control
extends Control




# Called when the node enters the scene tree for the first time.
@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"

@onready var Continue : Button = $Background/Menu/startGame
@onready var StartGame = $Background/Menu/startGame as Button
@onready var NewGame = $Background/Menu/newGame as Button
@onready var Settings = $Background/Menu/settings as Button
@onready var Exit = $Background/Menu/exit as Button
@onready var map_page: PackedScene = preload("res://School_grounds.tscn")
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")
var exit_instance: Node
@onready var settings: PackedScene = preload("res://settings_menu.tscn")
var settings_instance: Node
@onready var loading: PackedScene = preload("res://loading.tscn")
var loading_instance: Node

func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	Exit.button_down.connect(on_exit_pressed)
	Settings.button_down.connect(on_settings_pressed)
	# Instantiate exit popup and add it to the scene tree
	exit_instance = exitPopup.instantiate()
	add_child(exit_instance)
	exit_instance.hide()
	
	loading_instance = loading.instantiate()
	add_child(loading_instance)
	loading_instance.show()
	
	# Instantiate settings popup and add it to the scene tree
	settings_instance = settings.instantiate()
	add_child(settings_instance)
	settings_instance.hide()
	Continue.disabled = true


func on_exit_pressed() -> void:
	exit_instance.show()

func on_settings_pressed() -> void:
	settings_instance.show()


@warning_ignore("unused_parameter")
func _on_FirebaseAuth_login_succeeded(auth_info):
	loading_instance.hide()
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		
		var task: FirestoreTask = await collection.get_doc(email)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.points > 0:
				Continue.disabled = false
			else:
				Continue.disabled = true
			print(finished_task.error)


func _on_new_game_button_up():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var data: Dictionary = {
		'level' : 0,
		'points' : 1,
		'score': 0 
	}
		
		@warning_ignore("unused_variable")
		var task: FirestoreTask = await collection.update(auth.localid,data)
		
	get_tree().change_scene_to_packed(map_page)
	pass # Replace with function body.


func _on_start_game_pressed():
	get_tree().change_scene_to_packed(map_page)
	pass # Replace with function body.
