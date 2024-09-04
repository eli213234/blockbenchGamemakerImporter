// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ds_list_to_array(list){
	var size = ds_list_size(list);
	var arr = array_create(size);
	for(var i = 0; i < size; i++) {
		arr[i] = list[| i];
	}
	return(arr);

}