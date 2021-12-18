function FirebaseRealTimeDatabase(_app,_app_id,_database_url) constructor {
	app = _app;
	app_id = _app_id;
	url = _database_url + "/";
	
	function get(path,callback){
		var current_user = app.auth().current_user;
		var _suffix = "";
		if (current_user != undefined) {
			_suffix = "?auth="+app.auth().auth_token;
		}
		var options = {
			callback: callback,
		}
		var _url = url+path+".json"+_suffix;
		http(_url,"GET","",options,function(status,result,options){
			show_debug_message(result);
			var _result = json_parse(result);
			if (options.callback!=undefined) {
				options.callback(_result);
			}
		});
	}
	
	function set(path,value,callback){
		var current_user = app.auth().current_user;
		var _suffix = "";
		if (current_user != undefined) {
			_suffix = "?auth="+app.auth().auth_token;
		}
		
		var options = {
			callback: callback,
		}
		
		
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
		}
		var _url = url+path+".json"+_suffix;
		http(_url,"POST",value,options,function(status,result,options){
			var _result = json_parse(result);
			if (options.callback!=undefined) {
				options.callback(_result);
			}
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
}