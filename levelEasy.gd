extends Control



@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"



# Predefined questions and answers
var questions = [
	{"question": "Hello", "answer": "Hola"},
	{"question": "Goodbye", "answer": "Adiós"},
	{"question": "Please", "answer": "Por favor"},
	{"question": "Thank you", "answer": "Gracias"},
	{"question": "Yes", "answer": "Sí"},
	{"question": "No", "answer": "No"},
	{"question": "Excuse me", "answer": "Perdón"},
	{"question": "I'm sorry", "answer": "Lo siento"},
	{"question": "Good morning", "answer": "Buenos días"},
	{"question": "Good night", "answer": "Buenas noches"},
	{"question": "How are you?", "answer": "¿Cómo estás?"},
	{"question": "What's your name?", "answer": "¿Cómo te llamas?"},
	{"question": "My name is", "answer": "Me llamo"},
	{"question": "Where is the bathroom?", "answer": "¿Dónde está el baño?"},
	{"question": "How much is it?", "answer": "¿Cuánto cuesta?"},
	{"question": "I don't understand", "answer": "No entiendo"},
	{"question": "Help!", "answer": "¡Ayuda!"},
	{"question": "I love you", "answer": "Te quiero"},
	{"question": "See you later", "answer": "Hasta luego"},
	{"question": "Good afternoon", "answer": "Buenas tardes"}
]


var current_question_index = 0
var score = 0
@onready var start_screen = $CanvasLayer2
@onready var congrats_screen = $congrats
# References to the UI elements
@onready var question_label = $TextureRect/question
@onready var answer_input = $TextureRect/answerInput
@onready var scoreBar = $TextureRect/ProgressBar
@onready var  done_screen = $GameOverScreen

func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	randomize() # Seed the random number generator
	shuffle_questions()
	show_question()
	update_score()
	done_screen.hide()
	$CanvasLayer2/loading.visible = true

func _on_FirebaseAuth_login_succeeded(auth_info):
	$CanvasLayer2/loading.visible = false
	print("Firebase login success!")


func shuffle_questions():
	questions.shuffle()

func show_question():
	# Display the current question if the game is not over
	question_label.text = questions[current_question_index]["question"]
	answer_input.text = ""


func update_score():
	scoreBar.value = score


func check_game_over():
	if score < 0:
		done()
	if score >= 10:
		congrats()

func done() -> void:
	done_screen.show()

func congrats() -> void:
	congrats_screen.show()


func _on_map_pressed():
	get_tree().change_scene_to_file("res://World_library.tscn")
	pass # Replace with function body.


func _on_answer_pressed():
	if answer_input.text == "":
		$TextureRect/answer.disabled
	else:
		answers()

func answers():
	var user_answer = answer_input.text
	var correct_answer = questions[current_question_index]["answer"]
	if user_answer.strip_edges().to_lower() == correct_answer.strip_edges().to_lower():
		score += 1
	else:
		score -= 1
	
	# Move to the next question or loop back to the first one
	current_question_index = (current_question_index + 1) % questions.size()
	update_score()
	check_game_over()

	show_question()

	pass # Replace with function body.


func _on_restart_button_pressed():
	congrats_screen.hide()
	done_screen.hide()
	current_question_index = 0
	_ready()
	save_data()
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
				var data: Dictionary  = {
			"points": document.doc_fields.points + 5,
			"score" : document.doc_fields.score + score
			}
				@warning_ignore("unused_variable")
				task = collection.update(auth.localid,data)


func _on_start_pressed():
	start_screen.hide()
	pass # Replace with function body.
