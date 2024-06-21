extends Node

class_name PlayerManager

const Utils = preload("res://scripts/utils.gd")

@export var local_player_node : CharacterBody2D 

var local_player_id = Utils.generate_random_player_name()
var local_player_color = Utils.generate_random_player_color()

func _ready() -> void:
	pass
	local_player_node.set_color(local_player_color)
	local_player_node.set_player_name(local_player_id)


