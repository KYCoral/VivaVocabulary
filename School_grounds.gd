class_name School_grounds extends Node2D


func _ready():
	$buttons/prev.visible = false
	$buttons/next.visible = true
	$AnimationPlayer.play("library")
	pass



func _on_exit_pressed():
	$exit_control.visible = true
	pass # Replace with function body.


func _on_enter_school_pressed():
	get_tree().change_scene_to_file("res://World_school.tscn")
	pass # Replace with function body.


func _on_enter_library_pressed():
	get_tree().change_scene_to_file("res://World_library.tscn")
	pass # Replace with function body.


func _on_next_pressed():
	$buttons/prev.visible = true
	$buttons/next.visible = false
	$AnimationPlayer.play("school")
	pass # Replace with function body.


func _on_prev_pressed():
	$buttons/prev.visible = false
	$buttons/next.visible = true
	$AnimationPlayer.play("library")
	pass # Replace with function body.
