extends Node2D

# Replace with your actual Google AI Platform API Key or Token (obtained securely)
var api_key: String

var url: String = "https://asia-southeast1-aiplatform.googleapis.com/v1/projects/GenerativeLanguageClient/locations/asia-southeast1/publishers/google/models/gemini-1.5-flash:streamGenerateContent"
var temperature: float = 1.0
var max_tokens: int = 8192
var headers_dict = {"Content-Type": "application/json"}
var model: String = "gemini-1.5-flash"
var messages = []
var request: HTTPRequest

func _ready():
	# Securely obtain and set the API key
	# ... (your logic to retrieve the API key)
	api_key = "AIzaSyBC9rLkC3yPDsa4fTxLJIeCMZC7Zzz4PE4"  # Replace with actual key

	request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_request_completed)

	process_user_prompt("What is OpenAI")

func process_user_prompt(prompt: String) -> void:
	# Append instruction to the user's prompt to respond in Spanish
	var spanish_prompt = prompt + " (Por favor, responde en español.)"
	
	# Add the modified prompt to the messages array
	messages.append({"role": "user", "content": spanish_prompt})

	# Create the request body
	var body = {
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	}

	var body_json = JSON.stringify(body)

	# Prepare the headers
	var headers_array = PackedStringArray()
	for key in headers_dict.keys():
		headers_array.append(key + ": " + headers_dict[key])

	# Add the authorization header
	var authorization_header = "Authorization: Bearer " + api_key
	headers_array.append(authorization_header)

	# Debug print statements
	print("Sending request to:", url)
	print("Request headers:", headers_array)
	print("Request body:", body_json)

	# Send the HTTP request
	var send_request = request.request(url, headers_array, HTTPClient.METHOD_POST, body_json)
	if send_request != OK:
		print("There was an error sending the request:", send_request)

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	print("Request completed with result:", result)
	print("Response code:", response_code)
	print("Response headers:", headers)
	print("Response body:", body.get_string_from_utf8())
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var response_data = json.data
			# Process the AI response data (e.g., display it on screen)
			if "choices" in response_data:
				var message = response_data["choices"][0]["message"]["content"]  # Get the first part of the response
				# Replace with your desired output logic (e.g., update UI label)
				print("AI Response:", message)
			else:
				print("Unexpected response format:", response_data)
		else:
			print("JSON parse error:", json.error_string)
	else:
		print("Request failed with response code:", response_code)
