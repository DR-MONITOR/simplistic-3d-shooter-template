shader_type sky;

uniform sampler2D nebula_image;
uniform float x_tiles = 1.0;
uniform float y_tiles = 1.0;
uniform float pole_fading = 3.0;
uniform float transparency = 1.0;

void sky() {
	vec2 texture_coords = vec2(
		SKY_COORDS.x * x_tiles + 0.25, // longitude
		SKY_COORDS.y * y_tiles // latitude
	);
	vec3 nebula_color = texture(nebula_image, texture_coords).rgb;
	
	// hide the poles
	float pole_distance = cos(abs(EYEDIR.y) * PI * 0.5);
	float pole_opacity = clamp(pow(pole_distance, pole_fading), 0.0, 1.0);
	
	COLOR = nebula_color * pole_opacity * transparency;
}
