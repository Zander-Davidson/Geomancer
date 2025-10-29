shader_type canvas_item;

// declares a uniform color parameter with a default value
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 0.0);

void fragment() {
	// "mask" to select pink color of the spritesheet
	if (COLOR.b > 0.1 && COLOR.b < 1.0) {
		COLOR.rgb = tint_color.rgb;
	}
}
