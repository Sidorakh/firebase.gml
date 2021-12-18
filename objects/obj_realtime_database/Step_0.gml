/// @description 
if (keyboard_check_pressed(ord("1"))) {
	var _path = get_string("Path","");
	obj_tester.client.db().get(_path,function(result){
		show_message(result);
	})
}
if (keyboard_check_pressed(ord("2"))) {
	var _path = get_string("Path","");
	var _data = get_string("Data","");
	try {
		_data = json_parse(_data);
	} catch(e) {
		
	}
	obj_tester.client.db().set(_path,_data,function(result){
		show_message(result);
	})
}
if (keyboard_check_pressed(ord("3"))) {
	var _path = get_string("Path","");
	var _data = get_string("Data","");
	try {
		_data = json_parse(_data);
	} catch(e) {
		
	}
	obj_tester.client.db().update(_path,_data,function(result){
		show_message(result);
	})
}
if (keyboard_check_pressed(ord("4"))) {
	var _path = get_string("Path","");
	var _data = get_string("Data","");
	try {
		_data = json_parse(_data);
	} catch(e) {
		show_error(e,false)
	}
	obj_tester.client.db().push(_path,_data,function(result){
		show_message(result);
	})
}
if (keyboard_check_pressed(ord("5"))) {
	var _path = get_string("Path","");
	obj_tester.client.db().remove(_path,function(result){
		show_message(result);
	})
}