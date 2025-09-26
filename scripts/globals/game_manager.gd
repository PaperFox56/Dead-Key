extends Node

# For global access
var current_level := ""
var corruption := 0.0
var memory_total := 10
var memory := 0

var use_glitch: bool = false

# Level metadata
var levels := {
	"level_1": {
		"name": "Startup",
		"unlocked": true,
		"completed": false,
		"shard": false,
		"briefing_text": "Follow the instructions and enjoy",
	},
	"level_2": {
		"name": "Divergence",
		"unlocked": false,
		"completed": false,
		"shard": false,
		"briefing_text": "What is a wall ?",
	},
	"level_3": {
		"name": "Recorder",
		"unlocked": false,
		"completed": false,
		"shard": false,
		"briefing_text": "A very simple level don't worry",
	},
	"level_4": {
		"name": "Echo",
		"unlocked": false,
		"completed": false,
		"shard": false,
		"briefing_text": "Level 3 but harder",
	},
	"level_5": {
		"name": "Amnesia",
		"unlocked": false,
		"completed": false,
		"shard": false,
		"briefing_text": "Forget everything",
	}
}

var sound_manager: AudioStreamPlayer

func _ready() -> void:
	sound_manager = load("res://scenes/audio/sound_manager.tscn").instantiate()
	add_child(sound_manager)
	

func load_level(level_id: String):
	if not levels.has(level_id):
		print("Level not found: ", level_id)
		return
	current_level = level_id
	var scene_path = "res://scenes/game/levels/"+level_id+".tscn"
	call_deferred("load_scene", scene_path)

func load_scene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)

func show_briefing(level_id: String):
	current_level = level_id
	var briefing_scene = load("res://scenes/game/pre_level.tscn").instantiate()
	get_tree().root.add_child(briefing_scene)
	briefing_scene.set_text(levels[level_id].briefing_text)

func complete_current_level():
	if !levels[current_level].completed:
		memory += 2
	if levels.has(current_level):
		levels[current_level].completed = true
		_unlock_next_level(current_level)

func _unlock_next_level(level_id: String):
	var keys = levels.keys()
	var index = keys.find(level_id)
	if index != -1 and index + 1 < keys.size():
		var next_id = keys[index + 1]
		levels[next_id].unlocked = true

func reset_progress():
	for key in levels.keys():
		levels[key].completed = false
		levels[key].unlocked = key == "level_1"
	memory = 0
	
func toggle_glitch_effect(toggled_on: bool) -> void:
	use_glitch = toggled_on
	RenderingServer.global_shader_parameter_set("glitch_active", toggled_on)
