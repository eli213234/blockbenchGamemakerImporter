
count = 0;

z = 0;

frame = 0;
model_speed = 1;
animation_index = 0;
idleIndex = 0;
walkIndex = 0;

animation_length = 0;

unialpha = shader_get_uniform(shd_modelTranform, "alpha");
unirot   = shader_get_uniform(shd_modelTranform, "rotations");
unitrans = shader_get_uniform(shd_modelTranform, "translations");
uniIds  = shader_get_uniform(shd_modelTranform, "locationIDs");
setup = false;
basewalksp = 2;
walksp = 2;
moving = false;
previousAnime = 1

backItem = -1;
rightHandItem= -1;
nearItem = false;