function array_join(array,sep) {
	var str = "";
	for (var i=0;i<array_length(array);i++) {
		str += string(array[i]);
		if (i+1<array_length(array)) {
			str += sep;
		}
	}
	return str;
}