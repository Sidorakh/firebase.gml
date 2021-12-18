function FirebaseFirestore(_app, _project_id, _api_key) constructor {
	app = _app;
	api_key = _api_key;
	project_id = _project_id;
	url = "https://firestore.googleapis.com/v1/projects/{{PROJECT}}/databases/(default)/documents/";
	url = string_replace(url,"{{PROJECT}}",project_id);
	function collection(_id) {
		return new FirestoreCollection(app,_id,[_id]);
	}
}

function FirestoreCollection(_app,_collection_id,_path=[]) constructor {
	app = _app;
	collection_id = _collection_id;
	path = _path;
	function document(_id) {
		var _np = json_parse(json_stringify(path));
		array_push(_np,_id);
		return new FirestoreDocument(app,_id,_np);
	}
	function list(callback) {
		var headers = ds_map_create();
		if (app.auth().current_user != undefined) {
			headers[? "Authorization"] = "Bearer " + app.auth().auth_token;
		}
		headers[? "Accept"] = "application/json";
		var options = {
			headers: headers,
			callback: callback,
		}
		var _suffix = array_join(path,"/");
		http(app.firestore().url + _suffix,"GET","",options,function(status,result,options){
			//show_message(string(status) + " - " + string(result));
			result = json_parse(result);
			
			if (options[$ "callback"] != undefined) {
				options.callback(result);
			}
		});
	}
}

function FirestoreDocument(_app,_document_id,_path=[]) constructor {
	app = _app;
	document_id = _document_id;
	path = _path;
	// eventually sync/watch this properly?
	var created = date_current_datetime();
	expires = date_inc_minute(created,1);	// refresh after minute
	_doc_data = undefined;
	function collection(_id) {
		var _np = json_parse(json_stringify(path));
		array_push(_np,_id);
		return new FirestoreCollection(app,_id,_np);
	}
	function get(callback,force_refresh=false) {
		var headers = ds_map_create();
		if (_doc_data != undefined && force_refresh == false) {
			if (date_current_datetime() < expires) {
				return callback(_doc_data);
			}
		}
		if (app.auth().current_user != undefined) {
			headers[? "Authorization"] = "Bearer " + app.auth().auth_token;
		}
		var options = {
			headers: headers,
			callback: callback,
		}
		var _suffix = array_join(path,"/");
		http(app.firestore().url+_suffix,"GET","",options,function(status,result,options){
			result = json_parse(result);
			_doc_data = new FirestoreDocumentData(app,result,self);
			options.callback(_doc_data);
		});
	}
	function set(callback) {
		var headers = ds_map_create();
		if (app.auth().current_user != undefined) {
			headers[? "Authorization"] = "Bearer " + app.auth().auth_token;
		}
		var options = {
			headers: headers,
			callback: callback,
		}
		var _suffix = array_join(path,"/");
		http(app.firestore().url+_suffix,"PUT",_doc_data.serialize(),options,function(status,result,options){
			show_message(result);
		});
	}
}

function FirestoreDocumentData(_app,_serialized_data,_parent) constructor {
	app = _app;
	parent = _parent;
	_data = {};
	var _fields = variable_struct_get_names(_serialized_data);
	for (var i=0;i<array_length(_fields);i++) {
		_data[$ _fields[i]] = deserialize_firestore_field(_serialized_data[$ _fields[i]]);
	}
	function get(_field) {
		if (_data[$ _field] != undefined) {
			return _data[$ _field].value;	
		}
		return undefined;
	}
	function set(_field,_value) {
		if (_data[$ _field] == undefined) {
			_data[$ _field] = {type: "", value: 0}	
		}
		var _type = "";
		switch (typeof(_value)) {
			case "struct":
			case "array":
				// lets ignore these for now
			break;
			case "string":
				_type = "string";
			break;
			case "number":
				_type = "double";
			break;
			case "int32":
			case "int64":
				_type = "integer";
			break;
			case "bool":
				_type = "boolean";
			break;
		}
		_data.type = _type;
		_data.value = _value;
		return self;	// allow chaining set
	}
	function apply(callback) {
		// Guess it works sorta like a transaction now - .set()
		// to update/add fields, .apply() to save changes
		parent.set(callback);
	}
	function serialize() {
		var _out = {};
		var _fields = variable_struct_get_names(_data);
		for (var i=0;i<array_length(_fields);i++) {
			var _field = _data[$ _fields[i]];
			var _type = "";
			switch (_field.type) {
				case "struct":
				case "array":
				
				break;
				case "string":
					_type = "string";
				break;
				case "number":
					_type = "double";
				break;
				case "int32":
				case "int64":
					_type = "integer";
				break;
				case "bool":
					_type = "boolean";
				break;
			}
			_type += "Value";
			_out[$ _fields[i]] = {};
			_out[$ _fields[i]][$ _type] = _field.value;
		}
		return _out;
	}
}


function FirestoreDocumentDataOld(_app,_data) constructor {
	app = _app;
	url = "https://firestore.googleapis.com/v1/" + data.name;
	
	var _fields = variable_struct_get_names(_data.fields);
	for (var i=0;i<array_length(_fields);i++) {
		_field_data[_fields[i]] = new FirestoreDocumentField(_fields[i],_data.fields[$ _fields[i]]);
	}
	
	_fields = _data.fields;
	
	function data(){
		return _field_data;
	}
	
	// set/update requires a PATCH request
	// Optional update_mask that allows selective field updating
	/*
		Firebase Firestor's .set() function takes an object and _just_ sets to that. Could do that
		Then use .update for this
		.create() should also check for an ID, if set, then add to QueryString, under documentId
		...?documentId=p9VsOqnIre0DJruQgB8T
		
	*/
	
	
	
	function update(update_mask=[],callback=undefined){
		var suffix = "";
		if (array_length(update_mask) != 0) {
			// updateMask.fieldPaths=...
			suffix = "?";
		}
		var headers = ds_map_create();
		if (app.auth().current_user != undefined) {
			headers[? "Authorization"] = "Bearer " + app.auth().auth_token;
		}
		var options = {
			headers: headers,
			callback: callback,
		}
		var body = {};
		var _field_names = variable_struct_get_names(_fields)
		for (var i=0;i<array_length(_field_names);i++) {
			body[$ _field_names[i]] = serialize_firestore_field(_fields[$ _field_names[i]]);
		};
		http(url+suffix,"PATCH",body,options,function(status,result,options){
			result = json_parse(result);
			if (options[$ "callback"]) {
				options.callback(result);	
			}
		})
	}
	
	
	
}

function serialize_firestore_field(_value) {
	var _type = "";
	switch (typeof(_value)) {
		case "struct":
		case "array":
			
		break;
		case "string":
			_type = "string";
		break;
		case "number":
			_type = "double";
		break;
		case "int32":
		case "int64":
			_type = "integer";
		break;
		case "bool":
			_type = "boolean";
		break;
	}
	_type += "Value";
	var value = {};
	value[$ _type] = _value;
	return value;
}

function deserialize_firestore_field(_field_data) {
	var _field_name = variable_struct_get_names(_field_data)[0];
	var _type = string_replace(string_lower(_type),"value","");
	return {
		type: _type,
		value: _field_data[$ _type],
	}
}

function FirestoreDocumentField(_key,_field_data) {
	var _type = variable_struct_get_names(_field_data)[0];
	type = string_replace(string_lower(_type),"value","");
	value = _field_data[$ _type];
	function set(_value,_type=undefined) {
		if (_type == undefined){ 
			_type = typeof(_value);
			if (_type == "struct" || _type == "array") {
				// haven't added this yeah nope
				show_error("Not implemented yet. Sorry. ",false);
			}
			value = _value;
		}
	}
	function get(){
		return value;
	}
	function serialize(){
		var struct = {};
		struct[$ type+"Value"] = value;
		return struct;
	}
}