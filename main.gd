extends Control

var closed:bool = true;

@onready var formList:ItemList = $CanvasLayer/FormList/FormList as ItemList;
@onready var formPanel:TrackWarrantForm = $CanvasLayer/FormContentPanel/InnerContentPanel/TrackWarrantForm as TrackWarrantForm;
@onready var anim:AnimationPlayer = $CanvasLayer/FormContentPanel/InnerContentPanel/AnimationPlayer as AnimationPlayer;

# Data
var curID:int = -1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.scan_finished.connect(update_ticket_list);
	DataManager.scan_for_tickets();
	#DataManager.fake_tickets(1000);
	#update_ticket_list();
	pass

func update_ticket_list() -> void:
	formList.clear();
	for key:int in DataManager.ticket_database.keys():
		formList.add_item(str("  Ticket ", key));
		pass
	pass

func load_data() -> void:
	if !closed:
		var _seek_at:float = 0;
		if anim.is_playing():
			_seek_at = anim.current_animation_position;
			pass
		anim.play("close");
		anim.seek(_seek_at, true);
		await anim.animation_finished;
	formPanel.load_ticket_data(DataManager.ticket_database[curID]);
	
	var _seek_at_open:float = 0;
	if anim.is_playing():
		_seek_at_open = anim.current_animation_position;
		pass
	anim.play("open");
	anim.seek(_seek_at_open, true);
	await anim.animation_finished;
	closed = false;
	pass

func _on_form_list_item_selected(index: int) -> void:
	if curID != -1 and DataManager.ticket_database[curID]._dirty:
		DataManager.save_ticket(DataManager.ticket_database[curID]);
		pass
	
	curID = index;
	load_data();
	pass


func _on_new_form_button_up() -> void:
	var tikID:int = DataManager.new_ticket();
	update_ticket_list();
	formList.select(tikID);
	
	if curID != -1 and DataManager.ticket_database[curID]._dirty:
		DataManager.save_ticket(DataManager.ticket_database[curID]);
		pass
	
	curID = tikID;
	load_data();
	pass


func _on_refresh_list_button_up() -> void:
	update_ticket_list();
	formList.select(curID);
	if !formList.get("item_%s/text" % curID):
		if !closed:
			anim.play("close");
			await anim.animation_finished;
			closed = true;
			pass
		pass
	pass
