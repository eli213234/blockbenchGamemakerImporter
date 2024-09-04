// Game Objects are invisible by default
gpu_set_cullmode(cull_clockwise);

if(setup){
	

	//have shader handle all transforms
	shader_set(shd_modelTranform);	
	shader_set_uniform_f( unialpha, 1);

	shader_set_uniform_f_array( unirot, translations[0]);
	shader_set_uniform_f_array(unitrans, translations[1]);
	shader_set_uniform_f_array( uniIds, translations[4]);

	//add translations
	
	matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, direction-90, 1, 1, 1));
	if(rightHandItem){
		with(rightHandItem ){
			vertex_submit(modelBuffer, pr_trianglelist, sprite_get_texture(texture,0));
		}
	}
	if(backItem){
		with(backItem ){
			vertex_submit(modelBuffer, pr_trianglelist, sprite_get_texture(texture,0));
		}
	}
	vertex_submit(modelBuffer, pr_trianglelist, sprite_get_texture(guy_texture,0));
	matrix_set(matrix_world, matrix_build_identity());

	shader_reset();

}
gpu_set_cullmode(cull_noculling);