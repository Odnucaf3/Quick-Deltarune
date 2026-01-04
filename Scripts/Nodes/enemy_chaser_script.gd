extends CharacterBody2D
class_name Enemy_Chaser
#-------------------------------------------------------------------------------
@export var collider: CollisionShape2D
#-------------------------------------------------------------------------------
@export var player_detector_area2d: Area2D
@export var player_detector_collider: CollisionShape2D
#-------------------------------------------------------------------------------
@export var enemy: Array[Party_Member]
#-------------------------------------------------------------------------------
func Set_Enemies(_world_2d: World_2D):
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].playback = enemy[_i].animation_tree.get("parameters/playback")
		_world_2d.PlayAnimation(enemy[_i].playback, "Idle")
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Enter_Battle(_world_2d: World_2D):
	_world_2d.can_enter_fight = false
	_world_2d.clearbattle_callable = func(): After_Battle_Callable(_world_2d)
	#-------------------------------------------------------------------------------
	#await Dialogue_Before_Battle(_world_2d)
	#-------------------------------------------------------------------------------
	_world_2d.EnterBattle(enemy)
#-------------------------------------------------------------------------------
func Dialogue_Before_Battle(_world_2d: World_2D):
	_world_2d.Dialogue_Open()
	await _world_2d.Dialogue(true, "* Prepeare yourself for a beaten.")
	await _world_2d.Dialogue(true, "* Because I am gonna beat you.")
	_world_2d.Dialogue_Close()
#-------------------------------------------------------------------------------
func After_Battle_Callable(_world_2d: World_2D):
	_world_2d.key_dictionary.set(_world_2d.room_test.Get_Item_Script_ID(self), 1)
	collider.set_deferred("disabled", true)
	player_detector_collider.set_deferred("disabled", true)
	_world_2d.clearbattle_callable = func(): pass
	_world_2d.can_enter_fight = true
#-------------------------------------------------------------------------------
