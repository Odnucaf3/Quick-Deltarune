extends Interactable_Script
class_name  SaveSpot_Script
#-------------------------------------------------------------------------------
@export_multiline var dialogue: String
@export var animation_player: AnimationPlayer
#-------------------------------------------------------------------------------
func _ready() -> void:
	#-------------------------------------------------------------------------------
	if(Chek_if_savespot_was_activated()):
		animation_player.play("Turn_On")
	#-------------------------------------------------------------------------------
	else:
		animation_player.play("Turn_Off")
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Chek_if_savespot_was_activated() -> bool:
	var _array: Array = singleton.currentSaveData_Json.get("teleport_options", [])
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		if(_array[_i]["room"] == singleton.game_scene.room_test.room_id and _array[_i]["savespot"] == name):
			return true
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return false
#-------------------------------------------------------------------------------
func Interactable_Action():
	if(Chek_if_savespot_was_activated()):
		singleton.game_scene.SaveMenu_Open(name, dialogue)
	else:
		animation_player.play("Turn_On")
		singleton.game_scene.Add_New_SaveSpot_for_Teleporting_Options(name)
		singleton.game_scene.SaveMenu_Open(name, dialogue)
#-------------------------------------------------------------------------------
