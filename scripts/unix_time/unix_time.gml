/// @description  Gets current Unix timestamp
/// @returns      a unix timestamp
function unix_timestamp() {
	var _old_tz = date_get_timezone();
	date_set_timezone(timezone_utc);
	var _timestamp = floor((date_current_datetime() - 25569) * 86400);
	date_set_timezone(_old_tz);
	return _timestamp;
}

function unix_timestamp_to_gm(time) {
	return (time/86400) + 25569;
}
function gm_timestamp_to_unix(time) {
	return (time - 25569) * 86400;
}