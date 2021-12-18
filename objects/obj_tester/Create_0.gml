/// @description 
var buff = buffer_load("firebase.json");
var options = json_parse(buffer_read(buff,buffer_text));
client = new FirebaseClient(options);

inst = noone;