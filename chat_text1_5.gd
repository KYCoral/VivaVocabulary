extends Node2D

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"


@onready var SendButton : Button = $SendButton
@onready var ResponseEdit : TextEdit = $ResponseEdit
@onready var InputEdit : TextEdit = $InputEdit

var api_key = "AIzaSyA24uv8pVwaSNqwHG_2TLhnxyxDjxW6UN0"
var http_request
var conversations = []
var last_user_prompt
@export var target_model = "v1beta/models/gemini-1.5-pro-latest"

@onready var goBack : Button = $goBack
@onready var school_page: PackedScene = preload("res://World_school.tscn")
#var login_instance : Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	

	goBack.button_down.connect(on_goBack_pressed)
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

	var name = target_model.split("/")[-1]


func _process(delta):
	pass


func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")


func on_goBack_pressed() -> void:
	get_tree().change_scene_to_packed(school_page)
	#hide()
	pass
	
func _on_send_button_pressed():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc(email)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.points > 0 && document.doc_fields.points == 5:
				SendButton.disabled = true
				var input = InputEdit.text
				
				_request_chat(input)
			else:
				ResponseEdit.text = "Sorry Pal, can't talk with your right now."




func _request_chat(prompt):
	var url = "https://generativelanguage.googleapis.com/%s:generateContent?key=%s" % [target_model, api_key]
	
	var contents_value = []
	for conversation in conversations:
		contents_value.append({
			"role": "user",
			"parts": [{"text": conversation["user"]}]
		})
		contents_value.append({
			"role": "model",
			"parts": [{"text": conversation["model"]}]
		})
	
	contents_value.append({
		"role": "user",
		"parts": [{"text": prompt}]
	})
	
	var body = JSON.new().stringify({
		"contents": contents_value
	})
	
	last_user_prompt = prompt
	print("send-content" + str(body))
	var error = http_request.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	


func _on_request_completed(result, responseCode, headers, body):
	save_data()
	InputEdit.text = ""
	SendButton.disabled = false
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print("response")
	print(response)
	
	if response == null:
		print("response is null")

	if response.has("error"):
		ResponseEdit.text = str(response.error)

	
	if !response.has("candidates"):
		ResponseEdit.text = ""

	
	if response.candidates[0].finishReason != "STOP":
		ResponseEdit.text = ""
	else:
		var newStr = response.candidates[0].content.parts[0].text
		ResponseEdit.text = newStr
		conversations.append({"user": "%s" % last_user_prompt, "model": "%s" % newStr})


func _on_go_back_pressed():
	pass # Replace with function body.

func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc(email)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.points:
				var data: Dictionary = {
			"points": document.doc_fields.points - 5
			}
				@warning_ignore("unused_variable")
				var update: FirestoreTask = collection.update(email, data)
