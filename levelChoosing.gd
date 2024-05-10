#class_name mainControl
extends Control

@onready var goBack : Button = $vboxChoices/TextureRect/goBack
##@onready var mainMenu: PackedScene = preload("res://mainMenu.tscn")
@onready var startEasy : Button = $vboxChoices/TextureRect/play
@onready var startEasy_page: PackedScene = preload("res://levelEasy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	goBack.button_down.connect(_on_go_back_button_up)
	startEasy.button_down.connect(_on_play_button_up)
	pass

func _on_play_button_up():
	get_tree().change_scene_to_packed(startEasy_page)


func _on_go_back_button_up():
	hide()
