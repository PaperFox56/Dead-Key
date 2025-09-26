shader_type canvas_item;

uniform float time;
uniform float intensity = 0.5;
uniform float glitch_speed = 10.0;
uniform float noise_size = 20.0;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float _noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
void fragment() {
	vec2 uv = FRAGCOORD.xy / noise_size;

	// Offset based on noise
	float noise = rand(UV + TIME);
	noise += _noise(UV + TIME);
	float _offset = (noise - 0.5) * 0.03 * intensity;

	// Horizontal noise offset
	float glitch = (fract(sin(dot(uv.xy ,vec2(12.9898,78.233))) * 43758.5453));
	float bar = step(0.9, sin(glitch_speed * TIME + uv.y * 10.0)) * glitch * intensity;

	// Color shift effect

	vec4 base_color = texture(TEXTURE, UV);
	vec2 offset = vec2(0.005 * bar + _offset, 0.0);

	vec4 r = texture(TEXTURE, UV + offset);
	vec4 g = texture(TEXTURE, UV);
	vec4 b = texture(TEXTURE, UV - offset);

	// Combine RGB with flicker
	COLOR.rgb = vec3(r.r, g.g, b.b) * (0.8 + bar * 0.4);
	COLOR.a = base_color.a * 0.9;  // Slightly transparent
}
