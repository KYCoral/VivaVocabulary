extends Node

var current_scene = "School_grounds"
var transition_scene = false

var player_exit_posx = 0
var player_exit_posy = 0
var player_start_school_posx = 0
var player_start_school_posy = 0

func finish_changescenes():
	if transition_scene == true:
		transition_scene  = false
		if current_scene == "School_grounds":
			current_scene = "World_school"
		else: 
			current_scene = "School_grounds"
		if current_scene == "School_grounds":
			current_scene = "World_library"
		else: 
			current_scene = "School_grounds"

var login_data = {
	"username": "",
	"password": ""
}

func set_login_data(username: String, password: String):
	login_data.username = username
	login_data.password = password

func get_login_data() -> Dictionary:
	return login_data

