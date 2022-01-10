/// @description 
var _str = "Press a key: \n";
_str += "1. Log in (email)\n";
_str += "2. Register (email)\n";
_str += "3. Save to File\n";
_str += "4. Load from File\n";
_str += "5. Log out";
draw_text(4,32,_str);

draw_text(32,256,json_stringify(obj_tester.client.auth().token));