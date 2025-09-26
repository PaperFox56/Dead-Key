shader_type canvas_item;

uniform float opacity;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, UV) * opacity;
}
