shader_type canvas_item;

uniform sampler2D s_gradient1 : source_color;
uniform sampler2D s_gradient2 : source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 gradient1 = texture(s_gradient1, UV);
	vec4 gradient2 = texture(s_gradient2, UV);
	color.a = min(min(gradient1.r, gradient2.r), color.a);
	COLOR = color;
}
