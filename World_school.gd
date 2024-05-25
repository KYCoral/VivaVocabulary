extends Node2D


@onready var level2: Button = $level2/CollisionShape2D/level2
@onready var level2_page: PackedScene = preload("res://levelChoosingMedium.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	level2.button_down.connect(_on_level_2_button_up)	
		# Instantiate exit popup and add it to the scene tree
	#level2_instance = level2_page.instantiate()
	#add_child(level2_instance)
	#level2_instance.hide()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_level_2_button_up():
	get_tree().change_scene_to_packed(level2_page)
	#level2_instance.show()
	pass # Replace with function body.


func _on_level_2_body_entered(body):
	$level2/level2_play.play("level2")
	level2.show()
	pass # Replace with function body.


func _on_level_2_body_exited(body):
	level2.hide()
	pass # Replace with function body.
