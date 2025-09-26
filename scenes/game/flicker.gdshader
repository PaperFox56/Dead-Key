shader_type canvas_item;

uniform float time;
uniform vec4 base_color : source_color = vec4(1.0);

void fragment() {
	float flicker = step(0.85, fract(sin(UV.x * 15.0 + time * 5.0) * 43758.5453));
	vec3 glitch_color = base_color.rgb + vec3(flicker * 0.3, 0.0, flicker * 0.4);
	COLOR = vec4(glitch_color, base_color.a);
}


