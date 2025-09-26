extends CanvasLayer

@export_color_no_alpha var text_color: Color
@export_color_no_alpha var bar_color: Color

# Memory values
var max_memory = 5
var current_memory = 3

# Input limits
var max_inputs = {"left": 5, "right": 5, "jump": 5}
var inputs_used = {"left": 2, "right": 1, "jump": 4}

# Glitch capacity
var max_glitches = 3
var glitches_used = 0

# Screen integrity
var screen_integrity = 10  

@onready var memory_bar: HBoxContainer = $MarginContainer/MemoryBar
@onready var left_display: RichTextLabel = $MarginContainer/InputDisplay/LeftDisplay
@onready var right_display: RichTextLabel = $MarginContainer/InputDisplay/RightDisplay
@onready var jump_display: RichTextLabel = $MarginContainer/InputDisplay/JumpDisplay
@onready var glitch_bar: HBoxContainer = $MarginContainer/GlitchBar
@onready var screen_integrity_display: RichTextLabel = $MarginContainer/ScreenIntegrity

var empty: String = "-" if (OS.get_name() == "Web") else "▢"
var full: String = "+" if (OS.get_name() == "Web") else "▣"

func _ready():
	update_ui()

func update_data(input_tracker: InputTracker):
	current_memory = input_tracker.memory
	max_memory = input_tracker.max_memories
	inputs_used["jump"] = input_tracker.jumps_used
	inputs_used["left"] = input_tracker.left_used
	inputs_used["right"] =  input_tracker.right_used
	glitches_used = input_tracker.glitches_used
	
	update_ui()

func update_ui():
	# prepare colors
	var text_color_string = Graphics.color_to_rgb_string(text_color)
	var bar_color_string = Graphics.color_to_rgb_string(bar_color)
	
	# Update memory bar
	var memory_display = ""
	for i in range(max_memory):
		memory_display +=  full if (i < current_memory) else empty
	memory_bar.get_child(0).text = "[color=" + text_color_string + "]MEMORY: [/color][color=" + bar_color_string + "]" + memory_display

	# Update inputs
	left_display.text = "[color=" + text_color_string + "]   ←: [/color][color=" + bar_color_string + "]" + _bar(max_inputs["left"] - inputs_used["left"], max_inputs["left"])
	right_display.text = "[color=" + text_color_string + "]   →: [/color][color=" + bar_color_string + "]" + _bar(max_inputs["right"] - inputs_used["right"], max_inputs["right"])
	jump_display.text = "[color=" + text_color_string + "]JUMP: [/color][color=" + bar_color_string + "]" + _bar(max_inputs["jump"] - inputs_used["jump"], max_inputs["jump"])

	# Update glitch bar
	var glitch_display = ""
	for i in range(max_glitches):
		glitch_display +=  full if (i < max_glitches - glitches_used) else empty
	glitch_bar.get_child(0).text = "[color=" + text_color_string + "]GLITCH: [/color][color=" + bar_color_string + "]" + glitch_display

	# Update screen integrity
	var blocks = int(screen_integrity * 10)
	var integrity_bar = "[color=" + text_color_string + "]SCREEN: [/color][color=" + bar_color_string + "]"
	for i in range(10):
		integrity_bar += "█" if (i < blocks) else "▁"
	screen_integrity_display.text = ""

func add_screen_integrity(amount: float):
	screen_integrity = clamp(screen_integrity + amount, 0, 10)
	update_glitch_shader()

func reduce_screen_integrity(amount: float):
	screen_integrity = clamp(screen_integrity - amount, 0, 10)
	update_glitch_shader()

func update_glitch_shader():
	var mat: ShaderMaterial = $ScreenGlitch.material
	mat.set_shader_parameter("corruption", (10-screen_integrity) / 10.0)

func _bar(filled: int, total: int) -> String:
	var out = ""
	for i in range(total):
		out += full if (i < filled) else empty
	return out
