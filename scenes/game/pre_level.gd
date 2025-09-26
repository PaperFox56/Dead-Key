extends CanvasLayer
class_name Prelevel

@onready var text_box := $MarginContainer/InfoText
@onready var continue_label := $ContinueLabel
@onready var anim := $AnimationPlayer

var full_text := "etgrsegsgre"
var char_index := 0
var type_speed := .05 

func set_text(new_text: String):
	full_text = new_text
	start_typewriter()

func _ready():
	continue_label.visible = false
	text_box.clear()
	if full_text != "":
		start_typewriter()

func start_typewriter():
	char_index = 0
	text_box.clear()
	_type_next_char()

func _type_next_char():
	if char_index < full_text.length():
		var char = full_text[char_index]
		text_box.add_text(char)
		char_index += 1
		await get_tree().create_timer(type_speed).timeout
		_type_next_char()
	else:
		continue_label.visible = true

func _unhandled_input(event):
	if char_index >= full_text.length() and event.is_pressed() and continue_label.visible:
		continue_label.visible = false
		#anim.play("fade_out")
		#await anim.animation_finished
		GameManager.load_level(GameManager.current_level)
		queue_free()



# In GDScript, update time:
func _process(delta):
	$Panel.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
