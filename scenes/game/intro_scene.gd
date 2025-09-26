extends CanvasLayer

@onready var text_box := $MarginContainer/InfoText
@onready var continue_label := $ContinueLabel

var full_text := [
	"Hello, how are you ? Seems you're here for some play...",
	"That's why you're here right ?",
	"Euh.. Anyways, I recently played a game and I think I left some of my memories behind",
	"Would you help me retrieve them ?",
	"Beware, as the developper was the worst, the game runs on limited memory and your inputs are limited...",
	"Also, it's full of bugs... maybe you can make use of that"
]
var text_index := 0
var char_index := 0
var type_speed := 0.1

var finished: bool = false

func _ready():
	text_box.clear()
	start_typewriter()

func start_typewriter():
	char_index = 0
	text_box.clear()
	_type_next_char()
	if text_index == full_text.size() -1:
		finished = true

func _type_next_char():
	if char_index < full_text[text_index].length():
		var char = full_text[text_index][char_index]
		text_box.add_text(char)
		char_index += 1
		await get_tree().create_timer(type_speed).timeout
		_type_next_char()
	else:
		continue_label.visible = true

func _unhandled_input(event):
	if char_index >= full_text[text_index].length() and event.is_pressed()\
			and continue_label.visible:
		continue_label.visible = false
		if finished:
			GameManager.show_briefing("level_1")
		else:
			text_index += 1
			start_typewriter()



# In GDScript, update time:
func _process(delta):
	$Panel.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
