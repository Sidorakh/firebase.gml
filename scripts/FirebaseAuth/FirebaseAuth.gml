function FirebaseAuth(_app,_app_id,_api_key) constructor {
	
	account_url = "https://identitytoolkit.googleapis.com/v1/accounts:";
	app = _app;
	app_id = _app_id;
	api_key = _api_key;
	
	current_user = undefined;
	auth_token = "";
	refresh_token = "";
	expires_at = undefined;
	function update() {
		
	}
	function auth_state_change() {
		if (current_user == undefined) return;
		var headers = ds_map_create();
		headers[? "Content-Type"] = "application/json";
		var options = {
			headers: headers,
			keep_header_map: false,
		}
		var body = {
			idToken: auth_token,
		}
		http(account_url + "lookup?key=" + api_key,"POST","",options,function(status,result){
			// success
			
		},function(status,result){
			// error 
		});
	}
	function register_password(email,password,callback=undefined) {
		var body = {
			email: email,
			password: password,
			returnSecureToken: true
		};
		var headers = ds_map_create();
		headers[? "Content-Type"] = "application/json";
		var options = {
			headers: headers,
			keep_header_map: false,
			callback: callback,
		}
		http(account_url + "signUp?key="+api_key,
			"POST",
			body,
			options,
			function(status,result,options){
				// success
				result = json_parse(result);
				if (result[$ "error"] == undefined) {
					current_user = new FirebaseUser();
					current_user.set_uid(result.localId);
					current_user.set_email(result.email);
					auth_token = result.idToken;
					refresh_token = result.refreshToken;
					expires_at = date_inc_second(date_current_datetime(),real(result.expiresIn)-60);
					auth_state_change();
				}
				if (options[$ "callback"] != undefined) {
					options[$ "callback"](current_user,result[$ "error"]);
				}
			},
			function(status,result,options){
				// error
				show_message(result);
			}
		);
	}
	
	function login_password(email,password,callback=undefined) {
		var body = {
			email: email,
			password: password,
			returnSecureToken: true
		};
		var headers = ds_map_create();
		headers[? "Content-Type"] = "application/json";
		var options = {
			headers: headers,
			keep_header_map: false,
			callback: callback,
		}
		http(account_url + "signInWithPassword?key="+api_key,
			"POST",
			body,
			options,
			function(status,result,options){
				// success
				result = json_parse(result);
				if (result[$ "error"] == undefined) {
					current_user = new FirebaseUser();
					current_user.set_uid(result.localId);
					current_user.set_email(result.email);
					auth_token = result.idToken;
					refresh_token = result.refreshToken;
					expires_at = date_inc_second(date_current_datetime(),real(result.expiresIn)-60);
					auth_state_change();
				}
				if (options[$ "callback"] != undefined) {
					options[$ "callback"](current_user,result[$ "error"]);
				}
			},
			function(status,result,options){
				// error
				show_message(result);
			}
		);
	}
}

function FirebaseUser() constructor {
	uid = "";
	email = "";
	display_name = "";
	photo_url = "";
	created_at = "";
	claims = {};
	
	
	function set_uid(_uid) {
		uid = _uid;
	}
	function set_email(_email) {
		email = _email;
	}
	
}