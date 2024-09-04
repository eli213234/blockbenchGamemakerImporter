/// @param filename
function load_fbx(argument0) {

	// Open the file
	var filename = argument0;
	var fbx_file = file_text_open_read(filename);

	// Create the vertex buffer
	//vertex_create_buffer();
//	vertex_begin(model, Camera.format);
	var model ={
		objects : [],
		parts: [],
	};
	

	var previLine = "";
	var currentIndex = 0;
	var currentIndex1 = 0;
	while(not file_text_eof(fbx_file)){
		var line = file_text_read_string(fbx_file);
		file_text_readln(fbx_file);
		// Split each line around the space character
		var terms, index, term;
		index = 0;
		terms = array_create(string_count(line, " ") + 1, "");
		term = "";
		for (var i = 1; i <= string_length(line); i++){
			if (string_char_at(line, i) != "	"){
				
				term += string_char_at(line, i);
			}
		}
		
		if(string_copy(term, 1, 9) == "Geometry:"){
			
			var num = int64( string_copy(term, 10, 9));
			var bk1 = 0;
			var bk2 = 0;
			for (var i = 17; i <= string_length(term); i++){
				if (string_char_at(line, i) == ":"){
					bk1 = i;
				}
				if (string_char_at(line, i) == ","){
					bk2 = i-2;
				
				}
			}
			currentIndex++;
			var nam = string_copy(term, bk1, bk2-bk1);
			var mesh = {
				number: currentIndex, 
				name : nam, 
				idNumber : num,
				visable: true,
				vertices : [[]],
				polyVertexIndex : [[]], 
				normals : [[]],
				uvs : [[[]]],
				parent : -1,
				flat: false,
			};
			
			array_push(model.objects, mesh)
			
		}
		if(string_copy(term, 1, 6) == "Model:"){
			var num = int64( string_copy(term, 7, 9));
			var bk1 = 0;
			var bk2 = 0;
			for (var i = 17; i <= string_length(term); i++){
				if (string_char_at(line, i) == ":"){
					bk1 = i;
				}
				if (string_char_at(line, i) == ","){
					bk2 = i-2;
				
				}
			}
			currentIndex1++;
			var nam = string_copy(term, bk1, bk2-bk1);
			var prop = {
				number: currentIndex1, 
				name : nam, 
				idNumber : num,
				visable: true,
				translation : [],
				rotation : [], 
				parent : -1,
				children : [],
				
			};
			
			array_push(model.parts, prop)
			
		}
		//check line thing
		//above because on line
		if(currentIndex1 > 0){
			if(string_copy(term, 5, 15) == "Lcl Translation"){
				previLine = "tr";			
			}
			if(string_copy(term, 5, 12) == "Lcl Rotation"){
				previLine = "ro";		
				
			}
			if(string_copy(term, 0, 7) == ";Model:"){ //four uv for each face
				previLine = "co";
			}
		}
		
		
	//	if(previLine != ""){
			for (var i = 1; i <= string_length(term); i++){
				if (string_char_at(term, i) == " " || string_char_at(term, i) == "," ){
					index++;
					terms[index] = "";
				} else {
					terms[index] += string_char_at(term, i);
				}
			}
			
//		}
		if(string_copy(term, 0, 2) == "C:" ){ //four uv for each face
			var str = string_copy(terms[1], 2, 2);
		
			if(str == "OO" ){
				var parStri = terms[array_length(terms)-1];
				var chiStri = terms[array_length(terms)-2];
				var father = int64(parStri);
				var son    = int64(chiStri);
				var parto = findModelPart(model, father);
				if(parto[0]>=0){
					var pind = parto[1];
					if(parto[0]== 0){
						array_push(model.parts[pind].children, son);	
					}else{
						array_push(model.objects[pind].children, son);	
					}
					var cparto  = findModelPart(model, son);
					if(cparto[0]>=0){
						var cind = cparto[1];
						if(cparto[0]==0){
							model.parts[cind].parent = father; 
						}else{
							model.objects[cind].parent = father; 
						}
						
					}
				}
			}
		}
		var xx = 0;
		var yy = 0;
		var uu = 0;
		
		for(var u = 1; u< array_length(terms); u++){
			switch(previLine){
				case "v":{						
					model.objects[currentIndex-1].vertices[yy, xx] = real(terms[u]);
					xx++;
					if(xx >= 3){
						xx = 0;
						yy++;						
					}
							
				}break;
				case "n":{						
					model.objects[currentIndex-1].normals[yy, xx] = real(terms[u]);
					xx++;
					if(xx >= 3){
						xx = 0;
						yy++;						
					}							
				}break;
				case "p":{	
					var polver = real(terms[u]);
					if(polver < 0){
						polver = abs(polver)-1
					}
					model.objects[currentIndex-1].polyVertexIndex[yy, xx] = polver;
					xx++;
					if(xx >= 4){
						xx = 0;
						yy++;						
					}							
				}break;
				case "u":{	
					uu++;
					if(uu>=2){
						model.objects[currentIndex-1].uvs[yy, xx] = [real(terms[u-1]), real(terms[u])];
						uu = 0;
						xx++;
						if(xx >= 4){
							xx = 0;
							yy++;						
						}
					}
					
				}break;
				
			}
		}
	/*	if(previLine == "v"){//make some flat
			var lx =  infinity;
			var ly =  infinity;
			var lz =  infinity;
			
			var gx = -infinity;
			var gy = -infinity;
			var gz = -infinity;
			for(var i = 0; i<array_length(model.objects[currentIndex-1].vertices); i++ ){
				if( model.objects[currentIndex-1].vertices[i, 0] < lx){
					lx = model.objects[currentIndex-1].vertices[i, 0] 
				}
				if( model.objects[currentIndex-1].vertices[i, 2] < ly){
					ly = model.objects[currentIndex-1].vertices[i, 2] 
				}
				if( model.objects[currentIndex-1].vertices[i, 1] < lz){
					lz = model.objects[currentIndex-1].vertices[i, 1] 
				}
				
				if( model.objects[currentIndex-1].vertices[i, 0] > gx){
					gx = model.objects[currentIndex-1].vertices[i, 0] 
				}
				if( model.objects[currentIndex-1].vertices[i, 2] > gy){
					gy = model.objects[currentIndex-1].vertices[i, 2] 
				}
				if( model.objects[currentIndex-1].vertices[i, 1] > gz){
					gz = model.objects[currentIndex-1].vertices[i, 1] 
				}
			}
			if( (gx-lx) == 0 || (gy-ly) == 0|| (gz-lz) == 0){
				model.objects[currentIndex-1].flat = true;
			}
		}*/
		for(var u = array_length(terms)-3; u< array_length(terms); u++){
			switch(previLine){
				case "tr":{					
					model.parts[currentIndex1-1].translation[xx] = real(terms[u]);
					xx++;
				}break;
				case "ro":{
				
					model.parts[currentIndex1-1].rotation[xx] = real(terms[u]);
					xx++;
				}break;
			}
		}
		
		
		previLine = "";
		if(string_copy(term, 1, 9) == "Vertices:"){
			previLine = "v";
		}
		if(string_copy(term, 1, 19) == "PolygonVertexIndex:"){//contain faces
			previLine = "p";
		}
		if(string_copy(term, 1, 8) == "Normals:"){ //one normal for each face
			previLine = "n";
		}
		if(string_copy(term, 1, 3) == "UV:"){ //four uv for each face
			previLine = "u";
		}
		
	}	

	file_text_close(fbx_file);

	return model;

}
function findPart(parts, name){
	
	for(var i = 0; i< array_length(parts); i++){
		if(parts[i].name == name){
			
			return(parts[i]);
		}
	}
	
	return(-1);
}
function findModelPart(model, id_num){
	var parts = model.parts;
	var objects = model.objects;
	for(var i = 0; i< array_length(parts); i++){
		if(parts[i].idNumber == id_num){
			
			return([0, i]);
		}
	}
	for(var i = 0; i< array_length(objects); i++){
		if(objects[i].idNumber == id_num){
			
			return([1, i]);
		}
	}
	return([-1]);
}
function findPartIndex(parts, id_num){
	
	for(var i = 0; i< array_length(parts); i++){
		if(parts[i].idNumber == id_num){
			
			return(i);
		}
	}
	return(-1);
}
function findPartIndexName(parts, name){
	
	for(var i = 0; i< array_length(parts); i++){
		if(parts[i].name == name){
			
			return(i);
		}
	}
	return(-1);
}