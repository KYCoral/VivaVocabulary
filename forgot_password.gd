class_name forgotPassword_control
extends Control


func _on_send_email_button_up():
	var email = $MarginContainer/background/forgotpasswordPanel/editEmail/LineEdit.text
	if email == "" :
		$MarginContainer/background/forgotpasswordPanel/errorMessage.text == "Please enter an email"
	else:
		Firebase.Auth.send_password_reset_email(email)


func _on_go_back_pressed():
	get_tree().change_scene_to_file("res://login.tscn")
	pass # Replace with function body.
