extends Node
class_name Title_Scene
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
@export var title_menu: Control
@export var title_menu_label: Label
@export var title_menu_button_array: Array[Button]
@export var credits_menu: Control
@export var credits_menu_richtext: RichTextLabel
@export var credits_menu_button: Button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MONOVEHAVIOUR
#-------------------------------------------------------------------------------
func _ready() -> void:
	Set_Idiome()
	#-------------------------------------------------------------------------------
	title_menu.show()
	credits_menu.hide()
	credits_menu_richtext.meta_clicked.connect(func(_meta:Variant):_richtextlabel_on_meta_clicked(_meta))
	singleton.Play_BGM(singleton.title_bgm)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(title_menu_button_array)
	singleton.Move_to_Button(title_menu_button_array[0])
	#-------------------------------------------------------------------------------
	singleton.Set_Button(title_menu_button_array[0], func():singleton.Common_Selected(), func():Title_Menu_Start_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	singleton.Set_Button(title_menu_button_array[1], func():singleton.Common_Selected(), func():Title_Menu_Option_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	singleton.Set_Button(title_menu_button_array[2], func():singleton.Common_Selected(), func():Title_Menu_Credit_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	singleton.Set_Button(title_menu_button_array[3], func():singleton.Common_Selected(), func():Title_Menu_Quit_Button_Submit(), func():Title_Menu_Any_Button_Cancel())
	#-------------------------------------------------------------------------------
	var _selected: Callable = func(): singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	var _submit: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func(): credits_menu_Back_Button_Cancel()
	#-------------------------------------------------------------------------------
	var _up: Callable = func():
		singleton.Scroll_Richtext_Up(credits_menu_richtext)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		singleton.Scroll_Richtext_Down(credits_menu_richtext)
	#-------------------------------------------------------------------------------
	var _left: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _right: Callable = func(): pass
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(credits_menu_button)
	singleton.Set_Button_Up_Down_Left_Right(credits_menu_button, _selected, _submit, _cancel, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TITLE MENU
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
	credits_menu.show()
	title_menu.hide()
	credits_menu_richtext.get_v_scroll_bar().value = 0
	singleton.Move_to_Button(credits_menu_button)
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
#endregion
#-------------------------------------------------------------------------------
#region OPTION MENU
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
	#-------------------------------------------------------------------------------
	title_menu_label.text = "  "+tr("title_menu_label")+"  "
	#-------------------------------------------------------------------------------
	for _i in title_menu_button_array.size():
		title_menu_button_array[_i].text = "  "+tr("title_menu_button_"+str(_i))+"  "
	#-------------------------------------------------------------------------------
	credits_menu_button.text = "  "+tr("credits_menu_button")+"  "
	credits_menu_richtext.text = tr("credits_menu_richtext")
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CREDITS MENU
#-------------------------------------------------------------------------------
func credits_menu_Back_Button_Cancel():
	credits_menu.hide()
	title_menu.show()
	singleton.Move_to_Button(title_menu_button_array[2])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MISC
#-------------------------------------------------------------------------------
func _richtextlabel_on_meta_clicked(_meta:Variant):
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at runtime.
	OS.shell_open(str(_meta))
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
