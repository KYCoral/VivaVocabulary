extends CharacterBody2D

@export var blue: Color = Color("#4682b4")
@export var green: Color = Color("#639765")
@export var red: Color = Color("#a65455")

@export var speed: float = 0.5

@onready var prompt: RichTextLabel = $RichTextLabel
@onready var prompt_text: String = prompt.text

func _ready() -> void:
	prompt_text = PromptList.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))
	GlobalSignals.connect("difficulty_increased", self.handle_difficulty_increased)

func _physics_process(_delta: float) -> void:
	global_position.x -= speed

func set_difficulty(difficulty: int) -> void:
	handle_difficulty_increased(difficulty)

func handle_difficulty_increased(new_difficulty: int) -> void:
	var new_speed = speed + (0.2 * new_difficulty)
	speed = clamp(new_speed, speed, 3.0)

func get_prompt() -> String:
	return prompt_text

func set_next_character(next_character_index: int) -> void:
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""

	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index - 1) + get_bbcode_end_color_tag()

	prompt.parse_bbcode(set_center_tags(blue_text + green_text + red_text))

func set_center_tags(string_to_center: String) -> String:
	return "[center]" + string_to_center + "[/center]"

func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String:
	return "[/color]"
