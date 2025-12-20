extends CharacterBody2D
class_name Enemy_Chaser
#-------------------------------------------------------------------------------
@export var collider: CollisionShape2D
@export var player_detector_area2d: Area2D
@export var enemy: Array[Party_Member]
#-------------------------------------------------------------------------------
func Set_Enemies(_game_scene: Game_Scene):
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].playback = enemy[_i].animation_tree.get("parameters/playback")
		_game_scene.PlayAnimation(enemy[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = _game_scene.enemy_ui_prefab.instantiate() as Party_Member_UI
		enemy[_i].party_member_ui = _party_member_ui
		enemy[_i].party_member_ui.hide()
		enemy[_i].party_member_ui.button_pivot.hide()
		enemy[_i].party_member_ui.label_sp.hide()
		enemy[_i].party_member_ui.bar_sp.hide()
		_game_scene.battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Enter_Battle(_game_scene: Game_Scene):
	_game_scene.enemy_party.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		_game_scene.enemy_party.append(enemy[_i])
	#-------------------------------------------------------------------------------
	_game_scene.clearbattle_callable = func():
		_game_scene.bool_dictionary.set(_game_scene.room_test.Get_Item_Script_ID(self), true)
		collider.set_deferred("disabled", true)
		_game_scene.clearbattle_callable = func(): pass
	#-------------------------------------------------------------------------------
	_game_scene.EnterBattle()
#-------------------------------------------------------------------------------
