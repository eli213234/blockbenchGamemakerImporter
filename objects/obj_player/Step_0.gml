/// @description Insert description here
// slow
//translations = model_add_translations(model);
//var tors = findPart(model.parts, "upperBody");

anime();

var key_left  = keyboard_check( ord("A") );
var key_right = keyboard_check( ord("D") );
var key_up    = keyboard_check( ord("W") );
var key_down  = keyboard_check( ord("S") );

camdir = point_direction(obj_cam.x, obj_cam.y, x , y)-180;
moving = false;
if(key_up && !(key_left || key_right || key_down))	//up
{
	moving=true;
	direction = camdir-180;
}

if(key_up && key_right && !(key_left || key_down) )	//up right
{
	moving=true;
	direction = camdir-225;
}

if(key_right && !(key_up || key_down || key_left )) //right
{
	moving=true;
	direction = camdir-270;
}

if(key_down && key_right && !(key_up || key_left))	//down right
{
	moving=true;
	direction = camdir-315;
}

if(key_down && !(key_right || key_left || key_up))	//down
{
	moving=true;
	direction = camdir;
}

if(key_down && key_left && !(key_up || key_right))	//down left
{
		moving=true;
		direction = camdir-45;
}

if(key_left && !(key_down || key_up || key_right) ) //left
{
		moving=true;
		direction = camdir-90;
}

if(key_up && key_left && !(key_down || key_right))	//up left
{
		moving=true;
		direction = camdir-135;
}

if(moving){
	animation_index = walkIndex;
	
	model_speed = 3;
	
	walksp = lerp(walksp, basewalksp,.5);
}else{
	animation_index = idleIndex;
	model_speed = 1;
	
	walksp = lerp(walksp, 0, .5);
}
x += lengthdir_x(walksp, direction);
y += lengthdir_y(walksp, direction);	

var col = collision_circle(x,y,20, test_wepaon,false,true);
if(col && !col.pickedUp){
	nearItem = true;
	if(keyboard_check_pressed(ord("E"))){
		rightHandItem = col;
		col.pickedUp = true;
		var part = findPart(model.objects,"rightWeapon");
		with(col){
			var objs = model.objects;
			var num = part.number;
			for(var i = 0; i<array_length(objs); i++){
				objs[i].number = num;
			}	
			modelBuffer= update_model(modelBuffer, formatInd, model);
		}
		
	}
}else
	nearItem = false;
//switch	
if(keyboard_check_pressed(ord("C"))){
	if(rightHandItem){
		backItem = rightHandItem;
		var part = findPart(model.objects,"backWeapon");
		with(backItem){
			var objs = model.objects;
			var num = part.number;
			for(var i = 0; i<array_length(objs); i++){
				objs[i].number = num;
			}	
			modelBuffer= update_model(modelBuffer, formatInd, model);
		}
		rightHandItem = -1;
	}else if(backItem){
		rightHandItem = backItem;
		var part = findPart(model.objects,"rightWeapon");
		with(rightHandItem){
			var objs = model.objects;
			var num = part.number;
			for(var i = 0; i<array_length(objs); i++){
				objs[i].number = num;
			}	
			modelBuffer= update_model(modelBuffer, formatInd, model);
		}
		backItem = -1;
	}
}
//drop
if(keyboard_check_pressed(ord("V"))){
	if(rightHandItem){
		with(rightHandItem){
			pickedUp = false;
			x = other.x;
			y = other.y;
			z = other.z;
		}
		rightHandItem = -1;
	}else if(backItem){
		with(backItem){
			pickedUp = false;
			x = other.x;
			y = other.y;
			z = other.z;
		}
		backItem = -1;
	}
}