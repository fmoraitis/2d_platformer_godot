shader_type canvas_item;
uniform float speed = 2;
uniform float amplitude = 1.1;
void vertex() {
	if (UV.y<0.2){
	VERTEX.x += sin(TIME * speed) * amplitude *(UV.y-1.0);}
	else{VERTEX.x=VERTEX.x;}
}
