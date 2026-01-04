extends Interactable_Script
class_name  SaveSpot_Script
#-------------------------------------------------------------------------------
@export_multiline var savespot_description: String
#-------------------------------------------------------------------------------
func Interactable_Ready(_world_2d:World_2D):
	pass
#-------------------------------------------------------------------------------
func Interactable_Action(_world_2d:World_2D):
	_world_2d.SaveMenu_Open(name, savespot_description)
#-------------------------------------------------------------------------------
