extends Node2D


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
	goBack.button_down.connect(on_goBack_pressed)
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

	#var option_keys = ["SexuallyExplicit", "HateSpeech", "Harassment", "DangerousContent"]
	#for key in option_keys:
	#	var option = find_child(key + "OptionButton")
	#	option.add_item("BLOCK_NONE")
	#	option.add_item("HARM_BLOCK_THRESHOLD_UNSPECIFIED")
	#	option.add_item("BLOCK_LOW_AND_ABOVE")
	#	option.add_item("BLOCK_MEDIUM_AND_ABOVE")
	#	option.add_item("BLOCK_ONLY_HIGH")
		
	var name = target_model.split("/")[-1]
	#find_child("ModelName").text = name

func _process(delta):
	pass

#func _get_option_selected_text(key):
	#var option = find_child(key + "OptionButton")
	#var text = option.get_item_text(option.get_selected_id())
	#return text
	
func on_goBack_pressed() -> void:
	get_tree().change_scene_to_packed(school_page)
	#hide()
	pass
	
func _on_send_button_pressed():
	SendButton.disabled = true
	var input = InputEdit.text
	
	_request_chat(input)

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
		"contents": contents_value#,
	#	"safety_settings": [
	#		{
	#			"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
	#			"threshold": _get_option_selected_text("SexuallyExplicit"),
	#		},
	#		{
	#			"category": "HARM_CATEGORY_HATE_SPEECH",
	#			"threshold": _get_option_selected_text("HateSpeech"),
	#		},
	#		{
	#			"category": "HARM_CATEGORY_HARASSMENT",
	#			"threshold": _get_option_selected_text("Harassment"),
	#		},
	#		{
	#			"category": "HARM_CATEGORY_DANGEROUS_CONTENT",
	#			"threshold": _get_option_selected_text("DangerousContent"),
	#		},
	#	]
	})
	
	last_user_prompt = prompt
	print("send-content" + str(body))
	var error = http_request.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	
	#if error != OK:
	#	push_error("requested but error happened code = %s" % error)

#func _set_label_text(key, text):
#	var label = find_child(key)
#	if text == "HIGH":
#		label.get_label_settings().set_font_color(Color(1, 0, 0, 1))
#	else:
#		label.get_label_settings().set_font_color(Color(1, 1, 1, 1))
#	label.text = text


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
	#	find_child("FinishedLabel").text = "No Response"
	#	find_child("FinishedLabel").visible = true
	#	return
	
	#if response.has("promptFeedback"):
	#	var ratings = response.promptFeedback.safetyRatings
	#	for rate in ratings:
	#		match rate.category:
	#			"HARM_CATEGORY_SEXUALLY_EXPLICIT":
	#				_set_label_text("SexuallyExplicitStatus", rate.probability)
	#				
	#			"HARM_CATEGORY_HATE_SPEECH":
	#				_set_label_text("HateSpeechStatus", rate.probability)
	#				
	#			"HARM_CATEGORY_HARASSMENT":
	#				_set_label_text("HarassmentStatus", rate.probability)
	#				
	#			"HARM_CATEGORY_DANGEROUS_CONTENT":
	#				_set_label_text("DangerousContentStatus", rate.probability)
					
	if response.has("error"):
	#	find_child("FinishedLabel").text = "ERROR"
	#	find_child("FinishedLabel").visible = true
		ResponseEdit.text = str(response.error)
	#	return
	
	if !response.has("candidates"):
	#	find_child("FinishedLabel").text = "Blocked"
	#	find_child("FinishedLabel").visible = true
		ResponseEdit.text = ""
	#	return
	
	if response.candidates[0].finishReason != "STOP":
	#	find_child("FinishedLabel").text = "Safety"
	#	find_child("FinishedLabel").visible = true
		ResponseEdit.text = ""
	else:
	#	find_child("FinishedLabel").text = ""
	#	find_child("FinishedLabel").visible = false
		var newStr = response.candidates[0].content.parts[0].text
		ResponseEdit.text = newStr
		conversations.append({"user": "%s" % last_user_prompt, "model": "%s" % newStr})


#func strip_bbcode(source:String) -> String:
##	var regex = RegEx.new()
#	regex.compile("\\[.+?\\]")
#	return regex.sub(source, "", true)
#	


func _on_go_back_pressed():
	pass # Replace with function body.
