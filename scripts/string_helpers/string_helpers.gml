function string_split(str,sep) {
	var results = [];
	repeat (string_count(sep,str)) {
		var pos = string_pos(sep,str);
		var left = string_copy(str,1,pos-1);
		var right = string_copy(str,pos+1,string_length(str)-(pos));
		array_push(results,left);
		str = right;
	}
	array_push(results,str);
	
	return results;
}