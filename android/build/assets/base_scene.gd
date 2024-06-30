class_name BaseScene extends Node

@onready var player : Player = $worldPlayer
@onready var entrance_markers: Node2D = $EntranceMarkers

# Called when the node enters the scene tree for the first time.
func _ready():
	if scene_manager.player:
		print("Entered the area!")
		if player:
			player.queue_free()
			
		player = scene_manager.player
		add_child(player)
		
	position_player()
	
	pass # Replace with function body.


func position_player() -> void:
	var last_scene = scene_manager.last_scene_name
	if last_scene.is_empty():
		last_scene = "any"
		
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "any" or entrance.name == last_scene:
			player.global_position = entrance.global_position
