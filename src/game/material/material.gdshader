// NOTE: Shader automatically converted from Godot Engine 3.4.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;

uniform vec4 outline_color : hint_color = vec4(vec3(0.0), 1.0);
uniform float outline_thickness : hint_range(0.005, 0.1, 0.001) = 0.01;

float outline(sampler2D tex, vec2 uv)
{
	float thick = outline_thickness;
	float a = 1.0;
	
	for (float x = -2.0; x < 1.01; x += 1.0)
	{
		for (float y = -1.0; y < 1.01; y += 1.0)
		{
			float pa = texture(tex, uv + vec2(x, y) * thick).a;
			a *= pa;
		}
	}
	
	return 1.0 - a;
}

void fragment()
{
	vec4 base_color = texture(TEXTURE, UV);
	float out_weight = outline(TEXTURE, UV);
	base_color.rgb = mix(base_color, outline_color, out_weight * (outline_color.a)).rgb;
	COLOR = base_color;
}