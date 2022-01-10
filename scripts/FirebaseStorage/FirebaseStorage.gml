global.FIREBASE_STORAGE_PUT_OPTIONS_DEFAULTS = {
	keep_buffer: false,
	mimetype: undefined,
	filename: undefined,
	file_is_buffer: false,
}

function FirebaseStorage(_app, _app_id, _storage_bucket) constructor {
	app = _app;
	storage_bucket = _storage_bucket;
	bucket_url = string_replace("https://firebasestorage.googleapis.com/v0/b/{{BUCKET}}/o/","{{BUCKET}}",storage_bucket);
	
	function put_file(remote_path,file,options={},callback=undefined) {
		var buff = buffer_load(file);
		options.file_is_buffer = true;
		options.keep_buffer = false;
		if (options[$ "filename"] == undefined) {
			options[$ "filename"] = filename_name(file);
			
		}
		if (options[$ "mimetype"] == undefined) {
			options[$ "mimetype"] = get_mime_from_extension(filename_ext(options.filename))
		}
		self.put(remote_path,buff,options,callback);
	}
	function put(remote_path,buffer,options={},callback=undefined){
		var keys = variable_struct_get_names(global.FIREBASE_STORAGE_PUT_OPTIONS_DEFAULTS);
		for (var i=0;i<array_length(keys);i++) {
			var key = keys[i];
			if (options[$ key] == undefined)
			options[$ key] = global.FIREBASE_STORAGE_PUT_OPTIONS_DEFAULTS[$ key];
		}
		var form = new FormData();
		form.add_file(options.filename,buffer,options);
		var headers = ds_map_create();
		var user = app.auth().current_user;
		if (user != undefined) {
			headers[? "Authorization"] = "Bearer " + app.auth().auth_token;
		}
		var _target = bucket_url + url_encode(remote_path);
		var http_options = {
			headers: headers,
			keep_header_map: false,
			callback: callback,
		}
		http(_target,"POST",form,http_options,function(status,result,options){
			//result = json_parse(result);
			if (options.callback != undefined) {
				options.callback(result);
			}
		});
	}
	function get_file(remote_path,local_file,options={},callback=undefined){
		var headers = ds_map_create();
		var user = app.auth().current_user;
		if (user != undefined) {
			headers[? "Authorization"] = "Bearer " + app.auth().auth_token;	
		}
		var _target = bucket_url + url_encode(remote_path);
		var http_options = {
			headers: headers,
			keep_header_map: false,
			callback: callback,
			target: _target,
			local_file: local_file,
		}
		http(_target,"GET","",http_options,function(status,result,options){
			result = json_parse(result);
			show_message(result);
			var _token = result.downloadTokens;
			var _target = options.target+"?media=alt&token="+_token;
			var http_options = {
				callback: options.callback,
				get_file:true,
				local_file: options.local_file,
			}
			http(_target,"GET","",http_options,function(status,result,options){
				if (options.callback != undefined) {
					buffer_save(result,options.local_file);
					options.callback(options.local_file);
				}
			});
			//show_message(result);
		});
	}
	function list_files(remote_path="",callback) {
		var headers = ds_map_create();
		var user = app.auth().current_user;
		if (user != undefined) {
			headers[? "Authorization"] = "Bearer " + app.auth().auth_token;	
		}
		var _target = bucket_url + "?prefix=" + url_encode(remote_path);
		var http_options = {
			headers: headers,
			keep_header_map: false,
			callback: callback,
		}
		http(_target,"GET","",http_options,function(status,result,options){
			if (options.callback != undefined) {
				options.callback(json_parse(result));
			}
		});
		
	}
}