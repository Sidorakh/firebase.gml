function FirebaseRealTimeDatabase(_app,_app_id,_database_url) constructor {
	app = _app;
	app_id = _app_id;
	url = _database_url + "/";
	changes = [];
	shadow = {};
	last_push_time = unix_timestamp();
	last_random_chars = [];
	change_queue = [];
	push_chars = "-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz"
	function load_local_copy() {
	
	}
	function get(path,callback){
		var current_user = app.auth().current_user;
		var _suffix = "";
		if (current_user != undefined) {
			_suffix = "?auth="+app.auth().auth_token;
		}
		var options = {
			callback: callback,
			path: string_split(path,"/"),
		}
		var _url = url+path+".json"+_suffix;
		http(_url,"GET","",options,function(status,result,options){
			var _result = {};
			try {
				_result = json_parse(result);
			} catch(e) {
				show_message(result);
			}
			// update the shadow copy
			if (string_char_at(string(status),1) == 2) {
				var field = shadow;
				for (var i=0;i<array_length(options.path)-1;i++) {
					if (!is_struct(field[$ options.path[i]])) {
						// if the GET succeeds, this is a map now
						field[$ options.path[i]] = {};
					}
					field = field[$ options.path[i]];
				}
				var index = array_length(options.path)-1;
				field[$ options.path[index]] = _result;
			}
			if (options.callback!=undefined) {
				options.callback(_result,status);
			}
		},function(status,result,options){
			// think this means the request couldn't get to the server
			// attempt to load from shadow
			var path = options.path;
			var found = false;
			var field = shadow;
			var i = 0;
			for (var i=0;i<array_length(path);i++) {
				try {
					field = field[$ path[i]];
				} catch(e) {
					if (options.callback != undefined) {
						return options.callback(undefined,"Field not found");
					}
				}
			}
			options.callback(field,false);
		});
	}
	
	function set(path,value,callback){
		var current_user = app.auth().current_user;
		var _suffix = "";
		if (current_user != undefined) {
			_suffix = "?auth="+app.auth().auth_token;
		}
		
		var options = {
			callback: callback
		}
		
		var split_path = string_split(path,"/");
		var field = shadow;
		show_message(split_path);
		for (var i=0;i<array_length(split_path)-1;i++) {
			if (!is_struct(field[$ split_path[i]])) {
				field[$ split_path[i]] = {};
			}
			field = field[$ split_path[i]];
		}
		field[$ split_path[array_length(split_path)-1]] = value;
		
		var _url = url+path+".json"+_suffix;
		http(_url,"PUT",value,options,function(status,result,options){
			var _result = json_parse(result);
			if (options.callback!=undefined) {
				options.callback(_result);
			}
			
		});
	}
	
	function update(path,value,callback){
		var current_user = app.auth().current_user;
		var _suffix = "";
		if (current_user != undefined) {
			_suffix = "?auth="+app.auth().auth_token;
		}
		var options = {
			callback: callback,
		}
		
		var split_path = string_split(path,"/");
		var field = shadow;
		show_message(split_path);
		for (var i=0;i<array_length(split_path)-1;i++) {
			if (!is_struct(field[$ split_path[i]])) {
				field[$ split_path[i]] = {};
			}
			field = field[$ split_path[i]];
		}
		var names = variable_struct_get_names(value);
		for (var i=0;i<array_length(names);i++) {
			field[$ split_path[array_length(split_path)-1]][$ names[i]] = value[$ names[i]];
		}
		
		
		
		var _url = url+path+".json"+_suffix;
		http(_url,"PATCH",value,options,function(status,result,options){
			var _result = json_parse(result);
			if (options.callback!=undefined) {
				options.callback(_result);
			}
		});
	}
	
	function push(path,value,callback){
		var current_user = app.auth().current_user;
		var _suffix = "";
		if (current_user != undefined) {
			_suffix = "?auth="+app.auth().auth_token;
		}
		var options = {
			callback: callback,
			path: path,
			value: value,
		}
		var _url = url+path+".json"+_suffix;
		http(_url,"POST",value,options,function(status,result,options){
			var _result = json_parse(result);
			if (options.callback!=undefined) {
				options.callback(_result);
			}
		},function(status,result,options){
			array_push(change_queue,{
				operation: "push",
				path: options.path,
				value: options.value,
			});
		});
	}
	
	function remove(path,callback){
		var current_user = app.auth().current_user;
		var _suffix = "";
		if (current_user != undefined) {
			_suffix = "?auth="+app.auth().auth_token;
		}
		var options = {
			callback: callback,
		}
		var _url = url+path+".json"+_suffix;
		http(_url,"DELETE","",options,function(status,result,options){
			var _result = json_parse(result);
			if (options.callback!=undefined) {
				options.callback(_result);
			}
		});
	}
	function dump_shadow() {
		shadow = {};
	}
	function next_push_id() {
		// According to Google..
		// Generate 72 bits of randomness, which gets turned
		// into 12 characters, and appended to the timstamp
		// https://github.com/firebase/firebase-js-sdk/blob/master/packages/database/src/core/util/NextPushId.ts#L52
		var now = unix_timestamp();
		var duplicate_time = (now == last_push_time);
		last_push_time = now;
		
		var timestamp_chars = [];
		var i;
		for (i=7;i>=0;i--) {
			timestamp_chars[i] = string_char_at(push_chars,(now % 64) + 1)
			now = floor(now/64);
		}
		var rtid = array_join(timestamp_chars);
		if (!duplicate_time) {
			for (i=0;i<12;i++) {
				last_random_chars[i] = floor(irandom(64));	
			}
		} else {
			for (i=11;i>=0 && last_random_chars[i]==63;i--) {
				last_random_chars[i] = 0;
			}
			last_random_chars[i] += 1;
			
		}
		for (i=0;i<12;i++) {
			rtid += string_char_at(push_chars,last_random_chars[i]+1);
		}
		
		return rtid;
	}
}