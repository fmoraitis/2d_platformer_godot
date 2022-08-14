shader_type canvas_item;

uniform vec3 trail_color : source_color; // Edit as a color.

void fragment() {
vec4 texColor = texture(TEXTURE,UV);
 COLOR.rgba = vec4 (trail_color,texColor.a-0.5);
}