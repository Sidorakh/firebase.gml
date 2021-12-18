/// @description 
if (keyboard_check_pressed(ord("1"))) {
	var _rp = get_string("Remote path","");
	var _file = get_open_filename("","");
	obj_tester.client.storage().put_file(_rp,_file,{},function(result){
		show_message(result);
	});
}

if (keyboard_check_pressed(ord("2"))) {
	var _rp = get_string("Remote path","");
	var _lf = get_save_filename("","");
	obj_tester.client.storage().get_file(_rp,_lf,{},function(result){
		show_message(result);
	});
}