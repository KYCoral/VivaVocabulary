extends Panel


@onready var SendButton : Button = $InputEdit/SendButton
@onready var ResponseEdit : TextEdit = $ResponseEdit
@onready var InputEdit : TextEdit = $InputEdit/LineEdit
@onready var convo = $"."
var api_key = "AIzaSyA24uv8pVwaSNqwHG_2TLhnxyxDjxW6UN0"
var http_request
var conversations = []
var last_user_prompt
@export var target_model = "v1beta/models/gemini-1.5-flash-latest"


# Define the AI character role
var ai_character_role = "Your name is Rachel and you are my hyper friend."


# Called when the node enters the scene tree for the first time.
func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

	var name = target_model.split("/")[-1]

func _process(delta):
	pass


func _on_send_button_pressed():
	SendButton.disabled = true
	var input = InputEdit.text
	
	_request_chat(input)

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



func _on_done_pressed():
	convo.hide()
	pass # Replace with function body.
