/// @description 
if (keyboard_check_pressed(ord("1"))) {
	var _path = string_split(get_string("Path (separated by /'s)",""),"/");
	var field = obj_tester.client.firestore().collection(_path[0]);
	for (var i=1;i<array_length(_path);i++) {
		if (i mod 2 == 0) {
			field = field.collection(_path[i]);
		} else {
			field = field.document(_path[i]);
		}
	}
	show_message(json_stringify(field) + " - " + instanceof(field));
}

if (keyboard_check_pressed(ord("2"))) {
	var _path = string_split(get_string("Path (separated by /'s)",""),"/");
	var field = obj_tester.client.firestore().collection(_path[0]);
	for (var i=1;i<array_length(_path);i++) {
		if (i mod 2 == 0) {
			field = field.collection(_path[i]);
		} else {
			field = field.document(_path[i]);
		}
	}
	if (instanceof(field) != "FirestoreCollection") {
		return show_message("Not a collection");
	}
	field.list(function(result){
		show_message(json_stringify(result));
	});
}