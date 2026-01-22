extends Interactable_Script
class_name Item_Script
#-------------------------------------------------------------------------------
@export var pickable_consumableitem: Array[Item_Serializable]
@export var pickable_equipitem: Array[Equip_Serializable]
@export var pickable_keyitem: Array[Key_Item_Serializable]
#-------------------------------------------------------------------------------
func Interactable_Ready(_world_2d:World_2D):
	if(_world_2d.key_dictionary.get(_world_2d.Get_Item_Script_ID(self), 0) == 1):
		queue_free()
#-------------------------------------------------------------------------------
func Interactable_Action(_world_2d:World_2D):
	_world_2d.PickUp_Item(self)
#-------------------------------------------------------------------------------
