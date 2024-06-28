extends Node2D

# Predefined questions and answers
var questions = [
	{"question": "Translate 'Hello' to Spanish", "answer": "Hola"},
	{"question": "Translate 'Goodbye' to Spanish", "answer": "Adiós"},
	{"question": "Translate 'Please' to Spanish", "answer": "Por favor"},
	{"question": "Translate 'Thank you' to Spanish", "answer": "Gracias"},
	{"question": "Translate 'Yes' to Spanish", "answer": "Sí"},
	{"question": "Translate 'No' to Spanish", "answer": "No"},
	{"question": "Translate 'Excuse me' to Spanish", "answer": "Perdón"},
	{"question": "Translate 'I'm sorry' to Spanish", "answer": "Lo siento"},
	{"question": "Translate 'Good morning' to Spanish", "answer": "Buenos días"},
	{"question": "Translate 'Good night' to Spanish", "answer": "Buenas noches"},
	{"question": "Translate 'How are you?' to Spanish", "answer": "¿Cómo estás?"},
	{"question": "Translate 'What's your name?' to Spanish", "answer": "¿Cómo te llamas?"},
	{"question": "Translate 'My name is' to Spanish", "answer": "Me llamo"},
	{"question": "Translate 'Where is the bathroom?' to Spanish", "answer": "¿Dónde está el baño?"},
	{"question": "Translate 'How much is it?' to Spanish", "answer": "¿Cuánto cuesta?"},
	{"question": "Translate 'I don't understand' to Spanish", "answer": "No entiendo"},
	{"question": "Translate 'Help!' to Spanish", "answer": "¡Ayuda!"},
	{"question": "Translate 'I love you' to Spanish", "answer": "Te quiero"},
	{"question": "Translate 'See you later' to Spanish", "answer": "Hasta luego"},
	{"question": "Translate 'Good afternoon' to Spanish", "answer": "Buenas tardes"}
]


var current_question_index = 0
var score = 0

# References to the UI elements
@onready var question_label = $question/TextEdit
@onready var answer_input = $answer/TextEdit
@onready var feedback_label = $question/feedback
@onready var score_label = $answer/score
@onready var  done_screen = $GameOverScreen

func _ready():
	randomize() # Seed the random number generator
	shuffle_questions()
	show_question()
	update_score()
	done_screen.hide()

func shuffle_questions():
	questions.shuffle()

func show_question():
	# Display the current question if the game is not over
	question_label.text = questions[current_question_index]["question"]
	answer_input.text = ""
	feedback_label.text = ""

func _on_send_button_pressed():
	var user_answer = answer_input.text
	var correct_answer = questions[current_question_index]["answer"]
	if user_answer.strip_edges().to_lower() == correct_answer.strip_edges().to_lower():
		feedback_label.text = "Correct!"
		score += 1
	else:
		feedback_label.text = "Incorrect. The correct answer is: " + correct_answer
		score -= 1
	
	# Move to the next question or loop back to the first one
	current_question_index = (current_question_index + 1) % questions.size()
	update_score()
	check_game_over()

	show_question()
	pass # Replace with function body.

func update_score():
	score_label.text = "Score: " + str(score)


func check_game_over():
	if score >= 2:
		done()
	
func done() -> void:
	done_screen.show()

func _on_map_pressed():
	get_tree().change_scene_to_file("res://World_school.tscn")
	pass # Replace with function body.
