extends Node2D

@export var email : String = Global.login_data.username
@export var password : String = Global.login_data.password
var userinfo = null
var COLLECTION_ID = "user_data"
@onready var Resume : Button = $CanvasLayer2/Paused/CenterContainer/VBoxContainer2/Resume
@onready var Restart : Button = $CanvasLayer2/Paused/CenterContainer/VBoxContainer2/Restart
@onready var Map : Button = $CanvasLayer2/Paused/CenterContainer/VBoxContainer2/Map
@onready var enemy: PackedScene = preload("res://Enemy.tscn")
@onready var buttonStart: Button = $CanvasLayer2/startGame/CenterContainer/VBoxContainer/start
@onready var enemy_container = $CanvasLayer/VBoxContainer/MiddleRow/EnemyContainer
@onready var spawn_container = $CanvasLayer/VBoxContainer/MiddleRow/SpawnContainer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var difficulty_timer: Timer = $DifficultyTimer
@onready var pause : Button = $CanvasLayer/option
@onready var pause_screen = $CanvasLayer2/Paused
@onready var difficulty_value = $CanvasLayer/VBoxContainer/BottomRow/HBoxContainer/DifficultyValue
@onready var killed_value = $CanvasLayer/VBoxContainer/TopRow2/TopRow/EnemiesKilledValue
@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var start_screen = $CanvasLayer2/startGame

@onready var gameOver_value = $CanvasLayer/GameOverScreen/CenterContainer/VBoxContainer/WordCount
@onready var SETTINGS = $settingsMenu
var active_enemy: Node = null
var current_letter_index: int = -1

var difficulty: int = 0
var enemies_killed: int = 0



func _ready() -> void:
	DisplayServer.virtual_keyboard_show("")
	# Connect the timers to their respective functions
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	Resume.button_down.connect(self._on_resume_button_down)
	Restart.button_down.connect(self._on_restart_button_pressed)
	Map.button_down.connect(self._on_map_button_down)
	pause.button_down.connect(self._on_option_button_down)
	spawn_timer.timeout.connect(self._on_spawn_timer_timeout)
	difficulty_timer.timeout.connect(self._on_difficulty_timer_timeout)
	buttonStart.button_down.connect(self._on_start_button_down)
	
	$CanvasLayer2/loading.visible = true
	
	spawn_timer.stop()
	difficulty_timer.stop()
	active_enemy = null
	current_letter_index = -1
	for enemy in enemy_container.get_children():
		enemy.queue_free()


func _on_FirebaseAuth_login_succeeded(auth_info):
	$CanvasLayer2/loading.visible = false

func find_new_active_enemy(typed_character: String) -> void:
	for enemy in enemy_container.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0, 1)
		if next_character == typed_character:
			print("Found new enemy that starts with %s" % next_character)
			active_enemy = enemy
			current_letter_index = 1
			active_enemy.set_next_character(current_letter_index)
			return

func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventKey and event.pressed and not event.echo:
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		if active_enemy == null:
			find_new_active_enemy(key_typed)
		else:
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed == next_character:
				print("Successfully typed %s" % key_typed)
				current_letter_index += 1
				active_enemy.set_next_character(current_letter_index)
				if current_letter_index == prompt.length():
					print("Done")
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
					enemies_killed += 1
					killed_value.text = str(enemies_killed)
			else:
				print("Incorrectly typed %s instead of %s" % [key_typed, next_character])

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy_instance = enemy.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_instance.global_position = spawns[index].global_position
	enemy_container.add_child(enemy_instance)
	enemy_instance.set_difficulty(difficulty)

func _on_difficulty_timer_timeout() -> void:
	difficulty += 1
	GlobalSignals.emit_signal("difficulty_increased", difficulty)
	print("Difficulty increased to %d" % difficulty)
	var new_wait_time = spawn_timer.wait_time - 0.2
	spawn_timer.wait_time = clamp(new_wait_time, 0.2, spawn_timer.wait_time)
	difficulty_value.text = str(difficulty)
	
	if difficulty >= 20:
		difficulty_timer.stop()
		difficulty = 20
		return

func _on_lose_area_body_entered(_body: Node) -> void:
	game_over()

func game_over() -> void:
	game_over_screen.show()
	spawn_timer.stop()
	difficulty_timer.stop()
	active_enemy = null
	current_letter_index = -1
	gameOver_value.text = str(enemies_killed)
	for enemy in enemy_container.get_children():
		enemy.queue_free()
	DisplayServer.virtual_keyboard_hide()

func start_game() -> void:
	DisplayServer.virtual_keyboard_show("")
	game_over_screen.hide()
	difficulty = 0
	enemies_killed = 0
	difficulty_value.text = str(0)
	killed_value.text = str(0)
	randomize()
	spawn_timer.start()
	difficulty_timer.start()
	spawn_enemy()

func _on_restart_button_pressed() -> void:
	start_game()
	if killed_value.text > 10:
		save_data()


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
			"score" : document.doc_fields.score + killed_value
			}
				@warning_ignore("unused_variable")
				task = collection.update(auth.localid,data)

func _on_start_button_down() -> void:
	start_screen.hide()
	difficulty = 0
	enemies_killed = 0
	difficulty_value.text = str(0)
	killed_value.text = str(0)
	randomize()
	spawn_timer.start()
	difficulty_timer.start()
	spawn_enemy()


func _on_map_button_down() -> void:
	get_tree().change_scene_to_file("res://World_school.tscn")
	pass # Replace with function body.


func _on_option_button_down():
	DisplayServer.virtual_keyboard_hide()
	pause_screen.show()
	get_tree().paused
	pass # Replace with function body.


func _on_resume_button_down():
	DisplayServer.virtual_keyboard_show("")
	#get_tree().paused = false
	pause_screen.hide()
	
	pass # Replace with function body.
	


func _on_restart_button_down():
	start_game()
	pass # Replace with function body.


func _on_keyboard_pressed():
	DisplayServer.virtual_keyboard_show("")
	pass # Replace with function body.
