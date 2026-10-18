class_name TrackWarrantForm extends Control

@onready var table:Dictionary = {
	"meta": {
		"id": $ScrollContainer/VBoxContainer/TicketNumber as Label,
		"companyName": $ScrollContainer/VBoxContainer/TicketNumber/CompanyName as LineEdit,
		"trainName": $ScrollContainer/VBoxContainer/TargetTrain as LineEdit,
		"approvalTime": $ScrollContainer/VBoxContainer/Line18Lbl/timeBox as LineEdit,
		"dispatcher": $ScrollContainer/VBoxContainer/Line18Lbl/nameBox as LineEdit
	},
	
	"l1": {
		"check": $ScrollContainer/VBoxContainer/Line1Lbl/CheckBox as CheckBox,
		"d1": $ScrollContainer/VBoxContainer/Line1Lbl/LineOne_Number as OptionButton
	},
	
	"l2": {
		"check": $ScrollContainer/VBoxContainer/Line2Lbl/CheckBox as CheckBox,
		"from": $ScrollContainer/VBoxContainer/Line2Lbl/fromBox as LineEdit,
		"to": $ScrollContainer/VBoxContainer/Line2Lbl/toBox as LineEdit,
		"on": $ScrollContainer/VBoxContainer/Line2Lbl/onBox as LineEdit
	},
	
	"l3": {
		"check": $ScrollContainer/VBoxContainer/Line3Lbl/CheckBox as CheckBox,
		"from": $ScrollContainer/VBoxContainer/Line3Lbl/fromBox as LineEdit,
		"to": $ScrollContainer/VBoxContainer/Line3Lbl/toBox as LineEdit,
		"on": $ScrollContainer/VBoxContainer/Line3Lbl/onBox as LineEdit
	},
	
	"l4": {
		"check": $ScrollContainer/VBoxContainer/Line4Lbl/CheckBox as CheckBox,
		"from": $ScrollContainer/VBoxContainer/Line4Lbl/fromBox as LineEdit,
		"to": $ScrollContainer/VBoxContainer/Line4Lbl/toBox as LineEdit,
		"on": $ScrollContainer/VBoxContainer/Line4Lbl/onBox as LineEdit
	},
	
	"l5": {
		"check": $ScrollContainer/VBoxContainer/Line5Lbl/CheckBox as CheckBox,
		"effect": $ScrollContainer/VBoxContainer/Line5Lbl/effectBox as LineEdit
	},
	
	"l6": {
		"check": $ScrollContainer/VBoxContainer/Line6Lbl/CheckBox as CheckBox,
		"effect": $ScrollContainer/VBoxContainer/Line6Lbl/effectBox as LineEdit
	},
	
	"l7": {
		"check": $ScrollContainer/VBoxContainer/Line7Lbl/CheckBox as CheckBox,
		"train": $ScrollContainer/VBoxContainer/Line7Lbl/trainBox as LineEdit,
		"time": $ScrollContainer/VBoxContainer/Line7Lbl/timeBox as LineEdit
	},
	
	"l8": {
		"check": $ScrollContainer/VBoxContainer/Line8Lbl/CheckBox as CheckBox
	},
	
	"l9": {
		"check": $ScrollContainer/VBoxContainer/Line9Lbl/CheckBox as CheckBox,
		"effect": $ScrollContainer/VBoxContainer/Line9Lbl/effectBox as LineEdit
	},
	
	"l10": {
		"check": $ScrollContainer/VBoxContainer/Line10Lbl/CheckBox as CheckBox
	},
	
	"l11": {
		"check": $ScrollContainer/VBoxContainer/Line11Lbl/CheckBox as CheckBox,
		"from": $ScrollContainer/VBoxContainer/Line11Lbl/fromBox as LineEdit,
		"to": $ScrollContainer/VBoxContainer/Line11Lbl/toBox as LineEdit
	},
	
	"l12": {
		"check": $ScrollContainer/VBoxContainer/Line12Lbl/CheckBox as CheckBox,
		"from": $ScrollContainer/VBoxContainer/Line12Lbl/fromBox as LineEdit,
		"to": $ScrollContainer/VBoxContainer/Line12Lbl/toBox as LineEdit
	},
	
	"l13": {
		"check": $ScrollContainer/VBoxContainer/Line13Lbl/CheckBox as CheckBox,
		"mph": $ScrollContainer/VBoxContainer/Line13Lbl/mphBox as LineEdit,
		"from": $ScrollContainer/VBoxContainer/Line13Lbl/fromBox as LineEdit,
		"to": $ScrollContainer/VBoxContainer/Line13Lbl/toBox as LineEdit
	},
	
	"l14": {
		"check": $ScrollContainer/VBoxContainer/Line14Lbl/CheckBox as CheckBox,
		"mph": $ScrollContainer/VBoxContainer/Line14Lbl/mphBox as LineEdit,
		"from": $ScrollContainer/VBoxContainer/Line14Lbl/fromBox as LineEdit,
		"to": $ScrollContainer/VBoxContainer/Line14Lbl/toBox as LineEdit
	},
	
	"l15": {
		"check": $ScrollContainer/VBoxContainer/Line15Lbl/CheckBox as CheckBox
	},
	
	# Not Implemented: Train Bulletins
	"l16": {},
	
	"l17": {
		"check": $ScrollContainer/VBoxContainer/Line17/Line17Lbl/CheckBox as CheckBox,
		"text": $ScrollContainer/VBoxContainer/Line17/Line17Lbl/TextEdit as TextEdit
	},
	
	"l18": {
		"time": $ScrollContainer/VBoxContainer/Line18Lbl/timeBox as LineEdit,
		"name": $ScrollContainer/VBoxContainer/Line18Lbl/nameBox as LineEdit
	},
	
	"l19": {
		"time": $ScrollContainer/VBoxContainer/Line19Lbl/timeBox as LineEdit
	}
};

var curID:int = -1;

func load_ticket_data(ticket:FormData) -> void:
	curID = ticket.id;
	(table["meta"]["id"] as Label).text = "Ticket Number %s" % ticket.id;
	(table["meta"]["companyName"] as LineEdit).text = ticket.companyName;
	(table["meta"]["trainName"] as LineEdit).text = ticket.trainName;
	(table["meta"]["approvalTime"] as LineEdit).text = ticket.approvalTime;
	(table["meta"]["dispatcher"] as LineEdit).text = ticket.dispatcher;
	
	ticket.checkedLines[0] = !(-1 == ticket.voidPreviousWarrant);
	(table["l1"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[0]);
	(table["l1"]["d1"] as OptionButton).clear();
	(table["l1"]["d1"] as OptionButton).add_item(""); # None
	for key in DataManager.ticket_database.keys():
		(table["l1"]["d1"] as OptionButton).add_item(str(key));
		if key == ticket.voidPreviousWarrant:
			(table["l1"]["d1"] as OptionButton).select(key);
			pass
		pass
	
	ticket.checkedLines[1] = !(ticket.proceedOne["from"].is_empty() and ticket.proceedOne["to"].is_empty() and ticket.proceedOne["on"].is_empty());
	(table["l2"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[1]);
	(table["l2"]["from"] as LineEdit).text = ticket.proceedOne["from"];
	(table["l2"]["to"] as LineEdit).text = ticket.proceedOne["to"];
	(table["l2"]["on"] as LineEdit).text = ticket.proceedOne["on"];
	
	ticket.checkedLines[2] = !(ticket.proceedTwo["from"].is_empty() and ticket.proceedTwo["to"].is_empty() and ticket.proceedTwo["on"].is_empty());
	(table["l3"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[2]);
	(table["l3"]["from"] as LineEdit).text = ticket.proceedTwo["from"];
	(table["l3"]["to"] as LineEdit).text = ticket.proceedTwo["to"];
	(table["l3"]["on"] as LineEdit).text = ticket.proceedTwo["on"];
	
	ticket.checkedLines[3] = !(ticket.workTimeFrame["from"].is_empty() and ticket.workTimeFrame["to"].is_empty() and ticket.workTimeFrame["on"].is_empty());
	(table["l4"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[3]);
	(table["l4"]["from"] as LineEdit).text = ticket.workTimeFrame["from"];
	(table["l4"]["to"] as LineEdit).text = ticket.workTimeFrame["to"];
	(table["l4"]["on"] as LineEdit).text = ticket.workTimeFrame["on"];
	
	ticket.checkedLines[4] = !(ticket.delayStartTime.is_empty());
	(table["l5"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[4]);
	(table["l5"]["effect"] as LineEdit).text = ticket.delayStartTime;
	
	ticket.checkedLines[5] = !(ticket.expireTime.is_empty());
	(table["l6"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[5]);
	(table["l6"]["effect"] as LineEdit).text = ticket.expireTime;
	
	ticket.checkedLines[6] = !(ticket.startConditions["arrival_of"].is_empty() and ticket.startConditions["at"].is_empty());
	(table["l7"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[6]);
	(table["l7"]["train"] as LineEdit).text = ticket.startConditions["arrival_of"];
	(table["l7"]["time"] as LineEdit).text = ticket.startConditions["at"];
	
	(table["l8"]["check"] as CheckBox).set_pressed_no_signal(ticket.holdMainTrackAtLastNamedPoint);
	ticket.checkedLines[7] = ticket.holdMainTrackAtLastNamedPoint;
	
	ticket.checkedLines[8] = !(ticket.doNotFoulPastPoint.is_empty());
	(table["l9"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[8]);
	(table["l9"]["effect"] as LineEdit).text = ticket.doNotFoulPastPoint;
	
	(table["l10"]["check"] as CheckBox).set_pressed_no_signal(ticket.clearMainAtLastPoint);
	ticket.checkedLines[9] = ticket.clearMainAtLastPoint;
	
	ticket.checkedLines[10] = !(ticket.restrictSpeedBetweenPointsForTrain["from"].is_empty() and ticket.restrictSpeedBetweenPointsForTrain["to"].is_empty());
	(table["l11"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[10]);
	(table["l11"]["from"] as LineEdit).text = ticket.restrictSpeedBetweenPointsForTrain["from"];
	(table["l11"]["to"] as LineEdit).text = ticket.restrictSpeedBetweenPointsForTrain["to"];
	
	ticket.checkedLines[11] = !(ticket.restrictSpeedBetweenPointsForEquipment["from"].is_empty() and ticket.restrictSpeedBetweenPointsForEquipment["to"].is_empty());
	(table["l12"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[11]);
	(table["l12"]["from"] as LineEdit).text = ticket.restrictSpeedBetweenPointsForEquipment["from"];
	(table["l12"]["to"] as LineEdit).text = ticket.restrictSpeedBetweenPointsForEquipment["to"];
	
	ticket.checkedLines[12] = !(ticket.speedLimitBetweenLocationsOne["speed"].is_empty() and ticket.speedLimitBetweenLocationsOne["from"].is_empty() and ticket.speedLimitBetweenLocationsOne["to"].is_empty());
	(table["l13"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[12]);
	(table["l13"]["mph"] as LineEdit).text = ticket.speedLimitBetweenLocationsOne["speed"];
	(table["l13"]["from"] as LineEdit).text = ticket.speedLimitBetweenLocationsOne["from"];
	(table["l13"]["to"] as LineEdit).text = ticket.speedLimitBetweenLocationsOne["to"];
	
	ticket.checkedLines[13] = !(ticket.speedLimitBetweenLocationsTwo["speed"].is_empty() and ticket.speedLimitBetweenLocationsTwo["from"].is_empty() and ticket.speedLimitBetweenLocationsTwo["to"].is_empty());
	(table["l14"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[13]);
	(table["l14"]["mph"] as LineEdit).text = ticket.speedLimitBetweenLocationsTwo["speed"];
	(table["l14"]["from"] as LineEdit).text = ticket.speedLimitBetweenLocationsTwo["from"];
	(table["l14"]["to"] as LineEdit).text = ticket.speedLimitBetweenLocationsTwo["to"];
	
	(table["l15"]["check"] as CheckBox).set_pressed_no_signal(ticket.flagProtection);
	ticket.checkedLines[14] = ticket.flagProtection;
	
	ticket.checkedLines[16] = !(ticket.otherInstructions.is_empty());
	(table["l17"]["check"] as CheckBox).set_pressed_no_signal(ticket.checkedLines[16]);
	(table["l17"]["text"] as TextEdit).text = ticket.otherInstructions;
	
	(table["l19"]["time"] as LineEdit).text = ticket.limitClearTime;
	pass

func _ready() -> void:
	pass

# ---- METADATA ----
func _on_company_name_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].companyName = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_target_train_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].trainName = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

# ---- LINE 1 ----
func _on_line_one_number_item_selected(index: int) -> void:
	DataManager.ticket_database[curID].voidPreviousWarrant = index;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_l1_check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[0] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 2 ----
func _on_l2_check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[1] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_l2_from_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].proceedOne["from"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_l2_to_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].proceedOne["to"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_l2_on_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].proceedOne["on"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 3 ----
func _on_l3_check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[2] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_3from_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].proceedTwo["from"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_3to_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].proceedTwo["to"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_3on_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].proceedTwo["on"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 4 ----
func _on_4check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[3] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_4from_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].workTimeFrame["from"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_4to_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].workTimeFrame["to"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_4on_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].workTimeFrame["on"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

# ---- LINE 5 ----
func _on_5check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[4] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_5effect_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].delayStartTime = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 6 ----
func _on_6check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[5] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_6effect_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].expireTime = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 7 ----
func _on_7check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[6] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_7train_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].startConditions["arrival_of"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_7time_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].startConditions["at"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

# ---- LINE 8 ----
func _on_8check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[7] = toggled_on;
	DataManager.ticket_database[curID].holdMainTrackAtLastNamedPoint = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 9 ----
func _on_9check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[8] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_9effect_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].doNotFoulPastPoint = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 10 ----
func _on_10check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[9] = toggled_on;
	DataManager.ticket_database[curID].clearMainAtLastPoint = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 11 ----
func _on_11check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[10] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_11from_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].restrictSpeedBetweenPointsForTrain["from"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_11to_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].restrictSpeedBetweenPointsForTrain["to"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 12 ----
func _on_12check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[11] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_12from_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].restrictSpeedBetweenPointsForEquipment["from"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_12to_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].restrictSpeedBetweenPointsForEquipment["to"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

# ---- LINE 13 ----
func _on_13check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[12] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_13mph_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].speedLimitBetweenLocationsOne["speed"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_13from_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].speedLimitBetweenLocationsOne["from"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_13to_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].speedLimitBetweenLocationsOne["to"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

# ---- LINE 14 ----
func _on_14check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[13] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_14mph_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].speedLimitBetweenLocationsTwo["speed"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_14from_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].speedLimitBetweenLocationsTwo["from"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_14to_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].speedLimitBetweenLocationsTwo["to"] = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 15 ----
func _on_15check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[14] = toggled_on;
	DataManager.ticket_database[curID].flagProtection = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 16 ----
# ---- LINE 17 ----
func _on_17check_box_toggled(toggled_on: bool) -> void:
	DataManager.ticket_database[curID].checkedLines[16] = toggled_on;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_17text_edit_text_changed() -> void:
	DataManager.ticket_database[curID].otherInstructions = (table["l17"]["text"] as TextEdit).text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

# ---- LINE 18 ----
func _on_18time_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].approvalTime = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass

func _on_18name_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].dispatcher = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass


# ---- LINE 19 ----
func _on_19time_box_text_changed(new_text: String) -> void:
	DataManager.ticket_database[curID].limitClearTime = new_text;
	DataManager.ticket_database[curID]._dirty = true;
	pass
