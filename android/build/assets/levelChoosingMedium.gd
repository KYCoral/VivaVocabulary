extends Control

@onready var goBack : Button = $vboxChoicesMedium/TextureRect/goBack
@onready var school: PackedScene = preload("res://World_school.tscn")
@onready var startMedium : Button = $vboxChoicesMedium/TextureRect/play
@onready var startMedium_page: PackedScene = preload("res://levelMedium.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	goBack.button_down.connect(_on_go_back_button_up)
	startMedium.button_down.connect(_on_play_button_up)


func _on_play_button_up():
	get_tree().change_scene_to_packed(startMedium_page)


func _on_go_back_button_up():
	#hide()
	get_tree().change_scene_to_packed(school)
