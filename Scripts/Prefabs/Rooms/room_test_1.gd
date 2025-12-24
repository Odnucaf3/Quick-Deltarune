extends Node2D
class_name Room_Script
#-------------------------------------------------------------------------------
var world_2d: World_2D
@export var room_limits: Control
@export var enemy_chaser: Array[Enemy_Chaser]
@export var warp_array: Array[Warp_Script]
@export var item_script_array: Array[Item_Script]
#-------------------------------------------------------------------------------
var limit_top: float
var limit_botton: float
var limit_left: float
var limit_right: float
#-------------------------------------------------------------------------------
func Set_Room():
	Set_Camera_Limits()
	#-------------------------------------------------------------------------------
	for _i in enemy_chaser.size():
		#-------------------------------------------------------------------------------
		if(world_2d.bool_dictionary.get(Get_Item_Script_ID(enemy_chaser[_i]), false) == true):
			enemy_chaser[_i].queue_free()
		#-------------------------------------------------------------------------------
		else:
			enemy_chaser[_i].Set_Enemies(world_2d)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in warp_array.size():
		warp_array[_i].body_entered.connect(warp_array[_i].Move_to_Next_Room)
	#-------------------------------------------------------------------------------
	for _i in item_script_array.size():
		if(world_2d.bool_dictionary.get(Get_Item_Script_ID(item_script_array[_i]), false) == true):
			item_script_array[_i].queue_free()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Camera_Limits():
	limit_top = room_limits.global_position.y + world_2d.camera_center.y
	limit_botton = room_limits.global_position.y + room_limits.size.y - world_2d.camera_center.y
	limit_left = room_limits.global_position.x + world_2d.camera_center.x
	limit_right = room_limits.global_position.x + room_limits.size.x - world_2d.camera_center.x
	#-------------------------------------------------------------------------------
	var _center_x: float = room_limits.global_position.x + room_limits.size.x *0.5
	var _center_y: float = room_limits.global_position.y + room_limits.size.y *0.5
	#-------------------------------------------------------------------------------
	if(limit_top > _center_y): limit_top = _center_y
	if(limit_botton < _center_y): limit_botton = _center_y
	if(limit_left > _center_x): limit_left = _center_x
	if(limit_right < _center_x): limit_right = _center_x
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Item_Script_ID(_node:Node) -> String:
	var _s: String = name+"_"+_node.name
	return _s
#-------------------------------------------------------------------------------
