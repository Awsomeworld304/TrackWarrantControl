# Copyright (C) 2024 - present JamesTech4849
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

extends Node

# Static Stuff
const GAME_VERSION:String = "0.1.0";
## File Version - Used in case of the settings updating.
const secret:int = 1;

const save_file:String = "user://EngineSettings.sav";
const save_dir:String = "user://";
const data_dir:String = "user://TicketDB";

var debug:bool = false;

## A flag that triggers a function to save in some conditions.[br]
## Do NOT manually set this flag! You will absolutely throw the engine off and may destroy the engine save files!
var _save_flag:bool = false;

# Error Stuff
var errorCode:int = 0;
var errormsg:String = "";

# Graphics
# windowed, borderless_windowed, fullscreen, exclusive_fullscreen.
var fullscreen_mode:String = "fullscreen";
## The window resolultion.[br]
## It only scales the viewport if changed beyond or below 1080p.
var resolution:Vector2i = Vector2i(1920, 1080);
## The maximum framerate.[br]
## The framerate is limited to an integer value.[br]
## When set to [code]0[/code], the engine's framerate will be unlocked.
var max_framerate:int = 0;

# Gameplay
var fps_counter:bool = false; 

# Audio
## Master Volume
var volume:float = 100.0; # Master
## Music Volume
var musicVolume:float = 100.0;
## SFX / Voices Audio
var sfxVolume:float = 100.0;

## Gets called when [member Settings._apply_settings()] is called.[br]
## Use this to reflect settings changes in your object or code.
signal apply_new_settings();

func _delete_saves() -> Error:
	var err:Error = DirAccess.remove_absolute(save_file);
	if err != OK: return err;
	return OK;

## Saves engine variables and settings to save file.[br]
## The file can be located at ```user://Project/EngineSettings.sav```.
func _save_settings() -> Error:
	# Setup Save
	var save_items:Dictionary = {
		"key" : secret,
		"fullscreen_mode" : fullscreen_mode,
		"resolution" : {
			"width": resolution.x,
			"height": resolution.y
		},
		"audio": {
			"master": volume,
			"music": musicVolume,
			"sfx": sfxVolume
		},
		"max_framerate" : max_framerate,
		"debug" : debug
	};
	# Save to File
	if !DirAccess.dir_exists_absolute(save_dir):
		if DirAccess.make_dir_absolute(save_dir) != Error.OK: return DirAccess.get_open_error();
	var save_write:FileAccess = FileAccess.open(save_file, FileAccess.WRITE);
	var json_string:String = JSON.stringify(save_items, "    ", false);
	var _b:bool = save_write.store_line(json_string);
	save_write.close();
	if save_write.get_error() != OK && save_write.get_error() != null: return save_write.get_error();
	elif save_write.get_error() == null: return FileAccess.get_open_error();
	return OK;

"""
func _set_resolution(x_res:int = -1, y_res:int = -1, fullscreen:String = "windowed") -> void:
	if (x_res == -1):
		if (y_res == -1):
			
			pass
		pass
	pass
"""

## Applies all the currently set settings.
func _apply_settings() -> void:
	DisplayServer.window_set_size(resolution);

	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false);
	match fullscreen_mode:
		"borderless_windowed":
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true);
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
			pass
		"fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
			pass
		"exclusive_fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
			pass
		_: # Default, windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
			pass

	#match story_mode:
		#0: story = "Campaign";
		#_: story = "null";

	Engine.max_fps = max_framerate;

	# Reminder not to confuse percentages with dbs.
	if volume > 100: volume = 75;
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(clampf(volume/100, 0.0,1.0)));
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(clampf(musicVolume/100, 0.0,1.0)));
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(clampf(sfxVolume/100, 0.0,1.0)));
	
	apply_new_settings.emit();
	pass

## Loads the engine/settings save file.
func _load_settings() -> Error:
	# Load Data from File
	if not FileAccess.file_exists(save_file):
		_save_flag = true;
		if debug:
			push_warning("Settings -> Load Settings: No save to load!");
			print_debug("Settings -> Load Settings: Loading default values!");
	var save_read:FileAccess = FileAccess.open(save_file, FileAccess.READ);
	if save_read == null: return FileAccess.get_open_error();
	
	var json_pstring:String = save_read.get_as_text();
	#json_pstring.replace("\n", "");

	# Creates the helper class to interact with JSON
	var json:JSON = JSON.new();

	# Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result:Error = json.parse(json_pstring);
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_pstring, " at line ", json.get_error_line());
		#LevelManager.errCode = parse_result
		return parse_result;

	var parsed_data:Dictionary = json.get_data();
	
	if !parsed_data.has("key"):
		_save_flag = true;
		_apply_settings();
		print("Settings -> Invalid save file data. The save is either too old or is corrupted.");
		return Error.ERR_INVALID_DATA;
	
	#TODO: Refactor upgrade code, there's a lot of dupe code here.
	# Check if save is the correct version.
	if parsed_data["key"] != secret:
		if false:
			pass
		else:
			#LevelManager.error("Invalid Save File!");
			pass
		pass
	else:
		fullscreen_mode = parsed_data["fullscreen_mode"];
		resolution = Vector2i(parsed_data["resolution"]["width"], parsed_data["resolution"]["height"]);
		volume = parsed_data["audio"]["master"];
		musicVolume = parsed_data["audio"]["music"];
		sfxVolume = parsed_data["audio"]["sfx"];
		# Removed in v2
		#story_mode = parsed_data["story"];
		max_framerate = parsed_data["max_framerate"];
		debug = parsed_data["debug"];
		pass
	
	_apply_settings();
	return OK;

func change(key:String, value:Variant=null, value2:Variant=null, save_settings:bool=false) -> void:
	match key:
		"max_framerate", "fps":
			if value != null and int(value) <= 0:
				max_framerate = 60;
				Engine.max_fps = max_framerate;
				printerr("Settings (change) -> Invalid Framerate! Using default. (60)");
				print("Settings -> New FPS: " + var_to_str(max_framerate));
			elif value != null:
				max_framerate = int(value);
				Engine.max_fps = max_framerate;
				print("Settings (change) -> New FPS: " + var_to_str(max_framerate));
			pass
		"resolution", "res":
			if value2 != null:
				var new_res:Vector2i = Vector2i(int(value), int(value2));
				DisplayServer.window_set_size(new_res);
			else:
				printerr("Settings (change) -> Invalid resolution!");
		"master_volume":
			if (value != null):
				volume = value;
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(clampf(volume/100, 0.0,1.0)));
				pass
		_:
			printerr("Settings (change) -> Invalid setting key!");
	if save_settings && _save_settings() != OK: LevelManager.error("Save error during settings save!");
	pass

## Saves the current settings, then applies them.
func save_and_apply() -> void:
	_save_settings();
	_apply_settings();
	pass

func _ready() -> void:
	#ErrorScene.hide();
	if _load_settings() != OK:
		print("Settings Error!");
		LevelManager.error();
		pass
	if _save_flag:
		if _save_settings() != OK:
			LevelManager.error("Save error during settings save!");
			pass
		pass
	pass
