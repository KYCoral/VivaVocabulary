extends Control

@onready var goBack : Button = $vboxChoices/TextureRect/goBack
@onready var mainMenu: PackedScene = preload("res://mainMenu.tscn")
@onready var startEasy : Button = $vboxChoices/TextureRect/play
@onready var startEasy_page: PackedScene = preload("res://levelEasy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	goBack.button_down.connect(on_goBack_pressed)
	startEasy.button_down.connect(on_startEasy_pressed)
	set_process(false)

func on_startEasy_pressed() -> void:
	get_tree().change_scene_to_packed(startEasy_page)
	set_process(false)

func on_goBack_pressed() -> void:
	get_tree().change_scene_to_packed(mainMenu)
	set_process(false)
