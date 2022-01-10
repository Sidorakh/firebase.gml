/// @description 
if (keyboard_check_pressed(ord("1"))) {
	var email = get_string("Email","");
	var password = get_string("Password","");
	obj_tester.client.auth().login_password(email,password,function(user,error){
		if (error != undefined) {
			show_message(error);	
		}
		show_message("Login: " + json_stringify(user));
		clipboard_set_text(obj_tester.client.auth().auth_token);
		
	});
}
if (keyboard_check_pressed(ord("2"))) {
	var email = get_string("Email","");
	var password = get_string("Password","");
	obj_tester.client.auth().register_password(email,password,function(user,error){
		if (error != undefined) {
			show_message(error);	
		}
		show_message("Register: " + json_stringify(user));
	});
}
if (keyboard_check_pressed(ord("3"))) {
	obj_tester.client.auth().save_to_file("firebase.auth");
}
if (keyboard_check_pressed(ord("4"))) {
	obj_tester.client.auth().load_from_file("firebase.auth");
}