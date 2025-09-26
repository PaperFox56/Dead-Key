shader_type canvas_item;

uniform bool glitch_active;

uniform float time_offset = 0.0;
uniform float _strength = 1.0;
uniform bool horizontal_lines = false;
uniform float noise_size = 20.0;
uniform float corruption = 0.0; // from 0.0 (clean) to 1.0 (broken)
uniform float noise_intensity = 1.0;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

float rand(vec2 co) {
	float a = fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	return a * fract(cos(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void fragment() {
	vec2 uv = SCREEN_UV;// Warp only if corruption is strong
	vec4 final_color = vec4(0.0);

	float strength = 0.0;
	if (glitch_active) {
		strength = _strength * corruption * .01;
	} else {
		strength = 0.0;
	}
	//if (glitch_active) {
	if (strength > 0.0) {
		float noise = rand(uv + TIME + time_offset) * noise_intensity;
		//float offset = (noise - 0.5) * 0.01 * strength;
		float offset = (noise - 0.5) * 0.01 * (strength + corruption * 5.0);
		if (corruption > 0.7 && fract(UV.y * 20.0 + TIME * 30.0) < 0.05) {
			final_color.rgb *= 0.5;
		}
		// Hue/saturation/contrast tweaks based on corruption
		//final_color.rgb = mix(final_color.rgb, vec3(dot(final_color.rgb, vec3(0.33))), corruption * 0.3); // desaturate
		//final_color.rgb *= 1.0 + corruption * 0.5; // boost contrast
		//final_color.rgb = pow(final_color.rgb, vec3(1.0 - corruption * 0.4)); // gamma shift
		// RGB split
		vec4 col_r = texture(SCREEN_TEXTURE, uv + vec2(offset, 0.0));
		vec4 col_g = texture(SCREEN_TEXTURE, uv);
		vec4 col_b = texture(SCREEN_TEXTURE, uv - vec2(offset, 0.0));

		final_color = vec4(col_r.r, col_g.g, col_b.b, 1.0);

		// Horizontal noise offset
		if (horizontal_lines) {
			uv *= noise_size;
			float glitch = (fract(sin(dot(uv.xy ,vec2(12.9898,78.233))) * 43758.5453));
			float bar = step(0.9, sin(5.0 * TIME + uv.y * 10.0)) * glitch * .5 * (glitch_active?1.0:0.0);
			final_color.rgb *= bar +1.0;
			uv /= noise_size;
		}
		// Random flicker lines
		if (noise > 0.95) {
			final_color.rgb *= 0.1;
		}
	} else {
		final_color = texture(SCREEN_TEXTURE, uv);
	}
	
	float r = length(UV-vec2(.5, .5));
	final_color.a = exp(-5.0*r*r);
	
	COLOR = final_color;
}
