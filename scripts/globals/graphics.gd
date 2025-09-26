extends Node


func color_to_rgb_string(color: Color) -> String:
	
	var number_representation := color.to_rgba32()

	var string_representation := "%08x"
	
	string_representation = string_representation % number_representation
	
	var out = "#"
	for i in range(6):
		out += string_representation[i]
	
	return out
