extends BaseScene

##@onready var locationPointer : Label = $locationPointer/CollisionShape2D/Label
@onready var tile_map = $TileMap
#@onready var rooftop: Area2D = $rooftop
#@onready var entrance: Area2D = $entrance


#func _ready() -> void:
#	rooftop.body_entered.connect(_on_rooftop_body_entered)
#	rooftop.body_exited.connect(_on_rooftop_body_exited)
#	entrance.body_entered.connect(_on_entrance_body_entered)
#	entrance.body_exited.connect(_on_entrance_body_exited)
#	pass

func _on_rooftop_body_entered(body):
	if body is Player :
		tile_map. set_layer_enabled(9, false)
	pass # Replace with function body.


func _on_rooftop_body_exited(body):
	if body is Player:
		tile_map.set_layer_enabled(9, true)
	pass # Replace with function body.


func _on_option_button_down():
	$menu.show()


func _on_settings_button_down():
	$Camera2D/menu.hide()
	$Camera2D/settingsMenu.show()


func _on_map_button_down():
	$Camera2D/menu.hide()


func _on_entrance_body_entered(body):
	if body is Player:
		tile_map.set_layer_enabled(11, false)
	pass # Replace with function body.



func _on_entrance_body_exited(body):
	if body is Player:
		tile_map.set_layer_enabled(11, true)
	pass # Replace with function body.



#func _on_area_2d_body_entered(body):
#	if body is Player:
#		get_tree().change_scene_to_file("res://World_school.tscn")
#	    
#	pass # Replace with function body.


#func _on_area_2d_body_exited(body):
#	if body is Player:
#		global.transition_scene = false
#	pass # Replace with function

#func change_scene():
#	if global.transition_scene == true:
#		if global.current_scene == "World":
#			get_tree().change_scene_to_file("res://World_school.tscn")
#			global.finish_changescenes()




