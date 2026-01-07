extends Interactable_Script
class_name  SaveSpot_Script
#-------------------------------------------------------------------------------
@export_multiline var dialogue: String
@export var animation_player: AnimationPlayer
#-------------------------------------------------------------------------------
func Interactable_Ready(_world_2d:World_2D):
	#-------------------------------------------------------------------------------
	if(Chek_if_savespot_was_activated(_world_2d)):
		animation_player.play("Turn_On")
	#-------------------------------------------------------------------------------
	else:
		animation_player.play("Turn_Off")
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Chek_if_savespot_was_activated(_world_2d:World_2D) -> bool:
	var _array: Array = _world_2d.singleton.currentSaveData_Json.get("teleport_options", [])
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		if(_array[_i]["room"] == _world_2d.room_test.room_id and _array[_i]["savespot"] == name):
			return true
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return false
#-------------------------------------------------------------------------------
func Interactable_Action(_world_2d:World_2D):
	if(Chek_if_savespot_was_activated(_world_2d)):
		_world_2d.SaveMenu_Open(name, dialogue)
	else:
		animation_player.play("Turn_On")
		_world_2d.Add_New_SaveSpot_for_Teleporting_Options(name)
		_world_2d.SaveMenu_Open(name, dialogue)
#-------------------------------------------------------------------------------
