extends Node2D

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"

@onready var SendButton : Button = $SendButton
@onready var ResponseEdit : TextEdit = $ResponseEdit
@onready var InputEdit : TextEdit = $InputEdit/LineEdit

var api_key = "AIzaSyA24uv8pVwaSNqwHG_2TLhnxyxDjxW6UN0"
var http_request
var conversations = []
var last_user_prompt
@export var target_model = "v1beta/models/gemini-1.5-flash-latest"

@onready var goBack : Button = $goBack

# Define the AI character role
var ai_character_role = "You are Spanish-speaking student."


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	
	goBack.button_down.connect(_on_go_back_button_down)
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

	var name = target_model.split("/")[-1]

func _process(delta):
	pass

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")

func _on_send_button_pressed():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc(email)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.points >= 5:
				SendButton.disabled = true
				var input = InputEdit.text
				
				_request_chat(input)
			else:
				ResponseEdit.text =  "Lo siento, no puedo hablar contigo ahora mismo. Gana más puntos para chatear."

func _request_chat(prompt):
	var url = "https://generativelanguage.googleapis.com/%s:generateContent?key=%s" % [target_model, api_key]
	
	var contents_value = []
	# Embed the AI character role in the user's initial prompt
	if conversations.size() == 0:
		contents_value.append({
			"role": "user",
			"parts": [{"text": ai_character_role}]
		})

	# Add existing conversation history
	for conversation in conversations:
		contents_value.append({
			"role": "user",
			"parts": [{"text": conversation["user"]}]
		})
		contents_value.append({
			"role": "model",
			"parts": [{"text": conversation["model"]}]
		})
	
	# Append the latest user prompt
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

	else:
		var newStr = response.candidates[0].content.parts[0].text
		ResponseEdit.text = newStr
		conversations.append({"user": "%s" % last_user_prompt, "model": "%s" % newStr})

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

func _on_go_back_button_down():
	get_tree().change_scene_to_file("res://World_school.tscn")
	pass # Replace with function body.