extends Control
class_name Option_Menu
#region VARIABLES
#-------------------------------------------------------------------------------
@export var singleton: Singleton
#-------------------------------------------------------------------------------
@export var title : Label
#-------------------------------------------------------------------------------
@export var idiome_label : Label
@export var idiome_optionbutton : OptionButton
#-------------------------------------------------------------------------------
@export var resolution_label : Label
@export var resolution_optionbutton : OptionButton
#-------------------------------------------------------------------------------
@export var fullscreen_label : Label
@export var fullscreen_checkbutton : CheckButton
#-------------------------------------------------------------------------------
@export var borderless_label : Label
@export var borderless_checkbutton : CheckButton
#-------------------------------------------------------------------------------
@export var vsync_label : Label
@export var vsync_checkbutton : CheckButton
#-------------------------------------------------------------------------------
@export var master_label : Label
@export var master_number : Label
@export var master_slider : Slider
#-------------------------------------------------------------------------------
@export var sfx_label : Label
@export var sfx_number : Label
@export var sfx_slider : Slider
#-------------------------------------------------------------------------------
@export var bgm_label : Label
@export var bgm_number : Label
@export var bgm_slider : Slider
#-------------------------------------------------------------------------------
@export var back : Button
#-------------------------------------------------------------------------------
const optionSaveData_name : String = "optionSaveData"
const optionSaveData_path : String = "user://Options/"
var optionSaveData_Json : Dictionary
#-------------------------------------------------------------------------------
var bus_master_Index: int = AudioServer.get_bus_index("Master")
var bus_sfx_Index: int = AudioServer.get_bus_index("sfx")
var bus_bgm_Index: int = AudioServer.get_bus_index("bgm")
#-------------------------------------------------------------------------------
const resolution_dictionary : Dictionary = {
	"1920 x 1080": Vector2i(1920, 1080),
	"1600 x 900": Vector2i(1600, 900),
	"1366 x 768": Vector2i(1366, 768),
	"1280 x 720": Vector2i(1280, 720),
	"1024 x 576": Vector2i(1024, 576),
	"960 x 540": Vector2i(960, 540),
	"854 x 480": Vector2i(854, 480),
	"640 x 360": Vector2i(640 , 360)
}
#endregion
#-------------------------------------------------------------------------------
#region MONOVEHAVIOUR
func Start() -> void:
	optionSaveData_Json = Load_OptionSaveData_Json()
	#-------------------------------------------------------------------------------
	SetResolution_Start()
	SetIdiome_Start()
	#-------------------------------------------------------------------------------
	SetFullScreen_Start()
	SetBorderless_Start()
	SetVsync_Start()
	#-------------------------------------------------------------------------------
	Set_MasterValume_Start()
	Set_sfxValume_Start()
	Set_bgmValume_Start()
	#-------------------------------------------------------------------------------
	hide()
#endregion
#-------------------------------------------------------------------------------
#region OPTION SAVE SYSTEM
func Save_OptionSaveData_Json() -> void:
	DirAccess.make_dir_absolute(optionSaveData_path)
	var _jsonString :String = JSON.stringify(optionSaveData_Json)
	var _jsonFile: FileAccess = FileAccess.open(GetPath_OptionSaveData_Json(),FileAccess.WRITE)
	_jsonFile.store_line(_jsonString)
	_jsonFile.close()
#-------------------------------------------------------------------------------
func Load_OptionSaveData_Json() -> Dictionary:
	var _path: String = GetPath_OptionSaveData_Json()
	#-------------------------------------------------------------------------------
	if(ResourceLoader.exists(_path)):
		var _jsonFile: FileAccess = FileAccess.open(_path, FileAccess.READ)
		var _jsonString: String = _jsonFile.get_as_text()
		_jsonFile.close()
		var _optionSaveData: Dictionary = JSON.parse_string(_jsonString)
		return _optionSaveData
	#-------------------------------------------------------------------------------
	else:
		return CreateNew_OptionSaveData_Json()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func CreateNew_OptionSaveData_Json() -> Dictionary:
	var _optionSaveData: Dictionary = {}
	_optionSaveData["masterVolumen"] = 1.0
	_optionSaveData["sfxVolumen"] = 1.0
	_optionSaveData["bgmVolumen"] = 0.3
	_optionSaveData["vsync"] = true
	_optionSaveData["fullscreen"] = false
	_optionSaveData["borderless"] = false
	_optionSaveData["resolutionIndex"] = 3
	_optionSaveData["idiomeIndex"] = 0
	_optionSaveData["saveIndex"] = 0
	return _optionSaveData
#-------------------------------------------------------------------------------
func Delete_OptionSaveData_Json() -> void:
	var _path: String = GetPath_OptionSaveData_Json()
	#-------------------------------------------------------------------------------
	if(ResourceLoader.exists(_path)):
		DirAccess.remove_absolute(_path)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func GetPath_OptionSaveData_Json() -> String:
	var _path: String = optionSaveData_path+optionSaveData_name+".json"
	return _path
#endregion
#-------------------------------------------------------------------------------
#region RESOLUTION SETTINGS
func SetResolution_Start():
	SetResolution(optionSaveData_Json["resolutionIndex"])
	Center_if_Windowed()
	AddResolutionOptions(resolution_optionbutton, resolution_dictionary)
	resolution_optionbutton.select(optionSaveData_Json["resolutionIndex"])
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func(_index:int): ResolutionButton_Submited(_index)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_OptionButtons(resolution_optionbutton, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func AddResolutionOptions(_ob:OptionButton, _dictionary:Dictionary) -> void:
	_ob.clear()
	#-------------------------------------------------------------------------------
	for i in _dictionary:
		_ob.add_item("  "+i+"  ")
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func ResolutionButton_Submited(_index:int) -> void:
	singleton.Common_Submited()
	optionSaveData_Json["resolutionIndex"] = _index
	SetResolution(_index)
	Center_if_Windowed()
#-------------------------------------------------------------------------------
func SetResolution(_index:int) -> void:
	_index = clamp(_index, 0, resolution_dictionary.size())
	DisplayServer.window_set_size(resolution_dictionary.values()[_index])
#-------------------------------------------------------------------------------
func GetResolution() -> Vector2i:
	var _v2i: Vector2i = DisplayServer.window_get_size()
	return _v2i
#endregion
#-------------------------------------------------------------------------------
#region IDIOME SETTINGS
func SetIdiome_Start():
	SetIdiome(optionSaveData_Json["idiomeIndex"])
	AddIdiomeButtons(idiome_optionbutton)
	idiome_optionbutton.select(optionSaveData_Json["idiomeIndex"])
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func(_index:int): IdiomeButton_Submited(_index)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_OptionButtons(idiome_optionbutton, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func AddIdiomeButtons(_ob:OptionButton) -> void:
	var _idiomes:PackedStringArray = TranslationServer.get_loaded_locales()
	#-------------------------------------------------------------------------------
	for _i in _idiomes.size():
		_ob.add_item("  "+TranslationServer.get_locale_name(_idiomes[_i])+"  ")
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func IdiomeButton_Submited(_index:int):
	optionSaveData_Json["idiomeIndex"] = _index
	SetIdiome(_index)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func SetIdiome(_index:int):
	var _idiomes:PackedStringArray = TranslationServer.get_loaded_locales()
	TranslationServer.set_locale(_idiomes[_index])
	#-------------------------------------------------------------------------------
	title.text = tr("option_menu_label_title")
	#-------------------------------------------------------------------------------
	idiome_label.text = "* "+tr("option_menu_label_idiome")+":  "
	#-------------------------------------------------------------------------------
	resolution_label.text = "* "+tr("option_menu_label_resolution")+":  "
	fullscreen_label.text = "* "+tr("option_menu_label_fullScreen")+":  "
	borderless_label.text = "* "+tr("option_menu_label_borderless")+":  "
	#-------------------------------------------------------------------------------
	vsync_label.text = "* "+tr("option_menu_label_vSync")+":  "
	#-------------------------------------------------------------------------------
	master_label.text = "* "+tr("option_menu_label_master")+":  "
	sfx_label.text = "* "+tr("option_menu_label_sfx")+":  "
	bgm_label.text = "* "+tr("option_menu_label_bgm")+":  "
	#-------------------------------------------------------------------------------
	back.text = "  "+tr("option_menu_button_back")+"  "
#endregion
#-------------------------------------------------------------------------------
#region FULLSCREEN SETTINGS
func SetFullScreen_Start():
	var _b: bool = optionSaveData_Json["fullscreen"]
	SetFullScreen(_b)
	fullscreen_checkbutton.button_pressed = _b
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func(_bool:bool): FullScreenButton_Submited(_bool)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_CheckButton(fullscreen_checkbutton, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func FullScreenButton_Submited(_b:bool):
	singleton.Common_Submited()
	optionSaveData_Json["fullscreen"] = _b
	SetFullScreen(_b)
#-------------------------------------------------------------------------------
func SetFullScreen(_b: bool):
	#-------------------------------------------------------------------------------
	if(_b):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	#-------------------------------------------------------------------------------
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		SetResolution(optionSaveData_Json["resolutionIndex"])
		CenterScreem()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region BORDERLESS SETTINGS
func SetBorderless_Start():
	var _b: bool = optionSaveData_Json["borderless"]
	SetBorderless(_b)
	borderless_checkbutton.button_pressed = _b
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func(_bool:bool): BorderlessButton_Submited(_bool)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_CheckButton(borderless_checkbutton, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func BorderlessButton_Submited(_b:bool):
	singleton.Common_Submited()
	optionSaveData_Json["borderless"] = _b
	SetBorderless(_b)
#-------------------------------------------------------------------------------
func SetBorderless(_b: bool):
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, _b)
	SetResolution(optionSaveData_Json["resolutionIndex"])
#endregion
#-------------------------------------------------------------------------------
#region VSYNC SETTINGS
func SetVsync_Start():
	var _b: bool = optionSaveData_Json["vsync"]
	SetVsync(_b)
	vsync_checkbutton.button_pressed = _b
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func(_bool:bool): VsyncButton_Submited(_bool)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_CheckButton(vsync_checkbutton, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func VsyncButton_Submited(_b:bool) -> void:
	singleton.Common_Submited()
	optionSaveData_Json["vsync"] = _b
	SetVsync(_b)
#-------------------------------------------------------------------------------
func SetVsync(_b: bool) -> void:
	#-------------------------------------------------------------------------------
	if(_b):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	#-------------------------------------------------------------------------------
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region VOLUME SETTINGS
func Set_MasterValume_Start():
	SetValume(master_number, bus_master_Index, optionSaveData_Json["masterVolumen"])
	#-------------------------------------------------------------------------------
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_master_Index))
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit:Callable = func(_float:float): MasterSlider_Submit(_float)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Slider(master_slider, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func Set_sfxValume_Start():
	SetValume(sfx_number, bus_sfx_Index, optionSaveData_Json["sfxVolumen"])
	#-------------------------------------------------------------------------------
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_sfx_Index))
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit:Callable = func(_float:float): sfxSlider_Submit(_float)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Slider(sfx_slider, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func Set_bgmValume_Start():
	SetValume(bgm_number, bus_bgm_Index, optionSaveData_Json["bgmVolumen"])
	#-------------------------------------------------------------------------------
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_bgm_Index))
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit:Callable = func(_float:float): bgmSlider_Submit(_float)
	var _cancel: Callable = func(): AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Slider(bgm_slider, _selected, _submit, _cancel)
#-------------------------------------------------------------------------------
func MasterSlider_Submit(_value:float) -> void:
	singleton.Common_Submited()
	optionSaveData_Json["masterVolumen"] = _value
	SetValume(master_number, bus_master_Index, _value)
	pass
#-------------------------------------------------------------------------------
func sfxSlider_Submit(_value:float) -> void:
	singleton.Common_Submited()
	optionSaveData_Json["sfxVolumen"] = _value
	SetValume(sfx_number, bus_sfx_Index, _value)
#-------------------------------------------------------------------------------
func bgmSlider_Submit(_value:float) -> void:
	singleton.Common_Submited()
	optionSaveData_Json["bgmVolumen"] = _value
	SetValume(bgm_number, bus_bgm_Index, _value)
#-------------------------------------------------------------------------------
func SetValume(_label: Label, _index:int, _value:float):
	var _int: int = int(_value*100)
	_label.text = str(_int)+"%"
	AudioServer.set_bus_volume_db(_index, linear_to_db(_value))
#endregion
#-------------------------------------------------------------------------------
#region BUTTON FUNCTIONS
#-------------------------------------------------------------------------------
func AnyButton_Cancel() -> void:
	singleton.Common_Canceled()
	singleton.Move_to_Button(back)
#-------------------------------------------------------------------------------
func Center_if_Windowed():
	#-------------------------------------------------------------------------------
	if(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
		CenterScreem()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func CenterScreem():
	var _center: Vector2i = Vector2i(Vector2(DisplayServer.screen_get_size()-DisplayServer.window_get_size())/2)
	DisplayServer.window_set_position(_center)
#endregion
#-------------------------------------------------------------------------------
