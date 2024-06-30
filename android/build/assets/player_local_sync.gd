extends HTTPRequest

@export var player: Player
var prev_player_data_json: String
var is_request_pending: bool = false
var player_id: int = randi_range(100000, 999999)
var player_color: Color = Color.from_hsv(randf(), 1.0, 1.0)

func _ready() -> void:
	request_completed.connect(_on_request_completed)
 
func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if result != RESULT_SUCCESS:
		printerr("request failed with response code %d" % response_code)
		is_request_pending = false


func _process(_delta: float) -> void:
	if !is_request_pending:
		_send_local_player()

func _send_local_player() -> void:
	const host = "https://vivavocabulario-70a1a-default-rtdb.asia-southeast1.firebasedatabase.app/"#"godot-firebase-test-game-default-rtdb.europe-west1.firebasedatabase.app"#
	var path_player = "/player/%s.json" % player.player_id
	var url = host + path_player
	
	var player_data = {
		"player_id": player.player_id,
		"position_x": player.global_position.x,
		"position_y": player.global_position.y,
		"color": player.player_color.to_html(false)
		}
	
	var player_data_json = JSON.stringify(player_data)
	if player_data_json == prev_player_data_json:
		return
		
		
	prev_player_data_json = player_data_json
	is_request_pending = true
	request(url, [], HTTPClient.METHOD_PUT, player_data_json)
	
