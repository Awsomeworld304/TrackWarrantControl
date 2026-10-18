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

var current_scene:String = "";
var previous_scene:String = "";

signal level_changed;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cycle_scenes();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass

func cycle_scenes() -> void:
	# Set previous scene.
	previous_scene = current_scene;
	# Get new current scene.
	if (get_tree().current_scene != null): current_scene = get_tree().current_scene.name;
	print("LevelManager -> Current Scene: " + current_scene);
	pass

## Custom scene changer.[br]
## Paramaters:[br]
## level (String) - The file name of the level.[br]
## object (Bool) - Specifies if the loaded scene is an object.[br]
## global (Bool) - Specifies if the loaded scene is a global scene.
func change_level(level : String, global:bool = false) -> void:
	var levelPath:String = "";
	if global: levelPath = "res://Autoloads/" + level + ".tscn";
	else: levelPath = "res://Source/" + level + ".tscn";
	
	match level:
		"": printerr("LevelManager: Invalid args for level!"); return;
		_:
			if !ResourceLoader.exists(levelPath, "PackedScene"): printerr("LevelManager: Level not found!"); return;
			if Settings.debug: print_debug("Loading " + level + "...");
	# Wait for last frame. (4.2+ | Fixes transitions.)
	await get_tree().process_frame;
	var _err:Error = get_tree().change_scene_to_file(levelPath);
	await get_tree().tree_changed;
	cycle_scenes();
	level_changed.emit();
	pass

func change_level_raw(level : String) -> void:
	var levelPath:String = level;
	
	match level:
		"": printerr("LevelManager: Invalid args for level!"); return;
		_:
			if !ResourceLoader.exists(levelPath, "PackedScene"): printerr("LevelManager: Level not found!"); return;
			if Settings.debug: print_debug("Loading " + level + "...");
	# Wait for last frame. (4.2+ | Fixes transitions.)
	await get_tree().process_frame;
	var _err:Error = get_tree().change_scene_to_file(levelPath);
	await get_tree().tree_changed;
	cycle_scenes();
	level_changed.emit();
	pass

## Restarts current scene.
func reload(restart_to_main:bool = false) -> void:
	if get_tree().paused == true: get_tree().paused = false;
	await get_tree().process_frame;
	if restart_to_main:
		var _err:Error = get_tree().change_scene_to_file("res://main.tscn");
		# FIXME: Broken on Linux?
		#_err = Settings._load_settings();
	else: var _err:Error = get_tree().reload_current_scene();

func hard_restart() -> void:
	#OS.execute_with_pipe(OS.get_executable_path(), []);
	OS.create_instance([]);
	quit(0);
	pass

func quit(code:int = 0) -> void:
	get_tree().quit(code);
	pass

func trans(level:String, global:bool = false, _trans_name:String = "default") -> void:
	match _trans_name:
		_:
			#(FPS as FPS).fix_scale();
			change_level(level, global);
			await level_changed;
			pass
	pass

## Custom scene loader.[br]
## Use this instead of change_level or trans.[br]
## Paramaters:[br]
## level (String) - The file name of the level.[br]
## stage = false (bool)
func load_scene(level:String, stage:bool = false) -> void:
	trans(("Stages/" + level) if stage else level, false);
	pass

func error(_msg:String = "Unknown Fatal Error!") -> void:
	LevelManager.trans("Source/Common/Scenes/ErrorScene", true);
	#ErrorScene.change_error(msg);
	pass
