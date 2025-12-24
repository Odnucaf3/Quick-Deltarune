extends Area2D
class_name Warp_Script
#-------------------------------------------------------------------------------
@export var current_room: Room_Script
@export var room_name: StringName = "room_test_01"
@export var room_warp_index: int = 0
#@export var next_room_prefab: PackedScene
#-------------------------------------------------------------------------------
@export var collider: CollisionShape2D
#-------------------------------------------------------------------------------
func Move_to_Next_Room(_body:Node2D):
	var _world_2d: World_2D = current_room.world_2d
	#-------------------------------------------------------------------------------
	if(_body == _world_2d.player_characterbody2d):
		#var _new_room: Room_Script = next_room_prefab.instantiate() as Room_Script
		var _new_room: Room_Script = load("res://Nodes/Prefabs/Rooms/"+room_name+".tscn").instantiate() as Room_Script
		_new_room.world_2d = _world_2d
		#-------------------------------------------------------------------------------
		for _i in _world_2d.friend_party.size():
			_world_2d.PlayAnimation(_world_2d.friend_party[_i].playback, "Idle")
			_world_2d.friend_party[_i].is_Moving = false
			#-------------------------------------------------------------------------------
			if(_i > 0):
				_world_2d.friend_party[_i].position = _new_room.warp_array[room_warp_index].position
			#-------------------------------------------------------------------------------
			else:
				_world_2d.player_characterbody2d.position = _new_room.warp_array[room_warp_index].position
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		_world_2d.room_test = _new_room
		_world_2d.call_deferred("add_child", _new_room)
		_new_room.Set_Room()
		_world_2d.camera.position = _world_2d.Camera_Set_Target_Position()
		current_room.queue_free()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
