// array sorts base of the first value

function array_key_sort( array , low, high, ascending){  

	if (low < high)  {
        /* pi is partitioning index, arr[pi] is now
           at right place */
		var par = partition(array, low, high, ascending);
		array = par[1]
		array_key_sort(array, low, par[0] - 1, ascending);  // Before pi
		array_key_sort(array, par[0] + 1, high, ascending); // After pi
    }

   return( array);
} 
function partition( array , low, high, ascending){
	    // pivot (Element to be placed at right position)
	var  pivot = array[high, 0];  
 
    var i = (low - 1)  // Index of smaller element and indicates the 
                   // right position of pivot found so far

    for (var j = low; j <= high- 1; j++)
    {
        // If current element is smaller than the pivot
		var check = false;
		if(ascending)
			check = array[j, 0] < pivot;
		else
			check = array[j, 0] > pivot;
        if(check)
        {
            i++;    // increment index of smaller element
            var temp  = array[ i ];
			array[ i] = array[ j];
			array[ j] = temp;
        }
    }
	var temp  = array[ i + 1];
	array[ i + 1] = array[ high];
	array[ high] = temp;
    
    return ([i + 1, array]);
}