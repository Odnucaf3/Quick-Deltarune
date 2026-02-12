extends Node2D
class_name Room_Script
#-------------------------------------------------------------------------------
@export var room_limits: Control
var room_id: String
#-------------------------------------------------------------------------------
var limit_top: float
var limit_botton: float
var limit_left: float
var limit_right: float
#-------------------------------------------------------------------------------
func Set_Room(_world_2d: World_2D):
	Set_Camera_Limits(_world_2d)
#-------------------------------------------------------------------------------
func Set_Camera_Limits(_world_2d: World_2D):
	limit_top = room_limits.global_position.y + _world_2d.camera_center.y
	limit_botton = room_limits.global_position.y + room_limits.size.y - _world_2d.camera_center.y
	limit_left = room_limits.global_position.x + _world_2d.camera_center.x
	limit_right = room_limits.global_position.x + room_limits.size.x - _world_2d.camera_center.x
	#-------------------------------------------------------------------------------
	var _center_x: float = room_limits.global_position.x + room_limits.size.x *0.5
	var _center_y: float = room_limits.global_position.y + room_limits.size.y *0.5
	#-------------------------------------------------------------------------------
	if(limit_top > _center_y): limit_top = _center_y
	if(limit_botton < _center_y): limit_botton = _center_y
	if(limit_left > _center_x): limit_left = _center_x
	if(limit_right < _center_x): limit_right = _center_x
#-------------------------------------------------------------------------------
func Get_Item_Script_ID(_node:Node) -> String:
	var _s: String = room_id+"_"+_node.name
	return _s
#-------------------------------------------------------------------------------
