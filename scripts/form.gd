class_name FormData extends Resource

@export_category("Metadata")
@export var id:int = -1;
@export var trainName:String = "";
@export var companyName:String = "";
@export var approvalTime:String = "";
@export var dispatcher:String = "";
@export var limitClearTime:String = "";

enum TicketState {
	PENDING,
	ACTIVE,
	VOID
}

var _loaded_data:bool = false;
var _dirty:bool = false;

@export var state:TicketState = TicketState.PENDING;

@export_category("Form Data")
@export var checkedLines:Array[bool] = [
	false, # 1
	false, # 2
	false, # 3
	false, # 4
	false, # 5
	false, # 6
	false, # 7
	false, # 8
	false, # 9
	false, # 10
	false, # 11
	false, # 12
	false, # 13
	false, # 14
	false, # 15
	false, # 16 - Forever false
	false # 17
];

# 1
@export var voidPreviousWarrant:int = -1;

# 2
@export var proceedOne:Dictionary[String, String] = {
	"from": "",
	"to": "",
	"on": ""
};

# 3
@export var proceedTwo:Dictionary[String, String] = {
	"from": "",
	"to": "",
	"on": ""
};

# 4
@export var workTimeFrame:Dictionary[String, String] = {
	"from": "",
	"to": "",
	"on": ""
};

# 5
@export var delayStartTime:String = "";

# 6
@export var expireTime:String = "";

# 7
@export var startConditions:Dictionary[String, String] = {
	"arrival_of": "",
	"at": ""
};

# 8
@export var holdMainTrackAtLastNamedPoint:bool = false;

# 9
@export var doNotFoulPastPoint:String = "";

# 10
@export var clearMainAtLastPoint:bool = false;

# 11
@export var restrictSpeedBetweenPointsForTrain:Dictionary[String, String] = {
	"from": "",
	"to": ""
};

# 12
@export var restrictSpeedBetweenPointsForEquipment:Dictionary[String, String] = {
	"from": "",
	"to": ""
};

# 13
@export var speedLimitBetweenLocationsOne:Dictionary[String, String] = {
	"speed": "",
	"from": "",
	"to": ""
};

# 14
@export var speedLimitBetweenLocationsTwo:Dictionary[String, String] = {
	"speed": "",
	"from": "",
	"to": ""
};

# 15
@export var flagProtection:bool = false;

# 16
@export var trackBulletins:Array[String] = [];

# 17
@export var otherInstructions:String = "";

func serialize_to_json() -> String:
	var result:String = "";
	var dat:Dictionary = {
		"ticketNumber": id,
		"trainName": trainName,
		"companyName": companyName,
		"approvalTime": approvalTime,
		"limitClearTime": limitClearTime,
		"dispatcher": dispatcher,
		"state": state,
		"formData": {
			"checkedLines": checkedLines,
			"voidPreviousWarrant": voidPreviousWarrant,
			"proceedOne": proceedOne,
			"proceedTwo": proceedTwo,
			"workTimeFrame": workTimeFrame,
			"delayStartTime": delayStartTime,
			"expireTime": expireTime,
			"startConditions": startConditions,
			"holdMainTrackAtLastNamedPoint": holdMainTrackAtLastNamedPoint,
			"doNotFoulPastPoint": doNotFoulPastPoint,
			"clearMainAtLastPoint": clearMainAtLastPoint,
			"restrictSpeedBetweenPointsForTrain": restrictSpeedBetweenPointsForTrain,
			"restrictSpeedBetweenPointsForEquipment": restrictSpeedBetweenPointsForEquipment,
			"speedLimitBetweenLocationsOne": speedLimitBetweenLocationsOne,
			"speedLimitBetweenLocationsTwo": speedLimitBetweenLocationsTwo,
			"flagProtection": flagProtection,
			"trackBulletins": trackBulletins,
			"otherInstructions": otherInstructions
		}
	};
	
	result = JSON.stringify(dat, "    ", false);
	return result;

func get_from_json(data_string:String) -> void:
	var data:Dictionary = JSON.parse_string(data_string);
	
	if data == null:
		push_error("Could not load ticket data!");
		return;
	
	if _loaded_data:
		push_error("Already loaded ticket data!");
		return;
	
	id = data.get("ticketNumber", -1);
	trainName = data.get("trainName", "");
	companyName = data.get("companyName", "");
	approvalTime = data.get("approvalTime", "");
	limitClearTime = data.get("limitClearTime", "");
	dispatcher = data.get("dispatcher", "");
	state = data.get("state", 0);
	
	checkedLines = [];
	for chk:bool in data["formData"]["checkedLines"] as Array[bool]:
		checkedLines.append(chk);
		pass
	
	voidPreviousWarrant = data["formData"]["voidPreviousWarrant"];
	
	proceedOne = {
		"from": data["formData"]["proceedOne"]["from"],
		"to": data["formData"]["proceedOne"]["to"],
		"on": data["formData"]["proceedOne"]["on"]
	};
	
	proceedTwo = {
		"from": data["formData"]["proceedTwo"]["from"],
		"to": data["formData"]["proceedTwo"]["to"],
		"on": data["formData"]["proceedTwo"]["on"]
	};
	
	workTimeFrame = {
		"from": data["formData"]["workTimeFrame"]["from"],
		"to": data["formData"]["workTimeFrame"]["to"],
		"on": data["formData"]["workTimeFrame"]["on"]
	};
	
	delayStartTime = data["formData"]["delayStartTime"];
	expireTime = data["formData"]["expireTime"];
	
	startConditions = {
		"arrival_of": data["formData"]["startConditions"]["arrival_of"],
		"at": data["formData"]["startConditions"]["at"]
	};
	
	holdMainTrackAtLastNamedPoint = data["formData"]["holdMainTrackAtLastNamedPoint"];
	doNotFoulPastPoint = data["formData"]["doNotFoulPastPoint"];
	clearMainAtLastPoint = data["formData"]["clearMainAtLastPoint"];
	
	restrictSpeedBetweenPointsForTrain = {
		"from": data["formData"]["restrictSpeedBetweenPointsForTrain"]["from"],
		"to": data["formData"]["restrictSpeedBetweenPointsForTrain"]["to"]
	};
	
	restrictSpeedBetweenPointsForEquipment = {
		"from": data["formData"]["restrictSpeedBetweenPointsForEquipment"]["from"],
		"to": data["formData"]["restrictSpeedBetweenPointsForEquipment"]["to"]
	};
	
	speedLimitBetweenLocationsOne = {
		"speed": data["formData"]["speedLimitBetweenLocationsOne"]["speed"],
		"from": data["formData"]["speedLimitBetweenLocationsOne"]["from"],
		"to": data["formData"]["speedLimitBetweenLocationsOne"]["to"]
	};
	
	speedLimitBetweenLocationsTwo = {
		"speed": data["formData"]["speedLimitBetweenLocationsTwo"]["speed"],
		"from": data["formData"]["speedLimitBetweenLocationsTwo"]["from"],
		"to": data["formData"]["speedLimitBetweenLocationsTwo"]["to"]
	};
	
	flagProtection = data["formData"]["flagProtection"];
	
	trackBulletins = [];
	for btn:String in data["formData"]["trackBulletins"] as Array[String]:
		trackBulletins.append(btn);
		pass
	
	otherInstructions = data["formData"]["otherInstructions"];
	
	_loaded_data = true;
	pass

func export_to_pdf(path:String = "") -> void:
	"""
	if path.is_empty(): path = "%s/%s.pdf" % [Settings.data_dir, id];
	var pdf:PDF_DOC = PDF_DOC.new();
	var page:PDF_PAGE = pdf.add_page();
	
	var pageSize:Vector2 = Vector2(page.w, page.h);
	
	page.set_size(PDF_PAGE.A4, PDF_PAGE.LANDSCAPE);
	
	page.set_line_width(1);
	page.rectangle(50, 50, pageSize.x - 100, pageSize.y - 110);
	page.stroke();
	
	page.set_font_and_size(pdf.get_font("Helvetica"), 24);
	page.begin_text();
	page.text_out(100, 100, "Hello World");
	page.end_text();
	
	pdf.save_to_file(path);
	pdf.free();
	"""
	push_warning("PDF code is disabled.");
	pass
