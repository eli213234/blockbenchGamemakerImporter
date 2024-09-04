// this returns the key frame rotation and translation info
function load_animations(animationJson, model, translations){
	var buffer = buffer_load(animationJson)
    var json = buffer_read(buffer, buffer_text)
	
	var animap = ds_map_find_value(json_decode(json), "animations");
	var animArray = array_create(0);	
	
	var curAnim = ds_map_find_first(animap);
	var count = 0;
	while(curAnim != undefined){
		//animation order is not imported so you would need to do this to get the index
		if(curAnim == "Idle")
			idleIndex = count;
		if(curAnim == "walk")
			walkIndex = count;
		var info =  ds_map_find_value(animap, curAnim);
		var aniName = curAnim;
		var bones = ds_map_find_value(info, "bones");
		var animation_length = ds_map_find_value(info, "animation_length");
		var curbone = ds_map_find_first(bones);
		var kframes = array_create(0);	
		while(curbone != undefined){
				
			var p = findPart(model.parts,curbone);

			var b = ds_map_find_value(bones, curbone);
			var pos = ds_map_find_value(b,"position")
			var verts = array_create(0);
			for(var i = 0; i < array_length(translations[3]); i++){
				if(translations[3, i] == p.name){
					array_push(verts, i);
				}
			}					
			if(pos>=0){	
			
				if(ds_map_is_map(b ,"position")){
					var f= ds_map_find_first(pos);
					var kys = [];
					while(f != undefined){												
						array_push(kys, [real(f), ds_list_to_array(ds_map_find_value(pos, f))] );							
						f = ds_map_find_next(pos, f);								
					}
					kys = array_key_sort(kys, 0, array_length(kys)-1, true);										
							
					array_push(kframes, [ "position", verts, curbone,  kys]);
				}else{
					var xx = pos[|0];
					var yy = pos[|2];
					var zz = pos[|1];
						
					array_push(kframes, [ "position", verts, [xx, yy, zz] ]);
				}
					
					
			}
			var rot = ds_map_find_value(b,"rotation")
			if(rot>=0){
				if(ds_map_is_map(b ,"rotation")){
					var f= ds_map_find_first(rot);
					var kys = [];
					while(f != undefined){
														
						array_push(kys, [real(f), ds_list_to_array(ds_map_find_value(rot, f))] );
						f = ds_map_find_next(rot, f);						
					}		
					kys = array_key_sort(kys, 0, array_length(kys)-1, true);				
						
					array_push(kframes, [ "rotation", verts, curbone,  kys]);
				}else{
					var xx = rot[|0];
					var yy = rot[|1];
					var zz = rot[|2];
					array_push(kframes, [ "rotation", verts, [xx, yy, zz]]);
				}
					
			}
			curbone = ds_map_find_next(bones,curbone);
		}
		array_push(animArray, [ aniName, animation_length, kframes]);
		curAnim = ds_map_find_next(animap,curAnim);
		count++;
	}
	
	ds_map_destroy(animap);
	return(animArray);
}