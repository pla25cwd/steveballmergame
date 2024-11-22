shader_type canvas_item;

uniform sampler2D s_gradient_x : source_color;
uniform sampler2D s_gradient_y : source_color;

void fragment() {
	float rot = radians(90);
	vec4 color = texture(TEXTURE, UV);
	vec4 gradient1 = texture(s_gradient_x, UV);
	mat2 m = mat2( vec2( cos(rot), -sin(rot) ), vec2( sin(rot), cos(rot) ) );
	vec4 gradient2 = texture(s_gradient_y, m*UV);
	color.a = min(min(gradient1.r, gradient2.r), color.a);
	COLOR = color;
}
