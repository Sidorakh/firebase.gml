/// @description 
if (inst != noone) {
	if (keyboard_check(vk_delete)) {
		instance_destroy(inst);
		inst = noone;
	}
	return;
}
if (keyboard_check_pressed(ord("1"))) {
	inst = instance_create_layer(x,y,layer,obj_auth);
	return;
}
if (keyboard_check_pressed(ord("2"))) {
	inst = instance_create_layer(x,y,layer,obj_realtime_database);
	return;
	//show_message("Not here yet")
}
if (keyboard_check_pressed(ord("3"))) {
	inst = instance_create_layer(x,y,layer,obj_storage);
	return;
	//show_message("Not here yet")
}
if (keyboard_check_pressed(ord("4"))) {
	inst = instance_create_layer(x,y,layer,obj_firestore);
	return;
	//show_message("Not here yet")
}