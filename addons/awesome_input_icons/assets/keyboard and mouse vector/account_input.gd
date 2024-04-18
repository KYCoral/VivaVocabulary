extends LineEdit


func _ready():
	grab_focus()

func _on_text_changed(new_text):
	# Check if the entered text is a valid Gmail address
	var is_valid_email = new_text

	if not is_valid_email:
		# Display an error message or take other actions
		print("Invalid email address. Please enter a Gmail account.")
