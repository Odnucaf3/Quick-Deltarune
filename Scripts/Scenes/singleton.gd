extends Node
class_name Singleton
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
@export var optionMenu: Option_Menu
#-------------------------------------------------------------------------------
@export_group("Audio and SFXs")
@export var sfx_Selected : AudioStreamPlayer
@export var sfx_Submited : AudioStreamPlayer
@export var sfx_Canceled : AudioStreamPlayer
#-------------------------------------------------------------------------------
@export var bgmPlayer : AudioStreamPlayer
#-------------------------------------------------------------------------------
@export var stage1: AudioStream
@export var battle1: AudioStream
#-------------------------------------------------------------------------------
var playPosition: float = 0.0
#-------------------------------------------------------------------------------
const submitInput: String = "ui_accept"
const cancelInput: String = "ui_cancel"
#-------------------------------------------------------------------------------
const saveData_name : String = "Save"
const saveData_path : String = "user://Save/"
var currentSaveData_Json: Dictionary;
#-------------------------------------------------------------------------------
@export var playerResource: Array[Party_Member]		# Array[PlayerResource]
#-------------------------------------------------------------------------------
var currentFocus: Control
#-------------------------------------------------------------------------------
const titleScene_Path: StringName = "res://Nodes/Scenes/title_scene.tscn"
const mainScene_Path: StringName = "res://Nodes/Scenes/main_scene.tscn"
const gameScene_Path: StringName = "res://Nodes/Scenes/game_scene.tscn"
#-------------------------------------------------------------------------------
@export var fps: Label
#-------------------------------------------------------------------------------
var maxSave: int = 9
var maxPlayer: int = 0
#endregion
#-------------------------------------------------------------------------------
#region MONOBEHAVIOUR
#-------------------------------------------------------------------------------
func _ready():
	optionMenu.Start()
#-------------------------------------------------------------------------------
func _process(_delta:float):
	#Set_FullScreen()
	#Set_Vsync()
	#Set_MouseMode()
	ResetGame()
	fps.text = PlayerInfo()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PLAYER DATA SAVE SYSTEM
#-------------------------------------------------------------------------------
func SaveCurrent_SaveData_Json():
	Save_SaveData_Json(int(optionMenu.optionSaveData_Json["saveIndex"]))
#-------------------------------------------------------------------------------
func Save_SaveData_Json(_index:int):
	DirAccess.make_dir_absolute(saveData_path)
	#-------------------------------------------------------------------------------
	var _jsonString :String = JSON.stringify(currentSaveData_Json)
	#-------------------------------------------------------------------------------
	var _jsonFile: FileAccess = FileAccess.open(Get_SaveDataPath_Json(_index),FileAccess.WRITE)
	_jsonFile.store_line(_jsonString)
	_jsonFile.close()
#-------------------------------------------------------------------------------
func Delete_SaveData_Json(_i:int) -> void:
	var _path: String = Get_SaveDataPath_Json(_i)
	#-------------------------------------------------------------------------------
	if(ResourceLoader.exists(_path)):
		DirAccess.remove_absolute(_path)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func LoadCurrent_SaveData_Json() -> Dictionary:
	return Load_SaveData_Json(int(optionMenu.optionSaveData_Json["saveIndex"]))
#-------------------------------------------------------------------------------
func Load_SaveData_Json(_i:int) -> Dictionary:
	var _path: String = Get_SaveDataPath_Json(_i)
	#-------------------------------------------------------------------------------
	if(ResourceLoader.exists(_path)):
		var _jsonFile: FileAccess = FileAccess.open(_path, FileAccess.READ)
		var _jsonString: String = _jsonFile.get_as_text()
		_jsonFile.close()
		var _saveData: Dictionary = JSON.parse_string(_jsonString)
		return _saveData
	#-------------------------------------------------------------------------------
	else:
		return CreateNew_SaveData_Json()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func CreateNew_SaveData_Json() -> Dictionary:
	var _saveData: Dictionary = {}
	#-------------------------------------------------------------------------------
	return _saveData
#-------------------------------------------------------------------------------
func Get_SaveDataPath_Json(_i:int) -> String:
	var _path: String = saveData_path+saveData_name+str(_i)+".json"
	return _path
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region UI FUNCTIONS
func PlayerInfo() -> String:
	var _s: String = ""
	_s += str(Engine.get_frames_per_second()) + " fps."
	return _s
#endregion
#-------------------------------------------------------------------------------
#region SET THE BUTTONS SIGNALS
func Set_Button(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.pressed.connect(_submited)
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_Button(_b:Button) -> void:
	Disconnect_All(_b.focus_entered)
	Disconnect_All(_b.pressed)
	Disconnect_All(_b.gui_input)
#-------------------------------------------------------------------------------
func Set_OptionButtons(_ob:OptionButton, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
	Disconnect_OptionButtons(_ob)
	#-------------------------------------------------------------------------------
	_ob.focus_entered.connect(_selected)
	_ob.item_selected.connect(_submited)
	#-------------------------------------------------------------------------------
	_ob.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_OptionButtons(_ob:OptionButton):
	Disconnect_All(_ob.focus_entered)
	Disconnect_All(_ob.item_selected)
	Disconnect_All(_ob.gui_input)
#-------------------------------------------------------------------------------
func Set_CheckButton(_cb:CheckButton, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
	Disconnect_CheckButton(_cb)
	#-------------------------------------------------------------------------------
	_cb.focus_entered.connect(_selected)
	_cb.toggled.connect(_submited)
	#-------------------------------------------------------------------------------
	_cb.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_CheckButton(_cb:CheckButton):
	Disconnect_All(_cb.focus_entered)
	Disconnect_All(_cb.toggled)
	Disconnect_All(_cb.gui_input)
#-------------------------------------------------------------------------------
func Set_Slider(_sl:Slider,  _selected:Callable,  _submited:Callable,  _canceled:Callable) -> void:
	Disconnect_Slider(_sl)
	#-------------------------------------------------------------------------------
	_sl.focus_entered.connect(_selected)
	_sl.value_changed.connect(_submited)
	#-------------------------------------------------------------------------------
	_sl.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_Slider(_sl:Slider):
	Disconnect_All(_sl.focus_entered)
	Disconnect_All(_sl.value_changed)
	Disconnect_All(_sl.gui_input)
#-------------------------------------------------------------------------------
func Set_TabBar(_tb:TabBar, _selected:Callable, _canceled:Callable) -> void:
	Disconnect_TabBar(_tb)
	#-------------------------------------------------------------------------------
	_tb.focus_entered.connect(_selected)
	_tb.tab_changed.connect(func(_tab:int):_selected.call())
	#-------------------------------------------------------------------------------
	_tb.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_TabBar(_tb:TabBar) -> void:
	Disconnect_All(_tb.focus_entered)
	Disconnect_All(_tb.tab_changed)
	Disconnect_All(_tb.gui_input)
#-------------------------------------------------------------------------------
func Disconnect_All(_signal:Signal):
	var _dictionaryArray : Array = _signal.get_connections()
	#-------------------------------------------------------------------------------
	for _dictionary in _dictionaryArray:
		_signal.disconnect(_dictionary["callable"])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region UI COMMON FUNCTIONALITY
func Move_to_Button(_b) -> void:
	currentFocus = _b
	_b.grab_focus()
#-------------------------------------------------------------------------------
func Move_to_Last_Button(_b:Array[Button]) -> void:
	Move_to_Button(_b[_b.size()-1])
#-------------------------------------------------------------------------------
func Move_to_First_Button(_array:Array[Button]) -> void:
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		if(_array[_i].is_visible_in_tree()):
			Move_to_Button(_array[_i])
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Play_BGM(_bgm:AudioStream) -> void:
	bgmPlayer.stream = _bgm
	bgmPlayer.play()
#-------------------------------------------------------------------------------
func Common_Selected() -> void:
	sfx_Selected.play()
#-------------------------------------------------------------------------------
func Common_Submited() -> void:
	sfx_Submited.play()
#-------------------------------------------------------------------------------
func Common_Canceled() -> void:
	sfx_Canceled.play()
#endregion
#-------------------------------------------------------------------------------
#region DEBUG INPUTS
func Set_FullScreen() -> void:
	if(Input.is_action_just_pressed("Debug_FullScreen")):
		var _wm: DisplayServer.WindowMode = DisplayServer.window_get_mode()
		if(_wm == DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#-------------------------------------------------------------------------------
func Set_Vsync() -> void:
	if(Input.is_action_just_pressed("Debug_Vsync")):
		var _vs: DisplayServer.VSyncMode = DisplayServer.window_get_vsync_mode()
		if(_vs == DisplayServer.VSYNC_DISABLED):
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		elif(_vs == DisplayServer.VSYNC_ENABLED):
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
#-------------------------------------------------------------------------------
func Set_MouseMode() -> void:
	if(Input.is_action_just_pressed("Debug_Mouse")):
		var _mm: Input.MouseMode = Input.mouse_mode
		if(_mm == Input.MOUSE_MODE_VISIBLE):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif(_mm == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#-------------------------------------------------------------------------------
func ResetGame() -> void:
	if(Input.is_action_just_pressed("Debug_Reset")):
		get_tree().reload_current_scene()
#endregion
#-------------------------------------------------------------------------------
