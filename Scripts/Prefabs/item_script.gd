extends Interactable_Script
class_name Item_Script
#-------------------------------------------------------------------------------
@export var pickable_consumableitem: Array[Item_Serializable]
@export var pickable_equipitem: Array[Equip_Serializable]
@export var pickable_keyitem: Array[Key_Item_Serializable]
#-------------------------------------------------------------------------------
func _ready() -> void:
	if(singleton.game_scene.key_dictionary.get(singleton.game_scene.Get_Item_Script_ID(self), 0) == 1):
		queue_free()
#-------------------------------------------------------------------------------
func Interactable_Action():
	singleton.game_scene.PickUp_Item(self)
#-------------------------------------------------------------------------------
