extends Node2D

# URL to the OpenAI API
var openai_url: String = "https://api.openai.com/v1/chat/completions"
# Your OpenAI API key (replace with your actual key)
var api_key: String = "sk-proj-kMLvpY7IhccLrdGWarNaT3BlbkFJMGgj8WlL0iY2jMirNdKO"

# Nodes
@onready var input_field: LineEdit = $TextureRect/LineEdit
@onready var submit_button: Button = $TextureRect/Button
@onready var response_area: RichTextLabel = $TextureRect/RichTextLabel

# Maximum retries for rate limit errors
var max_retries: int = 5

func _ready() -> void:
	submit_button.pressed.connect(_on_button_button_down)

func _on_button_button_down() -> void:
	var user_input: String = input_field.text
	if user_input.strip_edges() == "":
		return
	
	# Create the request
	var request: Dictionary = {
		"model": "gpt-3.5-turbo",
		"messages": [{"role": "user", "content": user_input}],
		"temperature": 0.7
	}

	_send_request(JSON.stringify(request))

func _send_request(request_data: String, retry_count: int = 0) -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_http_request_request_completed.bind(http_request, retry_count))
	
	var headers: Array[String] = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]

	http_request.request(openai_url, headers, HTTPClient.METHOD_POST, request_data)

func _on_http_request_request_completed(http_request: HTTPRequest, result: int, response_code: int, headers: Array[Dictionary], body: PackedByteArray, retry_count: int) -> void:
	if response_code == 200:
		var json = JSON.new()
		var response = json.parse(body.get_string_from_utf8())
		if response.error == OK:
			var text: String = response.result["choices"][0]["message"]["content"].strip_edges()
			response_area.text += "\n> " + input_field.text + "\n" + text + "\n"
			input_field.text = ""
		else:
			response_area.text += "\nError parsing response."
	elif response_code == 429 and retry_count < max_retries:
		# Handle rate limit error by retrying with delay
		retry_count += 1
		var delay_time = pow(2, retry_count)  # Exponential backoff
		response_area.text += "\nRate limit hit. Retrying in " + str(delay_time) + " seconds."
		await get_tree().create_timer(delay_time).timeout
		_send_request(request_data, retry_count)
	else:
		response_area.text += "\nError: " + str(response_code) + " - " + http_request.get_response_body().get_string_from_utf8()
