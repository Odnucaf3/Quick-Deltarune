extends Interactable_Script
class_name Item_Script
#-------------------------------------------------------------------------------
@export var pickable_consumableitem: Array[Item_Serializable]
@export var pickable_equipitem: Array[Equip_Serializable]
@export var pickable_keyitem: Array[Key_Item_Serializable]
#-------------------------------------------------------------------------------
func _ready() -> void:
	if(singleton.world_2d.key_dictionary.get(singleton.world_2d.Get_Item_Script_ID(self), 0) == 1):
		queue_free()
#-------------------------------------------------------------------------------
func Interactable_Action():
	singleton.world_2d.PickUp_Item(self)
#-------------------------------------------------------------------------------
