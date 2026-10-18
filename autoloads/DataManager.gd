extends Node

signal scan_finished;

var ticket_database:Dictionary[int, FormData] = {};

func open_ticket(path:String) -> void:
	var file:FileAccess = FileAccess.open(path, FileAccess.READ);
	
	if !file:
		push_error("Error occured while opening ticket! FileAccess Error: %s\nFile Path: %s" % [error_string(FileAccess.get_open_error()), path]);
		return;
	
	var dump:String = file.get_as_text();
	file.close();
	
	var tmp_tik:FormData = FormData.new();
	tmp_tik.get_from_json(dump);
	
	if !ticket_database.has(tmp_tik.id):
		ticket_database.set(tmp_tik.id, tmp_tik);
		pass
	else:
		push_error("Failed to index ticket, ticket with index %s already exists!" % tmp_tik.id);
		pass
	pass

func save_ticket(ticket:FormData) -> void:
	var strDat:String = ticket.serialize_to_json();
	var path:String = ("%s/%s.tik" % [Settings.data_dir, ticket.id]);
	
	var file:FileAccess = FileAccess.open(path, FileAccess.WRITE);
	file.store_line(strDat);
	file.close();
	
	ticket._dirty = false;
	pass

func scan_for_tickets() -> void:
	var dir:DirAccess = DirAccess.open(Settings.data_dir);
	for file:String in dir.get_files():
		if file.ends_with(".tik"):
			open_ticket(dir.get_current_dir().path_join(file));
			pass
		pass
	scan_finished.emit();
	pass

func new_ticket() -> int:
	var tik:FormData = FormData.new();
	tik.id = ticket_database.keys().size();
	if tik.id < 0: tik.id = 0;
	
	if !ticket_database.has(tik.id):
		ticket_database.set(tik.id, tik);
		return tik.id;
	else:
		push_error("New ticket ID is invalid! %s" % ticket_database.keys());
		pass
	return -1;

func fake_tickets(amount:int) -> void:
	for index:int in range(amount):
		var tik:FormData = FormData.new();
		tik.id = ticket_database.keys().size();
		if tik.id < 0: tik.id = 0;
		print("Adding faketik %s of %s" % [index, amount]);
		ticket_database.get_or_add(tik.id, tik);
		pass
	pass

func _ready() -> void:
	if !DirAccess.dir_exists_absolute(Settings.data_dir):
		DirAccess.make_dir_absolute(Settings.data_dir);
		pass
	pass
