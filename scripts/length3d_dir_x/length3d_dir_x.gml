/// @args radius
/// @args Vdir 
/// @args Hdir 
function length3d_dir_x(argument0, argument1, argument2) {

	var radius = argument0;
	var Vdir = argument1;
	var Hdir = argument2;
	return(  radius*dcos(Vdir)*dcos(-Hdir));



}
