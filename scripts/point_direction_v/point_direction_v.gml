/// @args x1 
/// @args y1
/// @args z1
/// @args x2 
/// @args y2
/// @args z2
function point_direction_v(argument0, argument1, argument2, argument3, argument4, argument5) {

	var x1 = argument0;
	var y1 = argument1;
	var z1 = argument2
	var x2 = argument3;
	var y2 = argument4;
	var z2 = argument5;
	var height = z2-z1; 

	var distance = point_distance(x1,y1,x2,y2);

	return( darctan2(height,distance) )


}
