direction = 0;
pitch = 20;
rotatev = pitch;
rotateh = direction;
spd = 2;
//
z = 50;
xTo=x;
yTo=y;
zTo=0;
goal =0;
cameradistance = 100;
follow = noone;
hRot = 0;
vRot = 0;

cam = camera_create();
view_set_camera(0,cam);
camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));