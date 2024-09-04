// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function anime(){
	if(! setup){
		baseTranslations =  array_create(array_length(translations));
		array_copy(baseTranslations,0,translations,0, array_length(translations ) );
		animation_index = idleIndex;
		previousAnime = idleIndex;
		animation_length = animations[animation_index, 1];
		kframes = animations[animation_index, 2];
		setup = true;
		
		
	}
	if(previousAnime != animation_index){
		animation_length = animations[animation_index, 1];
		kframes = animations[animation_index, 2];		
		previousAnime = animation_index;
		frame = 0;
	}
	if(animation_length){
		frame = frame+ ((model_speed/room_speed)*1);
		if(frame > animation_length){
			frame-= animation_length;
		}
		
		var f = floor(frame*10);
		translations =  kframes[f,1];		
	}
	
}