function FirebaseClient(options) constructor {
	api_key = options.apiKey;
	auth_domain = options.authDomain;
	database_url = options.databaseURL;
	project_id = options.projectId;
	storage_bucket = options.storageBucket;
	app_id = options.appId;
	
	_auth = undefined;
	_db = undefined;
	_storage = undefined;
	_firestore = undefined;
	
	function update() {
		// Call this function regularly. Handles auth tokens
		if (_auth != undefined) {
			_auth.update();
		}
	}
	
	function auth() {
		if (_auth == undefined) {
			_auth = new FirebaseAuth(self,app_id,api_key);
		}
		return _auth;
	}
	
	function storage() {
		if (_storage = undefined) {
			_storage = new FirebaseStorage(self,app_id,storage_bucket);	
		}
		return _storage;
	}
	
	function db(){
		if (_db == undefined) {
			_db = new FirebaseRealTimeDatabase(self,app_id,database_url);
		}
		return _db;
	}
	
	function firestore() {
		// yeah, don't usee this yet
		//return show_message("Don't use this yet. It's still a work in progress");
		if (_firestore == undefined) {
			_firestore = new FirebaseFirestore(self,project_id,api_key);
		}
		return _firestore;
	}
	
}