extends Node
class_name Title_Scene
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
@export var title_menu: Control
@export var title_menu_button_array: Array[Button]
@export var credit_menu: Control
@export var credit_menu_ricktext: RichTextLabel
@export var credit_menu_button: Button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func _ready() -> void:
	title_menu.show()
	credit_menu.hide()
	credit_menu_ricktext.meta_clicked.connect(func(_meta:Variant):_richtextlabel_on_meta_clicked(_meta))
	singleton.Play_BGM(singleton.title_bgm)
	singleton.Move_to_Button(title_menu_button_array[0])
	singleton.Set_Button(title_menu_button_array[0], func():singleton.Common_Selected(), func():Title_Menu_Start_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	singleton.Set_Button(title_menu_button_array[1], func():singleton.Common_Selected(), func():Title_Menu_Option_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	singleton.Set_Button(title_menu_button_array[2], func():singleton.Common_Selected(), func():Title_Menu_Credit_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	singleton.Set_Button(title_menu_button_array[3], func():singleton.Common_Selected(), func():Title_Menu_Quit_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	#-------------------------------------------------------------------------------
	var _selected: Callable = func(): singleton.Common_Selected()
	var _submit: Callable = func(): pass
	var _cancel: Callable = func(): Credit_Menu_Back_Button_Cancel()
	var _up: Callable = func():
		var _old_value: float = credit_menu_ricktext.get_v_scroll_bar().value
		credit_menu_ricktext.get_v_scroll_bar().value -= 42
		#-------------------------------------------------------------------------------
		if(credit_menu_ricktext.get_v_scroll_bar().value < _old_value):
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	var _down: Callable = func():
		var _old_value: float = credit_menu_ricktext.get_v_scroll_bar().value
		credit_menu_ricktext.get_v_scroll_bar().value += 42
		#-------------------------------------------------------------------------------
		if(credit_menu_ricktext.get_v_scroll_bar().value > _old_value):
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	var _left: Callable = func(): pass
	var _right: Callable = func(): pass
	#-------------------------------------------------------------------------------
	singleton.Set_Button_Ud_Down_Left_Right(credit_menu_button, _selected, _submit, _cancel, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func Title_Menu_Start_Button_Submit():
	singleton.Common_Submited()
	get_tree().change_scene_to_file("res://Nodes/Scenes/game_scene.tscn")
#-------------------------------------------------------------------------------
func Title_Menu_Option_Button_Submit():
	singleton.optionMenu.show()
	singleton.Set_Button(singleton.optionMenu.back, func():singleton.Common_Selected(), func():Option_Menu_Back_Button_Submit(), func():Option_Menu_Back_Button_Cancel())
	title_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(singleton.optionMenu.back)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Title_Menu_Credit_Button_Submit() -> void:
	credit_menu.show()
	title_menu.hide()
	singleton.Move_to_Button(credit_menu_button)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Title_Menu_Quit_Button_Submit():
	singleton.Common_Submited()
	get_tree().quit()
#-------------------------------------------------------------------------------
func Title_Menu_Any_Button_Cancel():
	singleton.Move_to_Button(title_menu_button_array[3])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func Option_Menu_Back_Button_Submit():
	Option_Menu_Back_Button_Common()
	singleton.Move_to_Button(title_menu_button_array[1])
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Option_Menu_Back_Button_Cancel():
	Option_Menu_Back_Button_Common()
	singleton.Move_to_Button(title_menu_button_array[1])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func Option_Menu_Back_Button_Common() -> void:
	singleton.optionMenu.Save_OptionSaveData_Json()
	singleton.optionMenu.hide()
	Set_Idiome()
	title_menu.show()
#-------------------------------------------------------------------------------
func Set_Idiome():
	pass
#-------------------------------------------------------------------------------
func Credit_Menu_Back_Button_Cancel():
	credit_menu.hide()
	title_menu.show()
	singleton.Move_to_Button(title_menu_button_array[2])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func _richtextlabel_on_meta_clicked(_meta:Variant):
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at runtime.
	OS.shell_open(str(_meta))
#-------------------------------------------------------------------------------
