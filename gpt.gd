extends Node

# Importing necessary modules
var model:  = null
var generation_config: Dictionary
var safety_settings: Array

func _ready():
	# Importing GenerativeModel and genai
	var Genai = load("res://path/to/genai.gd")
	var GenerativeModel = Genai.GenerativeModel

	# Importing the rest of the necessary modules
	var  adio : AudioStreamMicrophone = preload("res://path/to/AudioStreamMicrophone.gd")
	var AudioStream = preload("res://path/to/AudioStream.gd")
	var OS = preload("res://path/to/OS.gd")

	# Your Google Gemini API key
	const GOOGLE_GEMINI_API_KEY := 'YOUR_API_KEY_HERE'

	# Configuring the API key
	Genai.configure(GOOGLE_GEMINI_API_KEY)

	# Setting up generation configuration
	generation_config = {
		"temperature": 0.7,
		"top_p": 1,
		"top_k": 1,
		"max_output_tokens": 2048,
	}

	# Setting up safety settings
	safety_settings = [
		{
			"category": "HARM_CATEGORY_HARASSMENT",
			"threshold": "BLOCK_MEDIUM_AND_ABOVE"
		},
		{
			"category": "HARM_CATEGORY_HATE_SPEECH",
			"threshold": "BLOCK_MEDIUM_AND_ABOVE"
		},
		{
			"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
			"threshold": "BLOCK_LOW_AND_ABOVE"
		},
		{
			"category": "HARM_CATEGORY_DANGEROUS_CONTENT",
			"threshold": "BLOCK_MEDIUM_AND_ABOVE"
		},
	]

	# Creating the GenerativeModel instance
	model = GenerativeModel.new("gemini-1.0-pro-latest", generation_config, safety_settings)

func _process(delta):
	var r = AudioStreamMicrophone.new()
	r.set_device(0) # Set your microphone device index
	r.set_format(AudioStreamMicrophone.Format.MONO)
	
	if r.get_status() == AudioStream.PLAYING:
		print("Listening...")
		var audio = r.get_data()
		var text = recognize_google(audio)
		var response = model.generate_content(text)
		var speech = gTTS(response.text, 'es')
		speech.save('user://output.mp3')
		var process = OS.execute("ffplay -nodisp -autoexit -loglevel quiet user://output.mp3")
		process.wait()
