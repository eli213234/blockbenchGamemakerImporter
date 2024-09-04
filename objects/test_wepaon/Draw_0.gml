/// @description Insert description here
// You can write your code in this editor
if(!pickedUp){
	matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, direction-90, 1, 1, 1));
	vertex_submit(modelBuffer, pr_trianglelist, sprite_get_texture(texture,0));
	matrix_set(matrix_world, matrix_build_identity());
}