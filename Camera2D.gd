extends Camera2D

@onready var tilemap: TileMap = $"../../TileMap"
@onready var menu = $menu
# Called when the node enters the scene tree for the first time.
func _ready():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y

	pass # Replace with function body.



func _on_option_button_down():
	pass # Replace with function body.
