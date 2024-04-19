class_name main_control
extends Control

@onready var StartGame = $Background/Menu/startGame as Button
@onready var NewGame = $Background/Menu/newGame as Button
@onready var SandboxMode = $Background/Menu/sandboxMode as Button
@onready var Settings = $Background/Menu/settings as Button
@onready var Exit = $Background/Menu/exit as Button

func _ready():
	Exit.button_down.connect(on_exit_pressed)

func on_exit_pressed() -> void:
	get_tree().quit()
