extends Interactable_Script
class_name  Warp_Script
#-------------------------------------------------------------------------------
@export var room_name: StringName = "room_test_01"
@export var warp_name: StringName
@export var offset: Node2D
#-------------------------------------------------------------------------------
func Interactable_Action():
	singleton.game_scene.Teleport_From_1_Room_to_Another(room_name, warp_name)
#-------------------------------------------------------------------------------
