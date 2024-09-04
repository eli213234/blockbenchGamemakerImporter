/// @description Move around
var key_left = keyboard_check( vk_left);
var key_right = keyboard_check( vk_right );
hRot = spd*( sign(key_left-key_right) );
if( instance_exists(obj_player)) {
	follow = obj_player;
	xTo += (follow.x-xTo)*0.30;
	yTo += (follow.y-yTo)*0.30;
	zTo += ((follow.z+(30))-zTo)*0.40;
}

var dirToFlo = rotateh;
dirToFlo =  point_direction(xTo,yTo,x,y);
goal = dirToFlo	+(hRot*2);	
var dd = angle_difference(rotateh,goal);
rotateh-= min(abs(dd), 100) * (sign(dd)/2);		
	
		
x = xTo + length3d_dir_x(cameradistance,rotatev,rotateh);
y = yTo + length3d_dir_y(cameradistance,rotatev,rotateh);
	
z = zTo + lengthdir_z(cameradistance, rotatev);
		



camera_set_view_mat(cam, matrix_build_lookat(x, y, z, xTo, yTo, zTo, 0, 0, 1));

