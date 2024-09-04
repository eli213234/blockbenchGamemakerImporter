/// @description Insert sdescription here
// You can write your code in this editor


gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_alphatestenable(true);


game_set_speed(60,gamespeed_fps);


formatInd = setup_vertex_format();
idleIndex = 0;
walkIndex = 0;
model = load_fbx("character.fbx");

modelBuffer = create_model(model);
translations = model_add_translations(model);
animations = load_animations("character_animations.json", model, translations); 
anim_trans = animations_setup(translations,animations);

var xx = 0;
var yy = 0;
for(var i = 0; i < 1; i++){
	var merry = instance_create_depth(600-xx*40, 600-yy*40, depth, obj_npc);
	merry.model = model;
	merry.modelBuffer = modelBuffer;
	merry.translations = array_create(array_length(translations));
	array_copy(merry.translations, 0, translations,0, array_length(translations));
	merry.animations = anim_trans;
	merry.count = floor(random_range(0,5));
	merry.idleIndex= idleIndex;
	merry.walkIndex= walkIndex;
	if(xx > 8){
		xx = 0;
		yy++;
	}
	xx++;
}
model2 = load_fbx("dude.fbx");

modelBuffer2 = create_model(model2);
translations2 = model_add_translations(model2);
animations2 = load_animations("dude_animation.json", model2, translations2); 
anim_trans2 = animations_setup(translations2,animations2);

var player = instance_create_depth(400, 400, depth, obj_player);
player.model = model2;
player.modelBuffer = modelBuffer2;
player.translations = array_create(array_length(translations2));
array_copy(player.translations, 0, translations2,0, array_length(translations2));
player.animations = anim_trans2;
player.idleIndex= idleIndex;
player.walkIndex= walkIndex;



var weapon = instance_create_depth(450, 450, depth, test_wepaon,{
	model: load_fbx("weapons/test_weapon.fbx"),
	formatInd: formatInd,
});