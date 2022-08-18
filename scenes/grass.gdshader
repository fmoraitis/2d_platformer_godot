shader_type canvas_item;
uniform float speed = 2;
uniform float amplitude = 1.1;
void vertex() {
	
	VERTEX.x += sin(TIME * speed) * amplitude *(UV.y-1.0);
	
}
