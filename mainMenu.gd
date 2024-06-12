class_name main_control
extends Control

@onready var StartGame = $Background/Menu/startGame as Button
@onready var NewGame = $Background/Menu/newGame as Button
@onready var Settings = $Background/Menu/settings as Button
@onready var Exit = $Background/Menu/exit as Button
@onready var map_page: PackedScene = preload("res://World.tscn")
@onready var exitPopup: PackedScene = preload("res://exit_popup.tscn")
var exit_instance: Node
@onready var settings: PackedScene = preload("res://settings_menu.tscn")
var settings_instance: Node

func _ready():
	Exit.button_down.connect(on_exit_pressed)
	Settings.button_down.connect(on_settings_pressed)
	StartGame.button_down.connect(on_start_pressed)
	# Instantiate exit popup and add it to the scene tree
	exit_instance = exitPopup.instantiate()
	add_child(exit_instance)
	exit_instance.hide()
	# Instantiate settings popup and add it to the scene tree
	settings_instance = settings.instantiate()
	add_child(settings_instance)
	settings_instance.hide()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(map_page)

func on_exit_pressed() -> void:
	exit_instance.show()

func on_settings_pressed() -> void:
	settings_instance.show()
