extends Control
#@onready var Yes: Button = $validation/Yes
@onready var No: Button =  $validation/No
var userinfo = null
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("pop_up")
	pass # Replace with function body.
	No.button_down.connect(on_no_pressed)
#	Yes.button_down.connect(on_yes_pressed)

func on_no_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed

#func on_yes_pressed() -> void:
	#var changeEmail = $"../TabContainer/Profile/vb_email".text
	#var changeUsername = $"../TabContainer/Profile/vb_username" .text
	#var firestore_collection = Firebase.Firestore.collection("user_data")
	#var document = firestore_collection.get_doc("VivaVocabulario")
	#firestore_collection.update(userinfo.email, 
	#{
	#	'username': changeUsername 
	#})
