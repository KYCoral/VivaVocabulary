extends Node2D

# References to the screen nodes
@onready var top_screen: Control = $TopScreen
@onready var bottom_screen: Control = $BottomScreen

# Called when the node enters the scene tree for the first time
func _ready():
	set_landscape_layout()  # Initialize with landscape layout
	# Connect the size_changed signal to handle screen resize
	get_viewport().size_changed.connect(_on_screen_size_changed)

# Function to set landscape layout
func set_landscape_layout():
	# Position screens side by side and stretch to fill half of the screen each
	top_screen.anchor_left = 0.0
	top_screen.anchor_top = 0.0
	top_screen.anchor_right = 0.5
	top_screen.anchor_bottom = 1.0

	bottom_screen.anchor_left = 0.5
	bottom_screen.anchor_top = 0.0
	bottom_screen.anchor_right = 1.0
	bottom_screen.anchor_bottom = 1.0

	# Reset margins to stretch correctly
	top_screen.margin_left = 0
	top_screen.margin_top = 0
	top_screen.margin_right = 0
	top_screen.margin_bottom = 0

	bottom_screen.margin_left = 0
	bottom_screen.margin_top = 0
	bottom_screen.margin_right = 0
	bottom_screen.margin_bottom = 0

# Function to set portrait layout
func set_portrait_layout():
	# Stack screens vertically and stretch to fill half of the screen each
	top_screen.anchor_left = 0.0
	top_screen.anchor_top = 0.0
	top_screen.anchor_right = 1.0
	top_screen.anchor_bottom = 0.5

	bottom_screen.anchor_left = 0.0
	bottom_screen.anchor_top = 0.5
	bottom_screen.anchor_right = 1.0
	bottom_screen.anchor_bottom = 1.0

	# Reset margins to stretch correctly
	top_screen.margin_left = 0
	top_screen.margin_top = 0
	top_screen.margin_right = 0
	top_screen.margin_bottom = 0

	bottom_screen.margin_left = 0
	bottom_screen.margin_top = 0
	bottom_screen.margin_right = 0
	bottom_screen.margin_bottom = 0

# Function to toggle between layouts
func toggle_layout():
	if top_screen.anchor_right == 0.5:
		set_portrait_layout()
	else:
		set_landscape_layout()

# Function to handle screen size changes
func _on_screen_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	if screen_size.x > screen_size.y:
		set_landscape_layout()
	else:
		set_portrait_layout()

# Function to handle input for toggling layout
func _input(event):
	if event.is_action_pressed("ui_toggle_layout"):
		toggle_layout()
