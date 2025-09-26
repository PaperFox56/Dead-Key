shader_type canvas_item;

uniform float time_offset = 0.0;
uniform float strength = 1.0;
uniform bool glitch_active = false;

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
	vec2 uv = UV;

	if (glitch_active) {
		// Offset based on noise
		float noise = rand(UV + TIME + time_offset);
		noise += _noise(UV + TIME + time_offset);
		float offset = (noise - 0.5) * 0.03 * strength;

		// RGB split
		vec4 col_r = texture(TEXTURE, uv + vec2(offset, 0.0));
		vec4 col_g = texture(TEXTURE, uv);
		vec4 col_b = texture(TEXTURE, uv - vec2(offset, 0.0));

		COLOR = vec4(col_r.r, col_g.g, col_b.b, col_g.a);

		// Optional flicker
		if (noise > 0.95) {
			COLOR.rgb *= 0.3;
		}
	} else {
		COLOR = texture(TEXTURE, uv);
	}
}
