extends Node2D

@onready var level2: Button = $interactions/level2
@onready var level2_page: PackedScene = preload("res://levelChoosingMedium.tscn")

var level2_instance: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	level2.button_down.connect(_on_level_2_button_up)	
		# Instantiate exit popup and add it to the scene tree
	level2_instance = level2_page.instantiate()
	add_child(level2_instance)
	level2_instance.hide()

func _on_level_2_button_up():
	level2_instance.show()
