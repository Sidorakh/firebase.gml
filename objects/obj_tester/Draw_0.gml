/// @description 
if (inst == noone) {
	var _str = "Select a library:\n";
	_str += "1. Firebase Auth\n";
	_str += "2. Firebase Real-Time Database\n";
	_str += "3. Firebase Storage\n";
	_str += "4. Firestore\n";
	_str += "5. Test download\n";
	draw_text(4,4,_str);
	return;
}
var _off = 4;
if (keyboard_check(vk_space)) {
	_off = 4.5;	
}
draw_text(_off,_off,"Press DEL to return to menu");