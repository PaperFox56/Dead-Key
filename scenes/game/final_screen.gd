extends Prelevel


func _ready():
	set_text("Seriously, you actually finished the game ? Why ? Okay... I guess... Thanks.")
	continue_label.visible = false
	text_box.clear()
	start_typewriter()

func _unhandled_input(event):
	if char_index >= full_text.length() and event.is_pressed() and continue_label.visible:
		continue_label.visible = false
		#anim.play("fade_out")
		#await anim.animation_finished
		get_tree().change_scene_to_file("res://scenes/game/credits_screen.tscn")

# In GDScript, update time:
func _process(delta):
	$Panel.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
