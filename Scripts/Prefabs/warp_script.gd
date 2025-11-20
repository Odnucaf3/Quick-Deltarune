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
	var _game_scene: Game_Scene = current_room.game_scene
	#-------------------------------------------------------------------------------
	if(_body == _game_scene.player[0]):
		#var _new_room: Room_Script = next_room_prefab.instantiate() as Room_Script
		var _new_room: Room_Script = load("res://Nodes/Prefabs/Rooms/"+room_name+".tscn").instantiate() as Room_Script
		_new_room.game_scene = _game_scene
		#-------------------------------------------------------------------------------
		for _i in _game_scene.player.size():
			_game_scene.player[_i].position = _new_room.warp_array[room_warp_index].position
		#-------------------------------------------------------------------------------
		_game_scene.room_test = _new_room
		#_game_scene.world2d.add_child(_new_room)
		_game_scene.world2d.call_deferred("add_child", _new_room)
		_new_room.Set_Room()
		_game_scene.camera.position = _game_scene.Camera_Set_Target_Position()
		current_room.queue_free()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
