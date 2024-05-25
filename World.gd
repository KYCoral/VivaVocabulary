extends Node2D


@onready var lack : Label = $AnimationPlayer/Label
@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	lack.hide()
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	lack.show()
	$AnimationPlayer.play("lacking")


func _on_area_2d_body_exited(body):
	#lack.hide() 
	pass


func _on_rooftop_body_entered(body):
	tile_map. set_layer_enabled(7, false)
	pass # Replace with function body.


func _on_rooftop_body_exited(body):
	tile_map.set_layer_enabled(7, true)
	pass # Replace with function body.
