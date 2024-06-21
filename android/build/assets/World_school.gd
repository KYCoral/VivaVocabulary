extends BaseScene


@onready var level2: Button = $level2/CollisionShape2D/level2
@onready var level2_page: PackedScene = preload("res://levelChoosingMedium.tscn")

@onready var interact : Button = $Untitled12720240510130540/interact
@onready var chat_page: PackedScene = preload("res://scenes/chat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	level2.button_up.connect(_on_level_2_button_up)	
	interact.button_down.connect(_on_interact_button_up)
		# Instantiate exit popup and add it to the scene tree
	#level2_instance = level2_page.instantiate()
	#add_child(level2_instance)
	#level2_instance.hide()
	interact.hide()
	$level2/level2_play.stop()
	#level2_instance = level2_page.instantiate()
	#add_child(level2_instance)
	#level2_instance.hide()
	pass # Replace with function body.r.player:



func _on_level_2_button_up():
	get_tree().change_scene_to_packed(level2_page)
	#level2_instance.show()
	pass # Replace with function body.


func _on_level_2_body_entered(_body):
	$level2/level2_play.play("level2")
	level2.show()
	pass # Replace with function body.


func _on_level_2_body_exited(_body):
	$level2/level2_play.stop()
	level2.hide()
	pass # Replace with function body.


func _on_interact_button_up():
	get_tree().change_scene_to_packed(chat_page)
	
	pass # Replace with function body.


func _on_interact_detection_body_entered(_body):
	interact.show()
	$level2/level2_play.play("interact")
	pass # Replace with function body.


func _on_interact_detection_body_exited(_body):
	interact.hide()
	$level2/level2_play.stop()
	pass # Replace with function body.
