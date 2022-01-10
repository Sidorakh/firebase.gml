function FirebaseAuth(_app,_app_id,_api_key) constructor {
	
	account_url = "https://identitytoolkit.googleapis.com/v1/accounts:";
	app = _app;
	app_id = _app_id;
	api_key = _api_key;
	
	current_user = undefined;
	auth_token = "";
	header = {};
	token = {};
	refresh_token = "";
	expires_at = undefined;
	function update() {
		
	}
	function load_from_file(fname) {
		try {
			var buff = buffer_load(fname);	
			var in = json_parse(buffer_read(buff,buffer_text));
			buffer_delete(buff);
			refresh_token = in.refresh_token;
			login_refresh_token()
		} catch(e) {
			throw "Couldn't load file " + fname + ".";
		}
	}
	function save_to_file(fname,encryption_function=undefined) {
		var out = json_stringify({
			refresh_token: refresh_token
		})
		if (is_method(encryption_function)) {
			out = encryption_function(out);
		}
		var buff = buffer_create(string_length(out),buffer_fixed,1);
		buffer_write(buff,buffer_text,out);
		buffer_save(buff,fname);
		buffer_delete(buff);
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
		
	}
	function login_custom_token(custom_token) {
		var _endpoint = account_url + "signInWithCustomToken?key=" + api_key;
		var body = {
			token: custom_token,
			returnSecureToken: true,
		};
		http(_endpoint,"POST",body,{},function(status,result){
			if (string(status) == "200") {
				set_auth_token(result.idToken);
				refresh_token = result.refreshToken;
				expires_at = date_inc_second(date_current_datetime(),real(result.expiresIn)-60);
			}
		});
	}
	function login_refresh_token() {
		var _endpoint = "https://securetoken.googleapis.com/v1/token?key=" + api_key;
		var body = "grant_type=refresh_token&refresh_token="+refresh_token;
		var headers = ds_map_create();
		headers[? "Content-Type"] = "application/x-www-form-urlencoded";
		var options = {
			headers: headers,
		}
		http(_endpoint,"POST",body,options,function(status,result){
			result = json_parse(result);
			if (string(status) == "200") {
				// yay we authenticated
				uid = result.user_id;
				set_auth_token(result.id_token);
				refresh_token = result.refresh_token;
				expires_at = expires_at = date_inc_second(date_current_datetime(),real(result.expires_in)-60);
				
				
			}
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
					set_auth_token(result.idToken);
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
					set_auth_token(result.idToken);
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
	
	
	
	
	
	
	
	function get_user_data() {
		var body = {
			idToken: auth_token	
		}
		http(account_url + "lookup?key=" + api_key,"POST",body,{},function(status,result){
			// success
			result = json_parse(result).users[0];
			current_user = new FirebaseUser();
			current_user.set_email(result.email).set_uid(result.localId);
			current_user.email_verified = result.emailVerified;
		},function(status,result){
			// error 
		});
	}
	function set_auth_token(_auth_token) {
		auth_token = _auth_token;
		var _corrected_token = string_replace_all(auth_token,"-","+")
		_corrected_token = string_replace_all(_corrected_token,"_","/");
		split = string_split(auth_token,".");
		header = json_parse(base64_decode(split[0]));
		token = json_parse(base64_decode(split[1]));
		if (current_user == undefined) {
			get_user_data();
		}
		
	}
}

function FirebaseUser() constructor {
	uid = "";
	email = "";
	email_verified = false;
	display_name = "";
	photo_url = "";
	created_at = "";
	claims = {};
	
	
	function set_uid(_uid) {
		uid = _uid;
		return self;
	}
	function set_email(_email) {
		email = _email;
		return self;
	}
	function set_photo_url(_photo_url) {
		photo_url = _photo_url;
		return self;
	}
	function set_display_name(_display_name) {
		display_name = _display_name;
		return self;
	}
	function get_email() {
		return email;
	}
	
}