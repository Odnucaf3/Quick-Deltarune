extends Node2D
class_name Room_Script
#-------------------------------------------------------------------------------
var game_scene: Game_Scene
@export var camera_limits: Control
@export var enemy: Array[Party_Member]
@export var warp_array: Array[Warp_Script]

var limit_top: float
var limit_botton: float
var limit_left: float
var limit_right: float
#-------------------------------------------------------------------------------
func Set_Room():
	Set_Camera_Limits()
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].playback = enemy[_i].animation_tree.get("parameters/playback")
		game_scene.PlayAnimation(enemy[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = game_scene.enemy_ui_prefab.instantiate() as Party_Member_UI
		enemy[_i].party_member_ui = _party_member_ui
		enemy[_i].party_member_ui.hide()
		enemy[_i].party_member_ui.button_pivot.hide()
		enemy[_i].party_member_ui.label_sp.hide()
		enemy[_i].party_member_ui.bar_sp.hide()
		game_scene.battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
	for _i in warp_array.size():
		warp_array[_i].body_entered.connect(warp_array[_i].Move_to_Next_Room)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Camera_Limits():
	limit_top = camera_limits.global_position.y + game_scene.viewport_center.y
	limit_botton = camera_limits.global_position.y + camera_limits.size.y - game_scene.viewport_center.y
	limit_left = camera_limits.global_position.x + game_scene.viewport_center.x
	limit_right = camera_limits.global_position.x + camera_limits.size.x - game_scene.viewport_center.x
	#-------------------------------------------------------------------------------
	var _center_x: float = camera_limits.global_position.x + camera_limits.size.x *0.5
	var _center_y: float = camera_limits.global_position.y + camera_limits.size.y *0.5
	#-------------------------------------------------------------------------------
	if(limit_top > _center_y): limit_top = _center_y
	if(limit_botton < _center_y): limit_botton = _center_y
	if(limit_left > _center_x): limit_left = _center_x
	if(limit_right < _center_x): limit_right = _center_x
func Check_for_Enemy(_game_scene: Game_Scene):
	if(enemy.size() > 0):
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
#-------------------------------------------------------------------------------
