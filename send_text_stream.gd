extends Control


#see https://ai.google.dev/tutorials/rest_quickstart

var api_key = "AIzaSyA24uv8pVwaSNqwHG_2TLhnxyxDjxW6UN0"
var gemini_stream_client
@onready var response_edit: TextEdit = $MarginContainer/VBoxContainer/HBoxContainer2/ResponseEdit

func _ready():
	var settings = JSON.parse_string(FileAccess.get_file_as_string("res://settings.json"))
	api_key = settings.api_key
	gemini_stream_client = GeminiStreamClient.new(api_key)
	gemini_stream_client.receive_text.connect(_on_receive_text)
	gemini_stream_client.receive_finished.connect(_on_receive_finished)


func _on_request_finished():
	$MarginContainer/VBoxContainer/HBoxContainer/SendButton.disabled = false
	
func _on_send_button_pressed():
	var input = $MarginContainer/VBoxContainer/HBoxContainer/InputEdit.text
	_request_text(input)

func _request_text(prompt):
	$MarginContainer/VBoxContainer/HBoxContainer2/ResponseEdit.text = ""
	$MarginContainer/VBoxContainer/HBoxContainer/SendButton.disabled = true
	var error = gemini_stream_client.request_text(prompt)
	
	if error != OK:
		push_error("Some error happened:%s"%error)
		
func _on_receive_text(text):
	text = text.replace("\\n\\n","\n") #somehow return double
	text = text.replace("\\n", "\n")  # 
	text = text.replace("\\r", "\r")  # 
	text = text.replace("\\t", "\t")  # 
	text = text.replace("\\\\", "\\") # 
	text = text.replace("\\\"", "\"") # 
	text = text.replace("\\\'", "\'") # 
	
	response_edit.text = response_edit.text + text
	
func _on_receive_finished():
	$MarginContainer/VBoxContainer/HBoxContainer/SendButton.disabled = false
