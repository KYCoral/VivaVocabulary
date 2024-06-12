class_name settingsMenu
extends Control

@onready var Cancel: Button = $TabContainer/Profile/cancel
@onready var Save: Button = $TabContainer/Profile/saveChanges
@onready var DeleteAccount : Button = $TabContainer/General/VBoxContainer/delete
@onready var progressPopup: PackedScene = preload("res://saveProgress.tscn")
var saveProgress_instance : Node
@onready var accountDeletePopup: PackedScene = preload("res://removeAccount.tscn")
var accountDelete_instance : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	Cancel.button_down.connect(on_cancel_pressed)
	Save.button_down.connect(on_save_pressed)
	DeleteAccount.button_down.connect(_on_delete_button_up)
		# Instantiate exit popup and add it to the scene tree
	saveProgress_instance = progressPopup.instantiate()
	add_child(saveProgress_instance)
	saveProgress_instance.hide()
	
	accountDelete_instance = accountDeletePopup.instantiate()
	add_child(accountDelete_instance)
	accountDelete_instance.hide()


func on_cancel_pressed() -> void:
	hide() # Hide the pop-up when the close button is pressed

func on_save_pressed() -> void:
	saveProgress_instance.show()


func _on_delete_button_up():
	accountDelete_instance.show()
