extends CharacterBody2D
class_name Enemy_Chaser
#-------------------------------------------------------------------------------
@export var collider: CollisionShape2D
@export var player_detector_area2d: Area2D
@export var enemy: Array[Party_Member]
#-------------------------------------------------------------------------------
func Set_Enemies(_world_2d: World_2D):
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].playback = enemy[_i].animation_tree.get("parameters/playback")
		_world_2d.PlayAnimation(enemy[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = _world_2d.enemy_ui_prefab.instantiate() as Party_Member_UI
		enemy[_i].party_member_ui = _party_member_ui
		enemy[_i].party_member_ui.hide()
		enemy[_i].party_member_ui.button_pivot.hide()
		enemy[_i].party_member_ui.label_sp.hide()
		enemy[_i].party_member_ui.bar_sp.hide()
		_world_2d.battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Enter_Battle(_world_2d: World_2D):
	_world_2d.enemy_party.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		_world_2d.enemy_party.append(enemy[_i])
	#-------------------------------------------------------------------------------
	_world_2d.clearbattle_callable = func():
		_world_2d.bool_dictionary.set(_world_2d.room_test.Get_Item_Script_ID(self), true)
		collider.set_deferred("disabled", true)
		_world_2d.clearbattle_callable = func(): pass
	#-------------------------------------------------------------------------------
	_world_2d.EnterBattle()
#-------------------------------------------------------------------------------
