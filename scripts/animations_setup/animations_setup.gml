// as to allow game to run faster frame translations are premade
function animations_setup(baseTranslations,animations){
	var animation_translations = array_create(0);
	
	for(var an = 0; an < array_length(animations); an++){		
	
		var animation_length = animations[an, 1];
		var kframes = animations[an, 2];	
	
		var an_frame = array_create(0);
	
		for(var frame = 0; frame <= animation_length; frame+= (.10)){//reduce number to make more smooth
			var transl = array_create(array_length(baseTranslations[1]));
			array_copy(transl, 0, baseTranslations[1], 0, array_length(baseTranslations[1]));	
			
			var rote = array_create(array_length(baseTranslations[0]));
			array_copy(  rote, 0, baseTranslations[0], 0, array_length(baseTranslations[0]));	
			
			var klf = array_length(kframes);
			for(var i = 0; i < klf; i++){
				var nums = kframes[i, 1];
			
				var num = nums[0]*4;
				var len = array_length(kframes[i]);
				if( len > 3){
					var k = kframes[i, 3];					
					var fr = 0;					
					var ind = 0;
					var klen = array_length(k);
					for(var u = 0; u < klen; u++ ){
						fr = k[u, 0];
						ind = u;
						if( k[u, 0] >= frame){						
							break;
						}
					}
				
					var pind = ind-1;														
					
					if(pind<0){
						pind = klen-1;
					}
					var pfr = k[pind, 0];
					
					
					if(fr <= frame){
						var dif = 1;
					}else{
						var dif = (frame-pfr)/(fr-pfr);
					}
					var p  = k[ ind, 1];
					var p2 = k[pind, 1];
				}
				
				if(kframes[i, 0] == "position"){				
					if( len> 3){
						var xx = baseTranslations[1 ,  num] - p2[0];	
						var yy = baseTranslations[1 ,num+1] + p2[2];	
						var zz = baseTranslations[1 ,num+2] + p2[1];		
					
						var xx1 = baseTranslations[1 ,  num] - p[0];
						var yy1 = baseTranslations[1 ,num+1] + p[2];
						var zz1 = baseTranslations[1 ,num+2] + p[1];	
			
						var newX = xx + (xx1-xx)*dif;
						var newY = yy + (yy1-yy)*dif;
						var newZ = zz + (zz1-zz)*dif;
						
						
					}else{
						var ppp = kframes[i, 2];
						var newX = baseTranslations[1 ,  num ] - ppp[0];	
						var newY = baseTranslations[1 , num+1] + ppp[1];	
						var newZ = baseTranslations[1 , num+2] + ppp[2];	
					
					}
			//		if(newX > 30){
						
			//		}
					var nlen = array_length(nums);
					for(var n = 0; n< nlen; n++){
						var nu = nums[n]*4;											
					
						transl[ nu] = newX;
						transl[nu+1] = newY;
						transl[nu+2] = newZ;
					
					}	
				}else if(kframes[i, 0] == "rotation"){	
					
					if( len > 3){
						
						
						var xx = baseTranslations[0 ,num+2] - p2[0];	
						var yy = baseTranslations[0 ,num+1] + p2[2];	
						var zz = baseTranslations[0 ,num]   - p2[1];		
					
						var xx1 = baseTranslations[0 ,num+2] - p[0];
						var yy1 = baseTranslations[0 ,num+1] + p[2];
						var zz1 = baseTranslations[0 ,num]   - p[1];	
						
						var newX  = (pi/180) *( xx + (xx1-xx)*dif);
						var newY  = (pi/180) *( yy + (yy1-yy)*dif);
						var newZ  = (pi/180) *( zz + (zz1-zz)*dif);				
					
					}else{
						var ppp = kframes[i, 2];
					
						var newX = (pi/180) *(baseTranslations[0 ,num+2] - ppp[0]);	
						var newY = (pi/180) *(baseTranslations[0 ,num+1] + ppp[2]);	
						var newZ = (pi/180) *(baseTranslations[0 ,  num] - ppp[1]);	
						
						
					}
					var nlen = array_length(nums);
					for(var n = 0; n< nlen; n++){
						var nu = nums[n]*4;											
						
						rote[nu+2] = newX;
						rote[nu+1] = newY;
						rote[ nu] = newZ;						
					}		
				}
			}	
		
			var result = array_create(array_length(baseTranslations));
			array_copy(  result, 0, baseTranslations, 0, array_length(baseTranslations));	
			result[0] = rote;
			result[1] = transl;
			array_push(an_frame, [frame, result]);
	
			
		}
		array_push(animation_translations, [ animations[an, 0], animation_length, an_frame]);
	}
	
	return(animation_translations);
}