/// @description 
var _str = "";
_str += "1. Read from database\n";
_str += "2. Set path in database\n";
_str += "3. Update path in database\n";
_str += "4. Push data to database\n";
_str += "5. Delete entry in database\n";
_str += "6. Generate a bunch of Real-Time Database sequential ID's\n";

draw_text(4,32,_str);

draw_text(4,240,json_stringify(obj_tester.client.db().shadow));