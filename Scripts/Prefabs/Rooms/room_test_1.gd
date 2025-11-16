extends Node2D
class_name Room_Script
#-------------------------------------------------------------------------------
@export var camera_limits: Control
@export var enemy: Array[Party_Member]
#-------------------------------------------------------------------------------
func Check_for_Enemy(_game_scene: Game_Scene):
	#-------------------------------------------------------------------------------
	if(_game_scene.player[0].position.distance_to(enemy[0].position) < 60 and _game_scene.can_enter_fight):
		_game_scene.enemy.clear()
		#-------------------------------------------------------------------------------
		for _i in enemy.size():
			_game_scene.enemy.append(enemy[_i])
		#-------------------------------------------------------------------------------
		_game_scene.EnterBattle()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
