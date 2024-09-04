// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_model(model){
	
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, formatInd);


	for(var o = 0; o < array_length(model.objects); o++){
	
		var trans = array_create(0);
		findParents(trans, model.parts, model.objects[o].parent);
		
		var len = array_length(model.objects[o].polyVertexIndex);
		
		
		for(var f = 0; f < len; f++){
			
			for(var v = 0; v < array_length(model.objects[o].polyVertexIndex[f] )-1; v++){			
				modelAddVertexPoint(model.objects[o], vbuff, f, v, trans);
						
			}
			for(var v = 2; v < array_length(model.objects[o].polyVertexIndex[f] ); v++){			
				modelAddVertexPoint(model.objects[o], vbuff, f, v, trans);						
			}
			modelAddVertexPoint(model.objects[o], vbuff, f, 0, trans);		
		}
	}
	vertex_end(vbuff);
	vertex_freeze(vbuff);
	return(vbuff);
}
function setup_vertex_format(){
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_normal();
	vertex_format_add_color();
	vertex_format_add_texcoord();
	vertex_format_add_custom(vertex_type_float1, vertex_usage_blendindices);
	var form = vertex_format_end();
	return(form);
}
function update_model(modelBuffer, format, model){
	
	if(buffer_exists(modelBuffer)){
		buffer_delete(modelBuffer);
	}
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, format);

	for(var o = 0; o < array_length(model.objects); o++){
	
		var trans = array_create(0);
		findParents(trans, model.parts, model.objects[o].parent);
		
		var len = array_length(model.objects[o].polyVertexIndex);
		
		
		for(var f = 0; f < len; f++){
			
			for(var v = 0; v < array_length(model.objects[o].polyVertexIndex[f] )-1; v++){			
				modelAddVertexPoint(model.objects[o], vbuff, f, v, trans);
						
			}
			for(var v = 2; v < array_length(model.objects[o].polyVertexIndex[f] ); v++){			
				modelAddVertexPoint(model.objects[o], vbuff, f, v, trans);						
			}
			modelAddVertexPoint(model.objects[o], vbuff, f, 0, trans);		
		}
	}
	vertex_end(vbuff);
	vertex_freeze(vbuff);
	return(vbuff);
}
function model_add_translations(model){
	var rotations = array_create(0);
	var transl = array_create(0);
	var names = array_create(0);
	var idsLocs = array_create(0);
	var number = 0;
	for(var o = 0; o < array_length(model.objects); o++){

		var trans = array_create(0);
		
		findParents(trans, model.parts, model.objects[o].parent);
		
		var startId = number;
		var endId = number;
		var num = model.objects[o].number;
		for(var i = 1; i<array_length(trans); i++){
		
			if(string_copy(trans[i].name,1,3) == "bn_"){
				var currTrans = [trans[i].name, trans[i].translation, trans[i].rotation];
				
				array_push(transl, currTrans[1, 0]);
				array_push(transl, currTrans[1, 2]);
				array_push(transl, currTrans[1, 1]);
				array_push(transl, num);
				
				array_push(rotations, (pi/180) * currTrans[2, 1]);
				array_push(rotations, (pi/180) * currTrans[2, 2]);
				array_push(rotations, (pi/180) * currTrans[2, 0]);			
				array_push(rotations, num );
				endId++;
				number++;
				array_push(names, trans[i].name);
				show_debug_message(trans[i].name)
			}
		}
		array_push(idsLocs, startId);
		array_push(idsLocs, endId-1);
	}

	return([rotations, transl, number, names, idsLocs]);
}
function modelAddVertexPoint(model_object, vbuffer, f, v, trans){
	var vert = model_object.polyVertexIndex[f, v];
			
	var xx = model_object.vertices[vert, 0] ;
	var yy = model_object.vertices[vert, 2] ;
	var zz = model_object.vertices[vert, 1] ;

	for(var i = 0; i< array_length(trans); i++){
		if(string_copy(trans[i].name,1,3) != "bn_"){
			var _x = xx;   
			var _y = yy;   
			var _z = zz; 
			var currTrans = [trans[i].name, trans[i].translation, trans[i].rotation];
			var angx = currTrans[2, 0];		
			var angy = currTrans[2, 2];
			var angz = currTrans[2, 1];
		
		
			var t_matrix = matrix_build(0, 0, 0, angx, 0, 0, 1, 1, 1);
			var verts = matrix_transform_vertex(t_matrix, _x, _y, _z);		
			var t_matrix = matrix_build(0, 0, 0, 0, 0, angz, 1, 1, 1);
			var verts = matrix_transform_vertex(t_matrix, verts[0], verts[1], verts[2]);
			var t_matrix = matrix_build(0, 0, 0, 0, angy, 0, 1, 1, 1);
			var verts = matrix_transform_vertex(t_matrix, verts[0], verts[1], verts[2]);
		
			xx   = verts[0] + currTrans[1, 0];		
			yy   = verts[1] + currTrans[1, 2];			
			zz   = verts[2] + currTrans[1, 1];
		}
	}
	var tex  = model_object.uvs[f, v];
	var xtex = tex[0];
	var ytex = tex[1];
				
	var nx   = model_object.normals[f, 0];
	var ny   = model_object.normals[f, 2];
	var nz   = model_object.normals[f, 1];		

	vertex_point_add(vbuffer, xx, yy, zz, nx, ny, nz, c_white, 1, xtex, ytex);

	vertex_float1(vbuffer, model_object.number );
	//alpha is used for the id
	//}
}

function findParents(array, parts, id_num){
	
	for(var i = 0; i< array_length(parts); i++){
	//	show_debug_message([parts[i].idNumber )
		if(parts[i].idNumber == id_num){
			array_push(array,parts[i] );
			return(findParents( array, parts, parts[i].parent) );			
		}
	}
	return(array);
}