extends Control

@export var ticket:FormData;

var exportedTicket:String = "";

@onready var expDat:RichTextLabel = $RichTextLabel as RichTextLabel;

func _ready() -> void:
	update_label();
	pass

func update_label() -> void:
	expDat.text = exportedTicket;
	pass

func _on_button_button_up() -> void:
	exportedTicket = ticket.serialize_to_json();
	update_label();
	pass


func _on_button_2_button_up() -> void:
	ticket.get_from_json(exportedTicket);
	update_label();
	pass


func _on_button_3_button_up() -> void:
	ticket = null;
	ticket = FormData.new();
	expDat.text = "";
	pass


func _on_button_4_button_up() -> void:
	if ticket:
		DataManager.save_ticket(ticket);
		pass
	pass


func _on_button_5_button_up() -> void:
	if ticket:
		ticket.export_to_pdf();
	pass
