extends Node2D
class_name World_2D
#-------------------------------------------------------------------------------
enum GAME_STATE{IN_WORLD, IN_MENU, IN_BATTLE}
enum BATTLE_STATE{STILL_FIGHTING, YOU_WIN, YOU_LOSE, YOU_ESCAPE, YOU_RETRY}
#-------------------------------------------------------------------------------
#region VARIABLES
var singleton: Singleton
#-------------------------------------------------------------------------------
@export var game_scene: Game_Scene
@export var ui_theme: Theme
@export var room_test: Room_Script
#-------------------------------------------------------------------------------
@export var key_dictionary: Dictionary[String, int]
#-------------------------------------------------------------------------------
@export var tp_bar_root: Control
@export var tp_bar_progressbar_present: ProgressBar
@export var tp_bar_progressbar_future: ProgressBar
@export var tp_bar_label: Label
var tp: int
var max_tp: int
#-------------------------------------------------------------------------------
@export var can_equip_midbattle: bool = false
@export var battlemenu_equipbutton_emptyspace: Control
#-------------------------------------------------------------------------------
@export var dialogue_menu: Control
@export var dialogue_menu_speaker1: Control
@export var dialogue_menu_speaker1_image: TextureRect
@export var dialogue_menu_speaker1_name: Control
@export var dialogue_menu_speaking_label: RichTextLabel
#-------------------------------------------------------------------------------
@export var savespot_menu: Control
@export var savespot_menu_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export var ally_ui_prefab: PackedScene
@export var enemy_ui_prefab: PackedScene
#-------------------------------------------------------------------------------
@export var player_characterbody2d: CharacterBody2D
@export var player_collider: CollisionShape2D
@export var player_interactable_area2d: Area2D
@export var player_enemyDetector_area2d: Area2D
@export var friend_party: Array[Party_Member]
var friend_party_alive: Array[Party_Member]
var friend_party_dead: Array[Party_Member]
#-------------------------------------------------------------------------------
@export var enemy_party: Array[Party_Member]
var enemy_party_alive: Array[Party_Member]
var enemy_party_dead: Array[Party_Member]
#-------------------------------------------------------------------------------
@export var item_menu: TabContainer
#-------------------------------------------------------------------------------
@export var item_menu_consumable_scrollContainer: ScrollContainer
@export var item_menu_consumable_content: VBoxContainer
var item_menu_consumable_button_array: Array[Button]
@export var item_menu_consumable_title: Label
@export var item_menu_consumable_lore: RichTextLabel
@export var item_menu_consumable_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var item_menu_equipment_scrollContainer: ScrollContainer
@export var item_menu_equipment_content: VBoxContainer
var item_menu_equipment_button_array: Array[Button]
@export var item_menu_equipment_title: Label
@export var item_menu_equipment_lore: RichTextLabel
@export var item_menu_equipment_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var item_menu_keyitems_scrollContainer: ScrollContainer
@export var item_menu_keyitems_content: VBoxContainer
var item_menu_keyitems_button_array: Array[Button]
@export var item_menu_keyitems_title: Label
@export var item_menu_keyitems_lore: RichTextLabel
@export var item_menu_keyitems_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var item_array: Array[Item_Serializable]
@export var key_item_array: Array[Key_Item_Serializable]
var item_array_in_battle: Array[Item_Serializable]
@export var iten_resource_attack: Item_Serializable
@export var iten_resource_defense: Item_Serializable
#-------------------------------------------------------------------------------
@export var skill_menu_scrollContainer: ScrollContainer
@export var skill_menu_content: VBoxContainer
var skill_menu_button_array: Array[Button]
@export var skill_menu_title: Label
@export var skill_menu_lore: RichTextLabel
@export var skill_menu_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var teleporty_menu: TabContainer
@export var teleporty_menu_scrollContainer: ScrollContainer
@export var teleporty_menu_content: VBoxContainer
var teleporty_menu_button_array: Array[Button]
@export var teleporty_menu_title: Label
@export var teleporty_menu_rect: TextureRect
@export var teleporty_menu_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var equipslot_menu_content: VBoxContainer
var equipslot_menu_button_array: Array[Button]
@export var equipslot_menu_title: Label
@export var equipslot_menu_lore: RichTextLabel
@export var equipslot_menu_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var equip_array: Array[Equip_Serializable]
#-------------------------------------------------------------------------------
@export var status_menu: TabContainer
#-------------------------------------------------------------------------------
@export var status_menu_information_image: TextureRect
@export var status_menu_information_title: Label
@export var status_menu_information_lore: RichTextLabel
@export var status_menu_information_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var status_menu_stats_button_array: Array[Button]
@export var status_menu_stats_title: Label
@export var status_menu_stats_lore: RichTextLabel
@export var status_menu_stats_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var status_menu_statuseffect_content: VBoxContainer
var status_menu_statuseffect_button_array: Array[Button]
@export var status_menu_statuseffect_title: Label
@export var status_menu_statuseffect_lore: RichTextLabel
@export var status_menu_statuseffect_description: RichTextLabel
#-------------------------------------------------------------------------------
var camera_offset_y: float = 28
var current_player_turn: int = 0
@export var black_panel: Panel
@export var battle_black_panel: Panel
@export var pause_menu_panel: Panel
@export var pause_menu: Control
@export var pause_menu_button_array: Array[Button]
@export var pause_menu_party_button_array: Array[Party_Button]
var isSlowMotion: bool = false
#-------------------------------------------------------------------------------
var can_enter_fight: bool = true
var player_last_position: Array[Vector2]
var enemy_last_position: Array[Vector2]
#-------------------------------------------------------------------------------
const submitInput: String = "ui_accept"
const cancelInput: String = "ui_cancel"
@export var win_label: Label
@export var retry_menu: Control
@export var retry_menu_button: Array[Button]
#-------------------------------------------------------------------------------
@export var debug_label: Label
@export var fps_label: Label
var tween_Array: Array[Tween]
#-------------------------------------------------------------------------------
@export var camera: Camera2D
@export var hitbox: Sprite2D
@export var grazebox: Sprite2D
var can_be_hit: bool = true
var i_frames: int = 0
@export var battle_control: Control
@export var battle_menu: Control
@export var battle_menu_button: Array[Button]
@export var battle_box: Control
#-------------------------------------------------------------------------------
@export var timer_label: Label
var timer_tween: Tween
var timer: int
var main_tween_Array: Array[Tween]
#-------------------------------------------------------------------------------
var myGAME_STATE: GAME_STATE = GAME_STATE.IN_WORLD
var myBATTLE_STATE: BATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
var is_Running: bool = false
#-------------------------------------------------------------------------------
var box_limit_up: float
var box_limit_down: float
var box_limit_left: float
var box_limit_right: float
#-------------------------------------------------------------------------------
var screen_limit_up: float
var screen_limit_down: float
var screen_limit_left: float
var screen_limit_right: float
#-------------------------------------------------------------------------------
#var bulletDictionary: Dictionary[String, BulletResource]
@export var bullet_Prefab: PackedScene
var enemyBullets_Enabled_Array: Array[Bullet]
var enemyBullets_Disabled_Array: Array[Bullet]
#-------------------------------------------------------------------------------
var grazeBox_radius: float = 6.0
var hitBox_radius: float = 1.5
var canBeHit: bool = true
var camera_size: Vector2
var camera_center: Vector2
var viewport_size: Vector2
var viewport_center: Vector2
#-------------------------------------------------------------------------------
var deltaTimeScale: float = 1.0
signal dialogue_signal
var can_move: bool = true
var is_in_dialogue: bool = true
#endregion
#-------------------------------------------------------------------------------
#region MONOBEHAVIOUR
func _ready() -> void:
	singleton = get_node("/root/singleton")
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json = singleton.LoadCurrent_SaveData_Json()
	Load_Room_and_SaveSpot()
	#-------------------------------------------------------------------------------
	singleton.Play_BGM(singleton.stage1)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].playback = friend_party[_i].animation_tree.get("parameters/playback")
		PlayAnimation(friend_party[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = ally_ui_prefab.instantiate() as Party_Member_UI
		friend_party[_i].party_member_ui = _party_member_ui
		friend_party[_i].party_member_ui.hide()
		friend_party[_i].party_member_ui.button_pivot.hide()
		friend_party[_i].party_member_ui.label_sp.hide()
		friend_party[_i].party_member_ui.bar_sp.hide()
		battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
	win_label.hide()
	retry_menu.hide()
	battle_menu.hide()
	dialogue_menu.hide()
	savespot_menu.hide()
	item_menu.hide()
	teleporty_menu.hide()
	status_menu.hide()
	battle_box.hide()
	timer_label.hide()
	battle_black_panel.hide()
	tp_bar_root.hide()
	#-------------------------------------------------------------------------------
	if(can_equip_midbattle):
		battle_menu_button[4].show()
		battlemenu_equipbutton_emptyspace.hide()
	#-------------------------------------------------------------------------------
	else:
		battle_menu_button[4].hide()
		battlemenu_equipbutton_emptyspace.show()
	#-------------------------------------------------------------------------------
	var _width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var _height: float = ProjectSettings.get_setting("display/window/size/viewport_height")
	viewport_size = Vector2(_width, _height)
	viewport_center = viewport_size/2.0
	camera_size = viewport_size / camera.zoom
	camera_center = viewport_center / camera.zoom
	#-------------------------------------------------------------------------------
	room_test.Set_Room(self)
	camera.position = Camera_Set_Target_Position()
	#-------------------------------------------------------------------------------
	hitbox.global_scale = Get_CircleSprite_Scale(hitBox_radius) + Vector2(0.01, 0.01)
	grazebox.global_scale = Get_CircleSprite_Scale(grazeBox_radius) + Vector2(0.01, 0.01)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(item_menu_consumable_content)
	Destroy_Childrens(item_menu_equipment_content)
	Destroy_Childrens(item_menu_keyitems_content)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(skill_menu_content)
	Destroy_Childrens(equipslot_menu_content)
	Destroy_Childrens(status_menu_statuseffect_content)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(teleporty_menu_content)
	#-------------------------------------------------------------------------------
	Create_EnemyBullets_Disabled(2000)
	PauseMenu_Close()
	NormalMotion()
	#-------------------------------------------------------------------------------
	PauseMenu_Set()
#-------------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	tween_Array = get_tree().get_processed_tweens()
	#-------------------------------------------------------------------------------
	match(myGAME_STATE):
		GAME_STATE.IN_WORLD:
			#-------------------------------------------------------------------------------
			if(!get_tree().paused):
				Input_PauseGame()
				Player_Movement()
				Followers_Movement()
				Camera_Follow()
				#-------------------------------------------------------------------------------
				if(Input.is_action_just_pressed("ui_accept")):
					#-------------------------------------------------------------------------------
					if(is_in_dialogue):
						var _interactable_by_action_array : Array[Area2D] = player_interactable_area2d.get_overlapping_areas()
						#-------------------------------------------------------------------------------
						if(_interactable_by_action_array.size() > 0):
							var _interactable: Interactable_Script = _interactable_by_action_array[0]
							_interactable.Interactable_Action(self)
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
					else:
						dialogue_signal.emit()
					#-------------------------------------------------------------------------------
				#-------------------------------------------------------------------------------
				var _interactable_by_touch_array : Array[Area2D] = player_enemyDetector_area2d.get_overlapping_areas()
				var _enemies: Array[Interactable_Script]
				var _not_enemies: Array[Interactable_Script]
				#-------------------------------------------------------------------------------
				for _i in _interactable_by_touch_array.size():
					var _interactable_by_touch: Interactable_Script = _interactable_by_touch_array[_i] as Interactable_Script
					#-------------------------------------------------------------------------------
					if(_interactable_by_touch.is_enemy):
						_enemies.append(_interactable_by_touch)
					#-------------------------------------------------------------------------------
					else:
						_not_enemies.append(_interactable_by_touch)
					#-------------------------------------------------------------------------------
					if(_not_enemies.size() > 0):
						_not_enemies[0].Interactable_Action(self)
					#-------------------------------------------------------------------------------
					else:
						#-------------------------------------------------------------------------------
						if(_enemies.size() > 0 and can_enter_fight):
							_enemies[0].Interactable_Action(self)
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		GAME_STATE.IN_BATTLE:
			Hitbox_Movement()
			Hitbox_Damage()
			#-------------------------------------------------------------------------------
			for _i in range(enemyBullets_Enabled_Array.size()-1,-1,-1):
				enemyBullets_Enabled_Array[_i].physics_Update.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region IN_WORLD FUNCTIONS
func Player_Movement():
	if(!can_move):
		return
	#-------------------------------------------------------------------------------
	var _input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	#-------------------------------------------------------------------------------
	if(friend_party[0].is_Moving):
		_input_dir.normalized()
		#-------------------------------------------------------------------------------
		if(is_Running):
			var _new_velocity: Vector2 = _input_dir * 200.0 * deltaTimeScale
			player_characterbody2d.velocity = _new_velocity
			#-------------------------------------------------------------------------------
			if(!_run_flag):
				PlayAnimation(friend_party[0].playback, "Walk")
				is_Running = false
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			var _new_velocity: Vector2 = _input_dir * 70.0 * deltaTimeScale
			player_characterbody2d.velocity = _new_velocity
			#-------------------------------------------------------------------------------
			if(_run_flag):
				PlayAnimation(friend_party[0].playback, "Run")
				is_Running = true
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(_input_dir == Vector2.ZERO):
			PlayAnimation(friend_party[0].playback, "Idle")
			friend_party[0].is_Moving = false
			return
		#-------------------------------------------------------------------------------
		if(friend_party[0].is_Facing_Left):
			if(_input_dir.x > 0):
				Face_Left(friend_party[0], false)
				return
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			if(_input_dir.x < 0):
				Face_Left(friend_party[0], true)
				return
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _new_velocity: Vector2 = Vector2.ZERO
		player_characterbody2d.velocity = _new_velocity
		#-------------------------------------------------------------------------------
		if(_input_dir != Vector2.ZERO):
			#-------------------------------------------------------------------------------
			if(_run_flag):
				PlayAnimation(friend_party[0].playback, "Run")
				is_Running = true
			#-------------------------------------------------------------------------------
			else:
				PlayAnimation(friend_party[0].playback, "Walk")
				is_Running = false
			#-------------------------------------------------------------------------------
			friend_party[0].is_Moving = true
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	player_characterbody2d.move_and_slide()
#-------------------------------------------------------------------------------
func Followers_Movement():
	#-------------------------------------------------------------------------------
	for _i in range(1, friend_party.size()):
		var _distance: float = 20
		#-------------------------------------------------------------------------------
		if(friend_party[_i].global_position.distance_to(friend_party[_i-1].global_position) > _distance):
			var _x: float = friend_party[_i].global_position.x - friend_party[_i-1].global_position.x
			var _y: float = friend_party[_i].global_position.y - friend_party[_i-1].global_position.y
			var _dir: float = atan2(_y, _x)
			var _x2: float = _distance * cos(_dir)
			var _y2: float = _distance * sin(_dir)
			var _new_position: Vector2 = friend_party[_i-1].global_position + Vector2(_x2, _y2)
			#-------------------------------------------------------------------------------
			if(friend_party[_i].is_Moving):
				friend_party[_i].global_position = lerp(friend_party[_i].global_position, _new_position, 0.1*deltaTimeScale)
				#-------------------------------------------------------------------------------
				if(friend_party[_i].global_position.distance_to(_new_position) < 5):
					PlayAnimation(friend_party[_i].playback, "Idle")
					friend_party[_i].is_Moving = false
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				#-------------------------------------------------------------------------------
				if(friend_party[_i].global_position.distance_to(_new_position) > 10):
					PlayAnimation(friend_party[_i].playback, "Run")
					friend_party[_i].is_Moving = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(friend_party[_i].is_Facing_Left):
			#-------------------------------------------------------------------------------
			if(friend_party[_i].global_position < friend_party[0].global_position):
				Face_Left(friend_party[_i], false)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			#-------------------------------------------------------------------------------
			if(friend_party[_i].global_position > friend_party[0].global_position):
				Face_Left(friend_party[_i], true)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Hitbox_Movement():
	var _input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	#-------------------------------------------------------------------------------
	if(_input_dir != Vector2.ZERO):
		_input_dir.normalized()
		var myPosition: Vector2 = hitbox.position
		#-------------------------------------------------------------------------------
		if(_run_flag):
			myPosition += _input_dir * 0.7 * deltaTimeScale
		#-------------------------------------------------------------------------------
		else:
			myPosition += _input_dir * 1.8 * deltaTimeScale
		#-------------------------------------------------------------------------------
		myPosition.y = clampf(myPosition.y, box_limit_up, box_limit_down)
		myPosition.x = clampf(myPosition.x, box_limit_left, box_limit_right)
		hitbox.position = myPosition
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Camera_Follow():
	var _new_position: Vector2 = Camera_Set_Target_Position()
	camera.position = lerp(camera.position, _new_position, 0.2)
#-------------------------------------------------------------------------------
func Camera_Set_Target_Position() -> Vector2:
	var _new_position: Vector2 = friend_party[0].global_position + Vector2(0, -camera_offset_y)
	#-------------------------------------------------------------------------------
	_new_position.x = clampf(_new_position.x, room_test.limit_left, room_test.limit_right)
	_new_position.y = clampf(_new_position.y, room_test.limit_top, room_test.limit_botton)
	#-------------------------------------------------------------------------------
	return _new_position
#-------------------------------------------------------------------------------
func Face_Left(_user:Party_Member, _b:bool):
	#-------------------------------------------------------------------------------
	if(_b):
		_user.pivot.scale.x = -1
	#-------------------------------------------------------------------------------
	else:
		_user.pivot.scale.x = 1
	#-------------------------------------------------------------------------------
	_user.is_Facing_Left = _b
#-------------------------------------------------------------------------------
func PickUp_Item(_item_script:Item_Script):
	Dialogue_Open()
	await PickUp_Item_2(_item_script)
	#await Dialogue(false, "* Bla bla bla bla bla bla bla.")
	Dialogue_Close()
	return
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PickUp_Item_2(_item_script:Item_Script):
	_item_script.queue_free()
	key_dictionary.set(room_test.Get_Item_Script_ID(_item_script), 1)
	#-------------------------------------------------------------------------------
	var _s:String = "* "+get_resource_filename(_item_script.pickable_item.item_resource)+" [x"+str(_item_script.pickable_item.hold)+"]"+" was picked."
	#-------------------------------------------------------------------------------
	for _i in item_array.size():
		#-------------------------------------------------------------------------------
		if(item_array[_i].item_resource == _item_script.pickable_item.item_resource):
			item_array[_i].hold += _item_script.pickable_item.hold
			await Dialogue(false, _s)
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _new_item: Item_Serializable = _item_script.pickable_item.Constructor()
	_new_item.item_resource = _item_script.pickable_item.item_resource
	_new_item.hold = _item_script.pickable_item.hold
	item_array.append(_new_item)
	await Dialogue(false, _s)
	return
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Dialogue_Open():
	is_in_dialogue = false
	can_move = false
	PlayAnimation(friend_party[0].playback, "Idle")
	friend_party[0].is_Moving = false
#-------------------------------------------------------------------------------
func Dialogue(_b:bool, _s:String):
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	if(_b):
		dialogue_menu_speaker1.show()
		dialogue_menu_speaker1_name.show()
	#-------------------------------------------------------------------------------
	else:
		dialogue_menu_speaker1.hide()
		dialogue_menu_speaker1_name.hide()
	#-------------------------------------------------------------------------------
	dialogue_menu_speaking_label.text = _s
	singleton.Common_Submited()
	await dialogue_signal
#-------------------------------------------------------------------------------
func Dialogue_Close():
	singleton.Common_Canceled()
	is_in_dialogue = true
	can_move = true
	dialogue_menu.hide()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SET BATTLEFIELD
#-------------------------------------------------------------------------------
func EnterBattle(_enemy_array:Array[Party_Member]):
	myGAME_STATE = GAME_STATE.IN_MENU
	myBATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
	#-------------------------------------------------------------------------------
	enemy_party.clear()
	#-------------------------------------------------------------------------------
	for _i in _enemy_array.size():
		enemy_party.append(_enemy_array[_i])
		var _party_member_ui: Party_Member_UI = enemy_ui_prefab.instantiate() as Party_Member_UI
		_enemy_array[_i].party_member_ui = _party_member_ui
		_enemy_array[_i].party_member_ui.hide()
		_enemy_array[_i].party_member_ui.button_pivot.hide()
		_enemy_array[_i].party_member_ui.label_sp.hide()
		_enemy_array[_i].party_member_ui.bar_sp.hide()
		battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
	var _center: Vector2 = camera.position
	#-------------------------------------------------------------------------------
	#var _top_limit: float = 0.45
	var _top_limit: float = 0.41
	#var _botton_limit: float = 1.15
	var _botton_limit: float = 0.79
	#-------------------------------------------------------------------------------
	player_last_position.clear()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		player_last_position.append(friend_party[_i].global_position)
		PlayAnimation(friend_party[_i].playback, "Idle")
		friend_party[_i].z_index = 1
		Face_Left(friend_party[_i], false)
		#friend_party[_i].global_position = friend_party[0].global_position
		friend_party[_i].party_member_ui.button.text = "  " + friend_party[_i].id + "  "
	#-------------------------------------------------------------------------------
	enemy_last_position.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		#-------------------------------------------------------------------------------
		if(!enemy_party[_i].visible):
			var _y_pos: float = -camera_size.y*_top_limit + camera_size.y*_botton_limit* (float(_i+1)/(friend_party.size()+1))
			var _x_pos: float = camera_size.x*0.6
			var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
			enemy_party[_i].global_position = _position
			enemy_party[_i].show()
		#-------------------------------------------------------------------------------
		enemy_last_position.append(enemy_party[_i].global_position)
		PlayAnimation(enemy_party[_i].playback, "Idle")
		enemy_party[_i].z_index = 1
		Face_Left(enemy_party[_i], true)
		#enemy_party[_i].global_position = enemy_party[0].global_position
		enemy_party[_i].party_member_ui.button.text = "  " + enemy_party[_i].id + "  "
	#-------------------------------------------------------------------------------
	current_player_turn = 0
	singleton.bgmPlayer.stop()
	#-------------------------------------------------------------------------------
	battle_black_panel.global_position = _center-battle_black_panel.size/2.0
	battle_black_panel.show()
	#-------------------------------------------------------------------------------
	item_array_in_battle.clear()
	for _i in item_array.size():
		item_array_in_battle.append(item_array[_i].Constructor())
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_interval(0.3)
	Move_Fighters_to_Position(_tween, true, 0.5)
	_tween.tween_interval(0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		battle_menu.global_position = friend_party[current_player_turn].party_member_ui.button_pivot.global_position
		#-------------------------------------------------------------------------------
		dialogue_menu_speaker1.hide()
		dialogue_menu_speaker1_name.hide()
		dialogue_menu_speaking_label.text = "* The Battle began!"
		dialogue_menu.show()
		battle_menu.show()
		tp_bar_root.show()
		#-------------------------------------------------------------------------------
		tp = 13
		max_tp = 100
		Set_TP_Label(tp)
		#-------------------------------------------------------------------------------
		battle_box.position = camera.position - battle_box.size/2.0
		singleton.Set_Button(battle_menu_button[0],func():singleton.Common_Selected() , func():BattleMenu_AttackButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[1],func():singleton.Common_Selected() , func():BattleMenu_DefenseButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[2],func():singleton.Common_Selected() , func():BattleMenu_SkillButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[3],func():singleton.Common_Selected() , func():BattleMenu_ItemButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[4],func():singleton.Common_Selected() , func():BattleMenu_EquipButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[5],func():singleton.Common_Selected() , func():BattleMenu_StatusButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Move_to_First_Button(battle_menu_button)
		singleton.Play_BGM(singleton.battle1)
		#-------------------------------------------------------------------------------
		friend_party_alive.clear()
		friend_party_dead.clear()
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			#-------------------------------------------------------------------------------
			friend_party[_i].skill_array_in_battle.clear()
			#-------------------------------------------------------------------------------
			for _j in friend_party[_i].skill_array.size():
				friend_party[_i].skill_array_in_battle.append(friend_party[_i].skill_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			friend_party[_i].equip_array_in_battle.clear()
			#-------------------------------------------------------------------------------
			for _j in friend_party[_i].equip_array.size():
				friend_party[_i].equip_array_in_battle.append(friend_party[_i].equip_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			friend_party[_i].statuseffect_array_in_battle.clear()
			#-------------------------------------------------------------------------------
			for _j in friend_party[_i].statuseffect_array.size():
				friend_party[_i].statuseffect_array_in_battle.append(friend_party[_i].statuseffect_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			friend_party[_i].hp = friend_party[_i].max_hp
			Set_HP_Label(friend_party[_i])
			friend_party[_i].sp = 0
			Set_SP_Label(friend_party[_i])
			friend_party[_i].party_member_ui.show()
			friend_party[_i].party_member_ui.button_pivot.hide()
			friend_party_alive.append(friend_party[_i])
		#-------------------------------------------------------------------------------
		enemy_party_alive.clear()
		enemy_party_dead.clear()
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			enemy_party[_i].hp = enemy_party[_i].max_hp
			Set_HP_Label(enemy_party[_i])
			enemy_party[_i].sp = 0
			Set_SP_Label(enemy_party[_i])
			enemy_party[_i].party_member_ui.show()
			enemy_party[_i].party_member_ui.button_pivot.hide()
			enemy_party_alive.append(enemy_party[_i])
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Move_Fighters_to_Position_2(_position_type:bool):
	var _tween: Tween = create_tween()
	Move_Fighters_to_Position(_tween, _position_type, 0.3)
	_tween.tween_interval(0.2)
	await _tween.finished
#-------------------------------------------------------------------------------
func Move_Fighters_to_Position(_tween:Tween, _position_type:bool, _timer:float):
	var _center: Vector2 = camera.position
	var _top_limit: float
	var _botton_limit: float
	#-------------------------------------------------------------------------------
	if(_position_type):
		_top_limit = 0.41
		_botton_limit = 0.79
	#-------------------------------------------------------------------------------
	else:
		_top_limit = 0.45
		_botton_limit = 1.15
	#-------------------------------------------------------------------------------
	_tween.tween_interval(_timer)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		var _y_pos: float = -camera_size.y*_top_limit + camera_size.y*_botton_limit* (float(_i+1)/(friend_party.size()+1))
		var _x_pos: float = -camera_size.x*0.27
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		_tween.parallel().tween_property(friend_party[_i], "global_position", _position, _timer)
		var _ui_position: Vector2 = (camera_center + Vector2(_x_pos, _y_pos))*camera.zoom
		_tween.parallel().tween_property(friend_party[_i].party_member_ui, "global_position", _ui_position, _timer)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _y_pos: float = -camera_size.y*_top_limit + camera_size.y*_botton_limit* (float(_i+1)/(enemy_party.size()+1))
		var _x_pos: float = camera_size.x*0.27
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		_tween.parallel().tween_property(enemy_party[_i], "global_position", _position, _timer)
		var _ui_position: Vector2 = (camera_center + Vector2(_x_pos, _y_pos))*camera.zoom
		_tween.parallel().tween_property(enemy_party[_i].party_member_ui, "global_position", _ui_position, _timer)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func ExitBatle(_retry_callable:Callable, _win_callable:Callable):
	match(myBATTLE_STATE):
		BATTLE_STATE.YOU_WIN:
			You_Win(_win_callable)
		#-------------------------------------------------------------------------------
		BATTLE_STATE.YOU_LOSE:
			You_Lose(_retry_callable)
		#-------------------------------------------------------------------------------
		BATTLE_STATE.YOU_ESCAPE:
			You_Escape()
		#-------------------------------------------------------------------------------
		BATTLE_STATE.YOU_RETRY:
			You_Retry(_retry_callable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region BATTLE_MENU FUNCTIONS
#-------------------------------------------------------------------------------
func BattleMenu_AttackButton_Submit():
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		Set_TP_Label_from_the_future()
		#-------------------------------------------------------------------------------
		TargetMenu_TargetButton_Cancel()
		battle_menu.show()
		dialogue_menu.show()
		singleton.Move_to_First_Button(battle_menu_button)
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(iten_resource_attack, battle_menu, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_DefenseButton_Submit():
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		Set_TP_Label_from_the_future()
		#-------------------------------------------------------------------------------
		TargetMenu_TargetButton_Cancel()
		battle_menu.show()
		dialogue_menu.show()
		singleton.Move_to_Button(battle_menu_button[1])
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(iten_resource_defense, battle_menu, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_SkillButton_Submit():
	battle_menu.hide()
	dialogue_menu.hide()
	status_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	var _user: Party_Member = friend_party_alive[current_player_turn]
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(status_menu.get_tab_bar(),func():StatusMenu_No_Description(_user), func():SkillMenu_SkillButton_Cancel())
	#-------------------------------------------------------------------------------
	for _i in _user.skill_array_in_battle.size():
		#-------------------------------------------------------------------------------
		var _item_serializable: Item_Serializable = _user.skill_array_in_battle[_i]
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(_item_serializable.item_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		skill_menu_content.add_child(_button)
		skill_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: RichTextLabel = RichTextLabel.new()
		_label2.bbcode_enabled = true
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = ""
		#-------------------------------------------------------------------------------
		if(_item_serializable.cooldown <= 0 or _item_serializable.item_resource.max_cooldown <= 0):
			#-------------------------------------------------------------------------------
			if(_item_serializable.item_resource.hp_cost > 0):
				_label2.text += "("+str(_item_serializable.item_resource.hp_cost)+" HP)  "
			#-------------------------------------------------------------------------------
			if(_item_serializable.item_resource.sp_cost > 0):
				_label2.text += "("+str(_item_serializable.item_resource.sp_cost)+" SP)  "
			#-------------------------------------------------------------------------------
			if(_item_serializable.item_resource.tp_cost > 0):
				_label2.text += "("+str(_item_serializable.item_resource.tp_cost)+" TP)  "
			#-------------------------------------------------------------------------------
			if(_item_serializable.item_resource.max_hold > 0 ):
				_label2.text += "["+str(_item_serializable.hold)+"/"+str(_item_serializable.item_resource.max_hold)+"]  "
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			_label2.text += "("+str(_item_serializable.cooldown)+" CD)  "
		#-------------------------------------------------------------------------------
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			status_menu.show()
			dialogue_menu.hide()
			singleton.Move_to_Button(skill_menu_button_array[_i])
			#-------------------------------------------------------------------------------
			Set_TP_Label_from_the_future()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():SkillMenu_SkillButton_Selected(_item_serializable), func(): SkillMenu_SkillButton_Submit(_item_serializable, _cancel), func():SkillMenu_SkillButton_Cancel())
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = status_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	if(skill_menu_button_array.size() > 0):
		singleton.Move_to_Button(skill_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, true)
	_tabbar.set_tab_disabled(1, true)
	_tabbar.set_tab_disabled(2, true)
	_tabbar.set_tab_disabled(3, false)
	_tabbar.set_tab_disabled(4, true)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 3
	skill_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func BattleMenu_ItemButton_Submit():
	battle_menu.hide()
	dialogue_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(item_menu.get_tab_bar(),func():ItemMenu_No_Description(), func():ItemMenu_ItemButton_Cancel())
	#-------------------------------------------------------------------------------
	for _i in item_array_in_battle.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(item_array_in_battle[_i].item_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_consumable_content.add_child(_button)
		item_menu_consumable_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: RichTextLabel = RichTextLabel.new()
		_label2.bbcode_enabled = true
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = ""
		#-------------------------------------------------------------------------------
		var _hold: int = item_array_in_battle[_i].hold
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(item_array_in_battle[_i].item_resource == (friend_party[_j].item_serializable.item_resource)):
				_hold -= 1
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		var _cooldown: int = item_array_in_battle[_i].cooldown
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(item_array_in_battle[_i].item_resource == (friend_party[_j].item_serializable.item_resource)):
				_cooldown += item_array_in_battle[_i].item_resource.max_cooldown
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(_cooldown <= 0 or item_array_in_battle[_i].item_resource.max_cooldown <= 0):
			#-------------------------------------------------------------------------------
			if(item_array[_i].item_resource.hp_cost > 0):
				_label2.text += "("+str(item_array[_i].item_resource.hp_cost)+" HP)  "
			#-------------------------------------------------------------------------------
			if(item_array[_i].item_resource.sp_cost > 0):
				_label2.text += "("+str(item_array[_i].item_resource.sp_cost)+" SP)  "
			#-------------------------------------------------------------------------------
			if(item_array[_i].item_resource.tp_cost > 0):
				_label2.text += "("+str(item_array[_i].item_resource.tp_cost)+" TP)  "
			#-------------------------------------------------------------------------------
			if(item_array[_i].item_resource.max_hold > 0):
				var _s: String = "["+str(_hold)+" / "+str(item_array[_i].item_resource.max_hold)+"]  "
				#-------------------------------------------------------------------------------
				if(_hold < item_array_in_battle[_i].hold):
					_label2.text += "[color=yellow]"+_s+"[/color]"
				#-------------------------------------------------------------------------------
				else:
					_label2.text += _s
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			var _s: String = "("+str(_cooldown)+" CD)  "
			#-------------------------------------------------------------------------------
			if(_cooldown > item_array_in_battle[_i].cooldown):
				_label2.text = "[color=yellow]"+_s+"[/color]"
			#-------------------------------------------------------------------------------
			else:
				_label2.text = _s
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			dialogue_menu.hide()
			singleton.Move_to_Button(item_menu_consumable_button_array[_i])
			#-------------------------------------------------------------------------------
			Set_TP_Label_from_the_future()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():ItemMenu_Consumable_ItemButton_Selected(item_array_in_battle[_i]), func():ItemMenu_ItemButton_Submit(item_array_in_battle[_i], _hold, _cooldown, _cancel), func():ItemMenu_ItemButton_Cancel())
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(equip_array[_i].equip_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_equipment_content.add_child(_button)
		item_menu_equipment_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(equip_array[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():ItemMenu_Equipment_ItemButton_Selected(equip_array[_i]), func():pass, func():ItemMenu_ItemButton_Cancel())
	#-------------------------------------------------------------------------------
	for _i in key_item_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(key_item_array[_i].key_item_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_keyitems_content.add_child(_button)
		item_menu_keyitems_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(key_item_array[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():ItemMenu_KeyItem_ItemButton_Selected(key_item_array[_i]), func():pass, func():ItemMenu_ItemButton_Cancel())
	#-------------------------------------------------------------------------------
	var _tabbar:TabBar = item_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	if(item_menu_consumable_button_array.size() > 0):
		singleton.Move_to_Button(item_menu_consumable_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, false)
	_tabbar.set_tab_disabled(1, false)
	_tabbar.set_tab_disabled(2, false)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 0
	item_menu_consumable_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_Submit():
	status_menu.show()
	battle_menu.hide()
	dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	var _user: Party_Member = friend_party_alive[current_player_turn]
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(status_menu.get_tab_bar(), func():StatusMenu_No_Description(_user), func():BattleMenu_EquipButton_EquipSlot_Cancel())
	#-------------------------------------------------------------------------------
	for _i in _user.equip_array.size():
		var _button:Button = Button.new()
		_button.theme = ui_theme
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		#-------------------------------------------------------------------------------
		var _equip_serializable: Equip_Serializable = _user.equip_array[_i]
		#-------------------------------------------------------------------------------
		if(_equip_serializable.equip_resource == null):
			_button.text = "  [Empty]  "
		#-------------------------------------------------------------------------------
		else:
			_button.text = get_resource_filename(_equip_serializable.equip_resource)
		#-------------------------------------------------------------------------------
		equipslot_menu_button_array.append(_button)
		equipslot_menu_content.add_child(_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(equipslot_menu_button_array[_i], func():EquipSlotMenu_EquipButton_Selected(_user, _user.equip_array_in_battle, _i), func():BattleMenu_EquipButton_EquipSlot_Submit(_user, _i), func():BattleMenu_EquipButton_EquipSlot_Cancel())
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = status_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	if(equipslot_menu_button_array.size() > 0):
		singleton.Move_to_Button(equipslot_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, true)
	_tabbar.set_tab_disabled(1, true)
	_tabbar.set_tab_disabled(2, false)
	_tabbar.set_tab_disabled(3, true)
	_tabbar.set_tab_disabled(4, true)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 2
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_Submit(_user:Party_Member,_index:int):
	status_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(item_menu.get_tab_bar(), func():EquipMenu_No_Description(), func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	var _empty_button: Button = Button.new()
	_empty_button.theme = ui_theme
	_empty_button.text = "  [Empty]  "
	_empty_button.add_theme_font_size_override("font_size", 24)
	_empty_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	item_menu_equipment_content.add_child(_empty_button)
	item_menu_equipment_button_array.append(_empty_button)
	singleton.Set_Button(_empty_button, func():EquipMenu_No_Description(), func():pass, func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(equip_array[_i].equip_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_equipment_content.add_child(_button)
		item_menu_equipment_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(equip_array[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			dialogue_menu.hide()
			singleton.Move_to_Button(item_menu_equipment_button_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():EquipMenu_EquipButton_Selected(equip_array[_i]), func():pass, func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = item_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, true)
	_tabbar.set_tab_disabled(1, false)
	_tabbar.set_tab_disabled(2, true)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 1
	item_menu_equipment_scrollContainer.scroll_vertical = 0
	singleton.Move_to_Button(item_menu_equipment_button_array[0])
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_Cancel():
	Battle_Menu_StatusMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	battle_menu.show()
	singleton.Move_to_Button(battle_menu_button[4])
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index:int):
	BattleMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	status_menu.show()
	singleton.Move_to_Button(equipslot_menu_button_array[_index])
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_Submit():
	battle_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		singleton.Set_Button(friend_party[_i].party_member_ui.button, func():singleton.Common_Selected(), func():BattleMenu_StatusButton_TargetButton_Submit(friend_party[_i], false), func():BattleMenu_StatusButton_TargetButton_Cancel())
		friend_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		singleton.Set_Button(enemy_party[_i].party_member_ui.button, func():singleton.Common_Selected(), func():BattleMenu_StatusButton_TargetButton_Submit(enemy_party[_i], true), func():BattleMenu_StatusButton_TargetButton_Cancel())
		enemy_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(friend_party[0].party_member_ui.button)
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_Submit(_user:Party_Member, _is_enemy:bool):
	status_menu.show()
	Show_Status_Data(_user)
	dialogue_menu.hide()
	status_menu.current_tab = 0
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(status_menu.get_tab_bar(), func():StatusMenu_No_Description(_user), func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user))
	#-------------------------------------------------------------------------------
	for _i in status_menu_stats_button_array.size():
		singleton.Set_Button(status_menu_stats_button_array[_i], func():StatusMenu_StatsButton_Selected(_i), func():pass, func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user))
	#-------------------------------------------------------------------------------
	for _i in _user.statuseffect_array_in_battle.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(_user.statuseffect_array_in_battle[_i].statuseffect_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		status_menu_statuseffect_content.add_child(_button)
		status_menu_statuseffect_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(_user.statuseffect_array_in_battle[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			dialogue_menu.hide()
			singleton.Move_to_Button(status_menu_statuseffect_button_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():StatusMenu_StatusEffectButton_Selected(_user.statuseffect_array_in_battle[_i]), func():pass, func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user))
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = status_menu.get_tab_bar()
	singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, false)
	_tabbar.set_tab_disabled(1, false)
	#-------------------------------------------------------------------------------
	if(!_is_enemy and !can_equip_midbattle):
		#-------------------------------------------------------------------------------
		for _i in _user.equip_array_in_battle.size():
			var _button:Button = Button.new()
			_button.theme = ui_theme
			_button.add_theme_font_size_override("font_size", 24)
			_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
			#-------------------------------------------------------------------------------
			var _equip_serializable: Equip_Serializable = _user.equip_array_in_battle[_i]
			#-------------------------------------------------------------------------------
			if(_equip_serializable.equip_resource == null):
				_button.text = "  [Empty]  "
			#-------------------------------------------------------------------------------
			else:
				_button.text = get_resource_filename(_equip_serializable.equip_resource)
			#-------------------------------------------------------------------------------
			equipslot_menu_button_array.append(_button)
			equipslot_menu_content.add_child(_button)
			#-------------------------------------------------------------------------------
			singleton.Set_Button(equipslot_menu_button_array[_i], func():EquipSlotMenu_EquipButton_Selected(_user, _user.equip_array_in_battle, _i), func():pass, func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user))
		#-------------------------------------------------------------------------------
		_tabbar.set_tab_disabled(2, false)
	#-------------------------------------------------------------------------------
	else:
		_tabbar.set_tab_disabled(2, true)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(3, true)
	_tabbar.set_tab_disabled(4, false)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 0
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user:Party_Member):
	Battle_Menu_StatusMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(_user.party_member_ui.button)
#-------------------------------------------------------------------------------
func Battle_Menu_StatusMenu_Exit_Common():
	status_menu.hide()
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(skill_menu_button_array)
	Destroy_All_Items(equipslot_menu_button_array)
	Destroy_All_Items(status_menu_statuseffect_button_array)
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_Cancel():
	battle_menu.show()
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(battle_menu_button[5])
#-------------------------------------------------------------------------------
func BattleMenu_AnyButton_Cancel():
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	current_player_turn -= 1
	Set_TP_Label_from_the_future()
	#-------------------------------------------------------------------------------
	if(current_player_turn < 0):
		current_player_turn = 0
		battle_menu.hide()
		dialogue_menu.hide()
		win_label.text = "Escape?"
		win_label.show()
		retry_menu.show()
		singleton.Move_to_Button(retry_menu_button[0])
		singleton.Set_Button(retry_menu_button[0], func():singleton.Common_Selected(), func():RetryMenu_RetryButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		singleton.Set_Button(retry_menu_button[1], func():singleton.Common_Selected(), func():RetryMenu_EscapeButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		singleton.Set_Button(retry_menu_button[2], func():singleton.Common_Selected(), func():RetryMenu_GiveUpButton_Submit(), func():RetryMenu_AnyButton_Cancel())
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		for _i in range(current_player_turn, friend_party_alive.size()):
			PlayAnimation(friend_party_alive[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		for _i in enemy_party_alive.size():
			PlayAnimation(enemy_party_alive[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		battle_menu.global_position = friend_party_alive[current_player_turn].party_member_ui.button_pivot.global_position
		singleton.Move_to_First_Button(battle_menu_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SKILL MENU FUNCTIONS
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Selected(_item_serializable:Item_Serializable):
	skill_menu_lore.text = _item_serializable.item_resource.lore
	skill_menu_description.text = _item_serializable.item_resource.description
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Submit(_item_serializable:Item_Serializable, _cancel:Callable):
	#-------------------------------------------------------------------------------
	if(_item_serializable.hold > 0 or _item_serializable.item_resource.max_hold <= 0):
		#-------------------------------------------------------------------------------
		if(_item_serializable.cooldown <= 0 or _item_serializable.item_resource.max_cooldown <= 0):
			TargetMenu_Enter(_item_serializable, status_menu, _cancel)
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Cancel():
	Battle_Menu_StatusMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	battle_menu.show()
	singleton.Move_to_Button(battle_menu_button[2])
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ITEM MENU FUNCTIONS
#-------------------------------------------------------------------------------
func ItemMenu_Consumable_ItemButton_Selected(_item_serializable:Item_Serializable):
	item_menu_consumable_lore.text = _item_serializable.item_resource.lore
	item_menu_consumable_description.text = _item_serializable.item_resource.description
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func ItemMenu_Equipment_ItemButton_Selected(_equip_serializable:Equip_Serializable):
	item_menu_equipment_lore.text = _equip_serializable.equip_resource.lore
	item_menu_equipment_description.text = _equip_serializable.equip_resource.description
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func ItemMenu_KeyItem_ItemButton_Selected(keyitem_serializable:Key_Item_Serializable):
	item_menu_keyitems_lore.text = keyitem_serializable.key_item_resource.lore
	item_menu_keyitems_description.text = keyitem_serializable.key_item_resource.description
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func EquipSlotMenu_EquipButton_Selected(_user:Party_Member, _equip_serializable_array:Array[Equip_Serializable], _index: int):
	#-------------------------------------------------------------------------------
	if(_equip_serializable_array[_index].equip_resource == null):
		StatusMenu_No_Description(_user)
	#-------------------------------------------------------------------------------
	else:
		equipslot_menu_lore.text = _equip_serializable_array[_index].equip_resource.lore
		equipslot_menu_description.text = _equip_serializable_array[_index].equip_resource.description
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func EquipMenu_EquipButton_Selected(_equip_serializable:Equip_Serializable):
	item_menu_equipment_lore.text = _equip_serializable.equip_resource.lore
	item_menu_equipment_description.text = _equip_serializable.equip_resource.description
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func StatusMenu_StatusEffectButton_Selected(_statuseffect_serializable:StatusEffect_Serializable):
	status_menu_statuseffect_lore.text = _statuseffect_serializable.statuseffect_resource.lore
	status_menu_statuseffect_description.text = _statuseffect_serializable.statuseffect_resource.description
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func StatusMenu_StatsButton_Selected(_index:int):
	#-------------------------------------------------------------------------------
	match(_index):
		0:
			status_menu_stats_lore.text = "* Max Hp Lore."
			status_menu_stats_description.text = "* Max Hp Description."
		#-------------------------------------------------------------------------------
		1:
			status_menu_stats_lore.text = "* Max Sp Lore."
			status_menu_stats_description.text = "* Max Sp Description."
		#-------------------------------------------------------------------------------
		2:
			status_menu_stats_lore.text = "* Physical Attack Lore."
			status_menu_stats_description.text = "* Physical Attack Description."
		#-------------------------------------------------------------------------------
		3:
			status_menu_stats_lore.text = "* Physical Defense Lore."
			status_menu_stats_description.text = "* Physical Defense Description."
		#-------------------------------------------------------------------------------
		4:
			status_menu_stats_lore.text = "* Magical Attack Lore."
			status_menu_stats_description.text = "* Magical Attack Description."
		#-------------------------------------------------------------------------------
		5:
			status_menu_stats_lore.text = "* Magical Defense Lore."
			status_menu_stats_description.text = "* Magical Defense Description."
		#-------------------------------------------------------------------------------
		6:
			status_menu_stats_lore.text = "* Agility Lore."
			status_menu_stats_description.text = "* Agility Description."
		#-------------------------------------------------------------------------------
		7:
			status_menu_stats_lore.text = "* Speed Lore."
			status_menu_stats_description.text = "* Speed Description."
		#-------------------------------------------------------------------------------
		8:
			status_menu_stats_lore.text = "* Luck Lore."
			status_menu_stats_description.text = "* Luck Description."
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func ItemMenu_ItemButton_Submit(_item_serializable:Item_Serializable, _hold:int, _cooldown:int, _cancel:Callable):
	#-------------------------------------------------------------------------------
	if(_hold > 0 or _item_serializable.item_resource.max_hold <= 0):
		#-------------------------------------------------------------------------------
		if(_cooldown <= 0 or _item_serializable.item_resource.max_cooldown <= 0):
			TargetMenu_Enter(_item_serializable, item_menu, _cancel)
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func ItemMenu_ItemButton_Cancel():
	BattleMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	battle_menu.show()
	dialogue_menu.show()
	singleton.Move_to_Button(battle_menu_button[3])
#-------------------------------------------------------------------------------
func BattleMenu_ItemMenu_Exit_Common():
	item_menu.hide()
	#----------------------------------------------------------------
	Destroy_All_Items(item_menu_consumable_button_array)
	Destroy_All_Items(item_menu_equipment_button_array)
	Destroy_All_Items(item_menu_keyitems_button_array)
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func Destroy_All_Items(_button_array:Array[Button]):
	for _i in _button_array.size():
		_button_array[_i].queue_free()
	#-------------------------------------------------------------------------------
	_button_array.clear()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TARGET MENU FUNCTIONS
#-------------------------------------------------------------------------------
func TargetMenu_Enter(_item_serializable:Item_Serializable, _last_menu:Control, _cancel:Callable):	
	var _tp: int = tp
	#-------------------------------------------------------------------------------
	for _i in current_player_turn:
		_tp -= friend_party[_i].item_serializable.item_resource.tp_cost
	#-------------------------------------------------------------------------------
	if(friend_party[current_player_turn].hp >= _item_serializable.item_resource.hp_cost and friend_party[current_player_turn].sp >= _item_serializable.item_resource.sp_cost and _tp >= _item_serializable.item_resource.tp_cost):
		match(_item_serializable.item_resource.myTARGET_TYPE):
			Item_Resource.TARGET_TYPE.ENEMY_1:
				#-------------------------------------------------------------------------------
				if(enemy_party_alive.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					singleton.Common_Submited()
					#-------------------------------------------------------------------------------
					for _i in enemy_party_alive.size():
						enemy_party_alive[_i].party_member_ui.button_pivot.show()
						singleton.Set_Button(enemy_party_alive[_i].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_alive, enemy_party_alive[_i], enemy_party_alive, _item_serializable), _cancel)
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(enemy_party_alive[0].party_member_ui.button)
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.ALLY_1:
				#-------------------------------------------------------------------------------
				if(friend_party_alive.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					singleton.Common_Submited()
					#-------------------------------------------------------------------------------
					for _i in friend_party_alive.size():
						friend_party_alive[_i].party_member_ui.button_pivot.show()
						singleton.Set_Button(friend_party_alive[_i].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_alive, friend_party_alive[_i], friend_party_alive, _item_serializable), _cancel)
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(friend_party_alive[0].party_member_ui.button)
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.ALLY_DEATH:
				#-------------------------------------------------------------------------------
				if(friend_party_dead.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					singleton.Common_Submited()
					#-------------------------------------------------------------------------------
					for _i in friend_party_dead.size():
						friend_party_dead[_i].party_member_ui.button_pivot.show()
						singleton.Set_Button(friend_party_dead[_i].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_dead, friend_party_dead[_i], friend_party_dead, _item_serializable), _cancel)
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(friend_party_dead[0].party_member_ui.button)
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.USER:
				_last_menu.hide()
				dialogue_menu.show()
				#-------------------------------------------------------------------------------
				_tp -= _item_serializable.item_resource.tp_cost
				Set_TP_Label(_tp)
				singleton.Common_Submited()
				#-------------------------------------------------------------------------------
				friend_party_alive[current_player_turn].party_member_ui.button_pivot.show()
				singleton.Set_Button(friend_party_alive[current_player_turn].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_alive, friend_party_alive[current_player_turn], friend_party_alive, _item_serializable), _cancel)
				#-------------------------------------------------------------------------------
				singleton.Move_to_Button(friend_party_alive[current_player_turn].party_member_ui.button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------	
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Submit(_user_party:Array[Party_Member], _target:Party_Member, _target_party:Array[Party_Member], _item_serializable:Item_Serializable):
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	friend_party_alive[current_player_turn].user_party = _user_party
	friend_party_alive[current_player_turn].target = _target
	friend_party_alive[current_player_turn].target_party = _target_party
	friend_party_alive[current_player_turn].item_serializable = _item_serializable
	#-------------------------------------------------------------------------------
	PlayAnimation(friend_party_alive[current_player_turn].playback, _item_serializable.item_resource.anim)
	#-------------------------------------------------------------------------------
	Destroy_All_Items(item_menu_consumable_button_array)
	Destroy_All_Items(item_menu_equipment_button_array)
	Destroy_All_Items(item_menu_keyitems_button_array)
	#-------------------------------------------------------------------------------
	Destroy_All_Items(skill_menu_button_array)
	Destroy_All_Items(equipslot_menu_button_array)
	Destroy_All_Items(status_menu_statuseffect_button_array)
	#-------------------------------------------------------------------------------
	After_Choose_Target_Logic()
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Cancel():
	friend_party_alive[current_player_turn].user_party = []
	friend_party_alive[current_player_turn].target = null
	friend_party_alive[current_player_turn].target_party = []
	friend_party_alive[current_player_turn].item_serializable = null
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	Hide_AllTarget()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region AFTER MENU ACTIONS
#-------------------------------------------------------------------------------
func After_Choose_Target_Logic():
	Hide_AllTarget()
	current_player_turn += 1
	#-------------------------------------------------------------------------------
	if(current_player_turn < friend_party_alive.size()):
		#-------------------------------------------------------------------------------
		battle_menu.global_position = friend_party_alive[current_player_turn].party_member_ui.button_pivot.global_position
		battle_menu.show()
		dialogue_menu.show()
		singleton.Move_to_First_Button(battle_menu_button)
	#-------------------------------------------------------------------------------
	else:
		await Party_Actions()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Hide_AllTarget():
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Seconds(_timer:float):
	await get_tree().create_timer(_timer, true, true).timeout
#-------------------------------------------------------------------------------
func Party_Actions():
	current_player_turn = friend_party_alive.size()
	Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
	await Seconds(0.5)
	#-------------------------------------------------------------------------------
	var _player_alive_attacking: Array[Party_Member] = []
	var _player_alive_defending: Array[Party_Member] = []
	var _player_alive_using_skill_or_item: Array[Party_Member] = []
	#-------------------------------------------------------------------------------
	for _i in friend_party_alive.size():
		#-------------------------------------------------------------------------------
		match(friend_party_alive[_i].item_serializable.item_resource):
			iten_resource_attack.item_resource:
				_player_alive_attacking.append(friend_party_alive[_i])
			#-------------------------------------------------------------------------------
			iten_resource_defense.item_resource:
				_player_alive_defending.append(friend_party_alive[_i])
			#-------------------------------------------------------------------------------
			_:
				_player_alive_using_skill_or_item.append(friend_party_alive[_i])
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await Do_Defence_Minigame(_player_alive_defending)
	#-------------------------------------------------------------------------------
	for _i in _player_alive_using_skill_or_item.size():
		#-------------------------------------------------------------------------------
		Set_Players_and_Enemies_before_action()
		#-------------------------------------------------------------------------------
		var _user: Party_Member = _player_alive_using_skill_or_item[_i]
		Set_Target_Avalible(_user)
		#-------------------------------------------------------------------------------
		if(_user.target != null):
			dialogue_menu.show()
			dialogue_menu_speaking_label.text = "* "+_user.id + " uses " + get_resource_filename(_user.item_serializable.item_resource) + " on " + _user.target.id
			await Seconds(0.5)
			await Do_Player_Action(_user)
			await Seconds(0.2)
			await Seconds(0.5)
			dialogue_menu.hide()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await Do_Attack_Minigame(_player_alive_attacking)
	#-------------------------------------------------------------------------------
	await Seconds(0.5)
	#-------------------------------------------------------------------------------
	for _i in range(item_array_in_battle.size()-1, -1, -1):
		#-------------------------------------------------------------------------------
		if(item_array_in_battle[_i].hold <= 0):
			item_array_in_battle.remove_at(_i)
		#-------------------------------------------------------------------------------
		else:
			item_array_in_battle[_i].cooldown -= 1
			#-------------------------------------------------------------------------------
			if(item_array_in_battle[_i].cooldown < 0):
				item_array_in_battle[_i].cooldown = 0
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	friend_party_alive.clear()
	friend_party_dead.clear()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].skill_array_in_battle.size():
			friend_party[_i].skill_array_in_battle[_j].cooldown -= 1
			#-------------------------------------------------------------------------------
			if(friend_party[_i].skill_array_in_battle[_j].cooldown < 0):
				friend_party[_i].skill_array_in_battle[_j].cooldown = 0
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].statuseffect_array_in_battle.size():
			friend_party[_i].statuseffect_array_in_battle[_j].hold -= 1
			#-------------------------------------------------------------------------------
			if(friend_party[_i].statuseffect_array_in_battle[_j].hold <= 0):
				friend_party[_i].statuseffect_array_in_battle.remove_at(_j)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(friend_party[_i].hp > 0):
			friend_party_alive.append(friend_party[_i])
			#-------------------------------------------------------------------------------
			if(friend_party[_i].is_in_guard):
				PlayAnimation(friend_party[_i].playback, "Crouch")
			#-------------------------------------------------------------------------------
			else:
				PlayAnimation(friend_party[_i].playback, "Idle")
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			friend_party_dead.append(friend_party[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	enemy_party_alive.clear()
	enemy_party_dead.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		#-------------------------------------------------------------------------------
		if(enemy_party[_i].hp > 0):
			enemy_party_alive.append(enemy_party[_i])
			PlayAnimation(enemy_party[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		else:
			enemy_party_dead.append(enemy_party[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(enemy_party_alive.size() > 0):
		#-------------------------------------------------------------------------------
		if(friend_party_alive.size() > 0):
			Set_Players_and_Enemies_before_action()
			myBATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
		#-------------------------------------------------------------------------------
		else:
			myBATTLE_STATE = BATTLE_STATE.YOU_LOSE
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		myBATTLE_STATE = BATTLE_STATE.YOU_WIN
	#-------------------------------------------------------------------------------
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func Set_Players_and_Enemies_before_action():
	for _j in enemy_party.size():
		enemy_party[_j].damage_label_array.clear()
	#-------------------------------------------------------------------------------
	for _j in friend_party.size():
		friend_party[_j].damage_label_array.clear()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Target_Avalible(_user:Party_Member):
	#-------------------------------------------------------------------------------
	match(_user.item_serializable.item_resource.myTARGET_TYPE):
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ENEMY_1:
			#-------------------------------------------------------------------------------
			if(_user.target.hp > 0):
				pass
			#-------------------------------------------------------------------------------
			else:
				var _target_array_alive: Array[Party_Member] = []
				#-------------------------------------------------------------------------------
				for _i in _user.target_party.size():
					#-------------------------------------------------------------------------------
					if(_user.target_party[_i].hp > 0):
						_target_array_alive.append(_user.target_party[_i])
					#-------------------------------------------------------------------------------
				#-------------------------------------------------------------------------------
				if(_target_array_alive.size() > 0):
					_user.target = _target_array_alive[0]
					#-------------------------------------------------------------------------------
					for _i in _target_array_alive.size():
						#-------------------------------------------------------------------------------
						if(_target_array_alive[_i].hp < _user.target.hp):
							_user.target = _target_array_alive[_i]
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
				#-------------------------------------------------------------------------------
				else:
					_user.target = null
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ALLY_1:
			pass
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ALLY_DEATH:
			pass
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.USER:
			pass
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Player_Action(_user:Party_Member):
	#-------------------------------------------------------------------------------
	if(_user.target == null):
		return
	#-------------------------------------------------------------------------------
	_user.item_serializable.hold -= 1
	_user.item_serializable.cooldown = _user.item_serializable.item_resource.max_cooldown + 1
	#-------------------------------------------------------------------------------
	_user.hp -= _user.item_serializable.item_resource.hp_cost
	_user.sp -= _user.item_serializable.item_resource.sp_cost
	tp -= _user.item_serializable.item_resource.tp_cost
	#-------------------------------------------------------------------------------
	Set_HP_Label(_user)
	Set_SP_Label(_user)
	Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
	await call(_user.item_serializable.item_resource.action_string, _user)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Defence_Minigame(_player_alive_defending: Array[Party_Member]):
	if(_player_alive_defending.size() > 0):
		Set_Players_and_Enemies_before_action()
		#-------------------------------------------------------------------------------
		for _i in _player_alive_defending.size():
			await Do_Player_Action(_player_alive_defending[_i])
			await Seconds(0.1)
		#-------------------------------------------------------------------------------
		await Seconds(0.5)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Attack_Minigame(_attacking_party: Array[Party_Member]):
	if(_attacking_party.size() > 0):
		Set_Players_and_Enemies_before_action()
		#-------------------------------------------------------------------------------
		enemy_party_alive.clear()
		enemy_party_dead.clear()
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			#-------------------------------------------------------------------------------
			if(enemy_party[_i].hp > 0):
				enemy_party_alive.append(enemy_party[_i])
			#-------------------------------------------------------------------------------
			else:
				enemy_party_dead.append(enemy_party[_i])
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(enemy_party_alive.size() > 0):
			dialogue_menu.show()
			dialogue_menu_speaking_label.text = "* Normal Attack Minigame"
			await Seconds(0.5)
			#-------------------------------------------------------------------------------
			for _i in _attacking_party.size():
				Set_Target_Avalible(_attacking_party[_i])
				#-------------------------------------------------------------------------------
				if(_attacking_party[_i].target != null):
					await Do_Player_Action(_attacking_party[_i])
					await Seconds(0.2)
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			await Seconds(0.5)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Nothing(_user:Party_Member):
	print("The actions Does not exist")
#-------------------------------------------------------------------------------
func Start_BulletHell(_callable: Callable, _timer:int):
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE != BATTLE_STATE.STILL_FIGHTING):
		return
	#-------------------------------------------------------------------------------
	battle_box.show()
	dialogue_menu.hide()
	#dialogue_menu_speaking_label.text = ""
	hitbox.position = battle_box.size/2.0
	myGAME_STATE = GAME_STATE.IN_BATTLE
	#-------------------------------------------------------------------------------
	var _offset: float = 3
	box_limit_up = _offset
	box_limit_down = battle_box.size.y - _offset
	box_limit_left = _offset
	box_limit_right = battle_box.size.x - _offset
	#-------------------------------------------------------------------------------
	screen_limit_up = camera.global_position.y-camera_center.y
	screen_limit_down = camera.global_position.y+camera_center.y
	screen_limit_left = camera.global_position.x-camera_center.x
	screen_limit_right = camera.global_position.x+camera_center.x
	#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in enemy_party_alive.size():
		PlayAnimation(enemy_party_alive[_i].playback, "Aim")
	#-------------------------------------------------------------------------------
	await Move_Fighters_to_Position_2(false)
	_callable.call()
	await TimeOut_Tween(_timer)
	#-------------------------------------------------------------------------------
	myGAME_STATE = GAME_STATE.IN_MENU
	current_player_turn = 0
	#-------------------------------------------------------------------------------
	friend_party_alive.clear()
	friend_party_dead.clear()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		#-------------------------------------------------------------------------------
		friend_party[_i].is_in_guard = false
		#-------------------------------------------------------------------------------
		if(friend_party[_i].hp > 0):
			friend_party_alive.append(friend_party[_i])
			PlayAnimation(friend_party[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		else:
			friend_party_dead.append(friend_party[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	enemy_party_alive.clear()
	enemy_party_dead.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].is_in_guard = false
		#-------------------------------------------------------------------------------
		if(enemy_party[_i].hp > 0):
			enemy_party_alive.append(enemy_party[_i])
			PlayAnimation(enemy_party[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		else:
			enemy_party_dead.append(enemy_party[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(enemy_party_alive.size() > 0):
		#-------------------------------------------------------------------------------
		if(friend_party_alive.size() > 0):
			await Move_Fighters_to_Position_2(true)
			#-------------------------------------------------------------------------------
			battle_menu.show()
			dialogue_menu.show()
			battle_box.hide()
			myGAME_STATE = GAME_STATE.IN_MENU
			singleton.Move_to_First_Button(battle_menu_button)
			battle_menu.global_position = friend_party_alive[current_player_turn].party_member_ui.button_pivot.global_position
		#-------------------------------------------------------------------------------
		else:
			myBATTLE_STATE = BATTLE_STATE.YOU_LOSE
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		myBATTLE_STATE = BATTLE_STATE.YOU_WIN
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func You_Win(_callable:Callable):
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].skill_array.clear()
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].skill_array_in_battle.size():
			friend_party[_i].skill_array.append(friend_party[_i].skill_array_in_battle[_j].Constructor())
		#-------------------------------------------------------------------------------
		friend_party[_i].equip_array.clear()
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].equip_array_in_battle.size():
			friend_party[_i].equip_array.append(friend_party[_i].equip_array_in_battle[_j].Constructor())
		#-------------------------------------------------------------------------------
		friend_party[_i].statuseffect_array.clear()
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].statuseffect_array_in_battle.size():
			friend_party[_i].statuseffect_array.append(friend_party[_i].statuseffect_array_in_battle[_j].Constructor())
		#-------------------------------------------------------------------------------
		friend_party[_i].party_member_ui.hide()
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.hide()
		enemy_party[_i].party_member_ui.button_pivot.hide()
		enemy_party[_i].party_member_ui.queue_free()
	#-------------------------------------------------------------------------------
	item_array.clear()
	for _i in item_array_in_battle.size():
		item_array.append(item_array_in_battle[_i].Constructor())
	#-------------------------------------------------------------------------------
	retry_menu.hide()
	dialogue_menu.hide()
	tp_bar_root.hide()
	win_label.text = "You Win"
	win_label.show()
	#-------------------------------------------------------------------------------
	var _tween3: Tween = create_tween()
	_tween3.tween_interval(1.0)
	_tween3.tween_interval(1.0)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		_tween3.parallel().tween_property(friend_party[_i], "global_position", player_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		_tween3.parallel().tween_property(enemy_party[_i], "global_position", enemy_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	_tween3.tween_callback(func():
		win_label.hide()
		singleton.Play_BGM(singleton.stage1)
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			friend_party[_i].z_index = 0
			PlayAnimation(friend_party[_i].playback, "Idle")
			friend_party[_i].is_Moving = false
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			enemy_party[_i].z_index = 0
		#-------------------------------------------------------------------------------
		battle_black_panel.hide()
		myGAME_STATE = GAME_STATE.IN_WORLD
		_callable.call()
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region RETRY MENU FUNCTIONS
#-------------------------------------------------------------------------------
func RetryMenu_RetryButton_Submit():
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	myBATTLE_STATE = BATTLE_STATE.YOU_RETRY
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func You_Retry(_callable: Callable):
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	black_panel.self_modulate = Color.TRANSPARENT
	_tween.tween_property(black_panel, "self_modulate", Color.BLACK, 0.3)
	
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		retry_menu.hide()
		win_label.hide()
		#-------------------------------------------------------------------------------
		tp = 13
		Set_TP_Label(tp)
		#-------------------------------------------------------------------------------
		current_player_turn = 0
		battle_menu.global_position = friend_party[0].party_member_ui.button_pivot.global_position
		#-------------------------------------------------------------------------------
		item_array_in_battle.clear()
		for _i in item_array.size():
			item_array_in_battle.append(item_array[_i].Constructor())
		#-------------------------------------------------------------------------------
		friend_party_alive.clear()
		friend_party_dead.clear()
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			#-------------------------------------------------------------------------------
			friend_party[_i].skill_array_in_battle.clear()
			#-------------------------------------------------------------------------------
			for _j in friend_party[_i].skill_array.size():
				friend_party[_i].skill_array_in_battle.append(friend_party[_i].skill_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			friend_party[_i].equip_array_in_battle.clear()
			#-------------------------------------------------------------------------------
			for _j in friend_party[_i].equip_array.size():
				friend_party[_i].equip_array_in_battle.append(friend_party[_i].equip_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			friend_party[_i].statuseffect_array_in_battle.clear()
			#-------------------------------------------------------------------------------
			for _j in friend_party[_i].statuseffect_array.size():
				friend_party[_i].statuseffect_array_in_battle.append(friend_party[_i].statuseffect_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			PlayAnimation(friend_party[_i].playback, "Idle")
			#-------------------------------------------------------------------------------
			friend_party[_i].hp = friend_party[_i].max_hp
			Set_HP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].sp = 0
			Set_SP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].item_serializable = null
			#-------------------------------------------------------------------------------
			friend_party[_i].party_member_ui.show()
			friend_party_alive.append(friend_party[_i])
		#-------------------------------------------------------------------------------
		enemy_party_alive.clear()
		enemy_party_dead.clear()
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			PlayAnimation(enemy_party[_i].playback, "Idle")
			#-------------------------------------------------------------------------------
			enemy_party[_i].hp = enemy_party[_i].max_hp
			Set_HP_Label(enemy_party[_i])
			#-------------------------------------------------------------------------------
			enemy_party[_i].party_member_ui.show()
			enemy_party_alive.append(enemy_party[_i])
		#-------------------------------------------------------------------------------
		battle_menu.show()
		dialogue_menu.show()
		singleton.Move_to_First_Button(battle_menu_button)
	)
	#-------------------------------------------------------------------------------
	#_tween.tween_interval(0.05)
	Move_Fighters_to_Position(_tween, true, 0.05)
	#-------------------------------------------------------------------------------
	_tween.tween_property(black_panel, "self_modulate", Color.TRANSPARENT, 0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		myBATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
		_callable.call()
	)
#-------------------------------------------------------------------------------
func RetryMenu_EscapeButton_Submit():
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	myBATTLE_STATE = BATTLE_STATE.YOU_ESCAPE
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func RetryMenu_GiveUpButton_Submit():
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	get_tree().reload_current_scene()
#-------------------------------------------------------------------------------
func RetryMenu_AnyButton_Cancel():
	battle_menu.show()
	dialogue_menu.show()
	win_label.hide()
	retry_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	singleton.Move_to_First_Button(battle_menu_button)
#-------------------------------------------------------------------------------
func You_Escape():
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.hide()
		PlayAnimation(friend_party[_i].playback, "Idle")
		friend_party[_i].is_Moving = false
		friend_party[_i].z_index = 0
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.hide()
		PlayAnimation(enemy_party[_i].playback, "Idle")
		enemy_party[_i].is_Moving = false
		enemy_party[_i].z_index = 0
		enemy_party[_i].party_member_ui.queue_free()
	#-------------------------------------------------------------------------------
	win_label.hide()
	tp_bar_root.hide()
	battle_black_panel.hide()
	#-------------------------------------------------------------------------------
	var _tween2: Tween = create_tween()
	#-------------------------------------------------------------------------------
	_tween2.tween_callback(func():
		can_enter_fight = false
	)
	#-------------------------------------------------------------------------------
	_tween2.tween_interval(3.0)
	_tween2.tween_callback(func():
		can_enter_fight = true
	)
	#-------------------------------------------------------------------------------
	var _tween3: Tween = create_tween()
	#_tween3.tween_interval(1.0)
	for _i in friend_party.size():
		_tween3.parallel().tween_property(friend_party[_i], "global_position", player_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		_tween3.parallel().tween_property(enemy_party[_i], "global_position", enemy_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	_tween3.tween_callback(func():
		myGAME_STATE = GAME_STATE.IN_WORLD
		singleton.Play_BGM(singleton.stage1)
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TIMER FUNCTIONS
func TimeOut_Tween(_iMax: int):
	var _tween: Tween = create_tween()
	timer_tween = _tween
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		timer = _iMax
		timer_label.show()
		PrintTimer(timer, _iMax)
	)
	#-------------------------------------------------------------------------------
	_tween.tween_interval(1.0)
	#-------------------------------------------------------------------------------
	for _i in _iMax:
		_tween.tween_callback(func():
			timer-=1
			PrintTimer(timer, _iMax)
		)
		_tween.tween_interval(1.0)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		StopEverithing()
	)
	#-------------------------------------------------------------------------------
	await timer_tween.finished
#-------------------------------------------------------------------------------
func PrintTimer(_i:int, _iMax:int):
	timer_label.text = "   "+str(_i).pad_zeros(2)+" / " +str(_iMax).pad_zeros(2) + " s"
#-------------------------------------------------------------------------------
func StopEverithing_and_Timer():
	StopEverithing()
	timer_tween.kill()
	timer_tween.finished.emit()
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func StopEverithing():
	timer_label.text = ""
	timer_label.hide()
	#-------------------------------------------------------------------------------
	KillTween_Array(main_tween_Array)
	#-------------------------------------------------------------------------------
	for _i in range(enemyBullets_Enabled_Array.size()-1, -1, -1):
		Destroy_EnemyBullet(enemyBullets_Enabled_Array[_i])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PLAYER BULLET FUNCTIONS
#-------------------------------------------------------------------------------
func Create_PlayerBullet(_global_position:Vector2, _dir:float) -> Bullet:
	var _bullet: Bullet = bullet_Prefab.instantiate() as Bullet
	_bullet.global_position = _global_position
	_bullet.z_index = 2
	_bullet.scale = Vector2(2, 2)
	_bullet.rotation = _dir
	add_child(_bullet)
	return _bullet
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ENEMY BULLET FUNCTIONS
func Destroy_EnemyBullet(_bullet: Bullet):
	KillTween_Array(_bullet.tween_Array)
	enemyBullets_Enabled_Array.erase(_bullet)
	enemyBullets_Disabled_Array.append(_bullet)
	_bullet.hide()
#-------------------------------------------------------------------------------
func Create_EnemyBullets_Disabled(_iMax:int):
	for _i in _iMax:
		var _bullet: Bullet = bullet_Prefab.instantiate() as Bullet
		enemyBullets_Disabled_Array.append(_bullet)
		_bullet.hide()
		#_bullet.physics_Update = func(): EnemyBullet_PhysicsUpdate(_bullet)
		battle_box.add_child(_bullet)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Create_EnemyBullet_A(_x:float, _y:float, _v:float, _dir:float, _type:String, _can_Go_OffLimits:bool) ->Bullet:
	var _bullet: Bullet = Create_EnemyBullet_Common(_x, _y, _type, _can_Go_OffLimits)
	#-------------------------------------------------------------------------------
	_bullet.vel = _v
	_bullet.dir = _dir
	_bullet.rotation_degrees = _bullet.dir
	_bullet.physics_Update = func(): EnemyBullet_PhysicsUpdate_A(_bullet)
	#-------------------------------------------------------------------------------
	return _bullet
#-------------------------------------------------------------------------------
func Create_EnemyBullet_Common(_x:float, _y:float, _type:String, _can_Go_OffLimits:bool) ->Bullet:
	var _bullet: Bullet
	#-------------------------------------------------------------------------------
	if(enemyBullets_Disabled_Array.size() > 0):
		_bullet = enemyBullets_Disabled_Array[0]
		_bullet.show()
		enemyBullets_Disabled_Array.erase(_bullet)
	#-------------------------------------------------------------------------------
	else:
		_bullet = bullet_Prefab.instantiate() as Bullet
		battle_box.add_child(_bullet)
	#-------------------------------------------------------------------------------
	enemyBullets_Enabled_Array.append(_bullet)
	#-------------------------------------------------------------------------------
	#var _bulletResource: BulletResource = bulletDictionary.get(_type, "bullet1")
	#_bullet.texture = _bulletResource.texture
	#-------------------------------------------------------------------------------
	#_bullet.radius = _bulletResource.radius
	#-------------------------------------------------------------------------------
	_bullet.global_position = Vector2(_x, _y)
	_bullet.isGrazed = false
	_bullet.can_Go_OffLimits = _can_Go_OffLimits
	#-------------------------------------------------------------------------------
	return _bullet
#-------------------------------------------------------------------------------
func EnemyBullet_PhysicsUpdate_A(_bullet: Bullet):
	if(_bullet.can_Go_OffLimits):
		EnemyBullet_PhysicsUpdate_Limitless_A(_bullet)
		return
	#-------------------------------------------------------------------------------
	if(_bullet.global_position.y > screen_limit_up and _bullet.global_position.y < screen_limit_down):
		if(_bullet.global_position.x > screen_limit_left and _bullet.global_position.x < screen_limit_right):
			EnemyBullet_PhysicsUpdate_Limitless_A(_bullet)
		#-------------------------------------------------------------------------------
		else:
			Destroy_EnemyBullet(_bullet)
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		Destroy_EnemyBullet(_bullet)
		return
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func EnemyBullet_PhysicsUpdate_Limitless_A(_bullet: Bullet):
	var _dir2: float = deg_to_rad(_bullet.dir)
	_bullet.vel_X = _bullet.vel * cos(_dir2)
	_bullet.vel_Y = _bullet.vel * sin(_dir2)
	_bullet.rotation_degrees = _bullet.dir
	#-------------------------------------------------------------------------------
	_bullet.position.x += _bullet.vel_X * deltaTimeScale
	_bullet.position.y += _bullet.vel_Y * deltaTimeScale
	return
	#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SPELLCARD FUNCTIONS
func Set_Difficulty() -> float:
	#return enemy_party.size() - enemy_party_alive.size()
	return 3.0 - enemy_party_alive.size()
#-------------------------------------------------------------------------------
func Stage1_Fire2():
	var _tween: Tween = CreateTween_ArrayAppend(main_tween_Array)
	_tween.set_loops()
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	var _mirror = 1
	#-------------------------------------------------------------------------------
	for _j in 2:
		#-------------------------------------------------------------------------------
		for _i in enemy_party_alive.size():
			_tween.tween_callback(func():
				PlayAnimation(enemy_party_alive[_i].playback, "Shot")
				Stage1_Fire2_Bullet1(enemy_party_alive[_i], _mirror)
			)
			_tween.tween_interval(1.0+1.2*_difficulty)
			_mirror *= -1
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Stage1_Fire2_Bullet1(_user:Party_Member, _mirror:float):
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	#-------------------------------------------------------------------------------
	var _max1: float = 10 + 2*_difficulty
	var _max2: float = 10 + 5*_difficulty
	#-------------------------------------------------------------------------------
	var _x: float = camera.position.x+camera_center.x*0.5 * _mirror
	var _y: float = camera.position.y-camera_center.y*0.5
	var _vel: float = 0.6
	var _dir: float = 90
	#-------------------------------------------------------------------------------
	var _vel2: float = 1
	var _dir2: float = randf_range(0, 360)
	#-------------------------------------------------------------------------------
	var _timer: float = 0.2
	#-------------------------------------------------------------------------------
	var _ang: float = 0
	#-------------------------------------------------------------------------------
	var _bullet: Bullet = Create_EnemyBullet_A(_x, _y, _vel, _dir, "bullet2", false)
	var _tween: Tween = CreateTween_ArrayAppend(main_tween_Array)
	#-------------------------------------------------------------------------------
	for _j in _max2:
		#-------------------------------------------------------------------------------
		_tween.tween_callback(func():
			var _dir3: float = 0
			#-------------------------------------------------------------------------------
			for _i in _max1:
				var _x2:float = _bullet.global_position.x
				var _y2:float = _bullet.global_position.y
				var _bullet2: Bullet = Create_EnemyBullet_A(_x2, _y2, _vel2, _dir2+_dir3+_ang, "bullet2", false)
				_dir3 += 360/_max1
			#-------------------------------------------------------------------------------
		)
		#-------------------------------------------------------------------------------
		_ang += 4.0*_mirror
		#-------------------------------------------------------------------------------
		_tween.tween_interval(_timer)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		Destroy_EnemyBullet(_bullet)
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Stage1_Fire1():
	var _tween: Tween = CreateTween_ArrayAppend(main_tween_Array)
	_tween.set_loops()
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	var _mirror = 1
	#-------------------------------------------------------------------------------
	for _j in 2:
		#-------------------------------------------------------------------------------
		for _i in enemy_party_alive.size():
			_tween.tween_callback(func():
				PlayAnimation(enemy_party_alive[_i].playback, "Shot")
				Stage1_Fire1_Bullet1(enemy_party_alive[_i], _mirror)
			)
			_tween.tween_interval(0.8+0.6*_difficulty)
			_mirror *= -1
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Stage1_Fire1_Bullet1(_user:Party_Member, _mirror:float):
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	#-------------------------------------------------------------------------------
	var _max1: float = 10 + 5*_difficulty
	var _max2: float = 5 + 2*_difficulty
	#-------------------------------------------------------------------------------
	var _x: float = camera.position.x+camera_center.x*0.25 * _mirror
	var _y: float = camera.position.y-camera_center.y*0.65
	#-------------------------------------------------------------------------------
	var _vel1: float = 0.25
	var _vel2: float = 1.5
	var _vel_diferential: float = (_vel2-_vel1)/_max2
	var _dir1: float = randf_range(0, 360)
	#-------------------------------------------------------------------------------
	var _dir2: float = 0
	var _x2:float = _x + randf_range(-50, 50)
	var _y2:float = _y + randf_range(-10, 10)
	#-------------------------------------------------------------------------------
	for _i in _max1:
		var _vel: float = _vel1
		#-------------------------------------------------------------------------------
		for _j in _max2:
			var _bullet2: Bullet = Create_EnemyBullet_A(_x2, _y2, _vel, _dir1+_dir2, "bullet2", false)
			_vel += _vel_diferential
		#-------------------------------------------------------------------------------
		_dir2 += 360/_max1
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region HITBOX FUNCTIONS
func Hitbox_Damage():
	if(can_be_hit):
		#-------------------------------------------------------------------------------
		for _i in range(enemyBullets_Enabled_Array.size()-1, -1, -1):
			#-------------------------------------------------------------------------------
			if(myGAME_STATE == GAME_STATE.IN_BATTLE):
				var _bullet: Bullet = enemyBullets_Enabled_Array[_i]
				if(_bullet.global_position.distance_to(hitbox.global_position) <  (_bullet.radius+grazeBox_radius) and !_bullet.isGrazed):
					#Bullet_Grazed_SP_Gain()
					Bullet_Grazed_TP_Gain()
					_bullet.isGrazed = true
				#-------------------------------------------------------------------------------
				if(_bullet.global_position.distance_to(hitbox.global_position) < (_bullet.radius+hitBox_radius) and canBeHit):
					Player_Shooted()
					Destroy_EnemyBullet(_bullet)
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		i_frames -= 1
		#-------------------------------------------------------------------------------
		if(i_frames < 0):
			can_be_hit = true
			hitbox.visible = true
		#-------------------------------------------------------------------------------
		elif(i_frames % 2 == 0):
			#-------------------------------------------------------------------------------
			if(hitbox.visible):
				hitbox.visible = false
			#-------------------------------------------------------------------------------
			else:
				hitbox.visible = true
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Player_Shooted():
	#-------------------------------------------------------------------------------
	i_frames = 15
	can_be_hit = false
	#-------------------------------------------------------------------------------
	if(friend_party_alive.size() > 0):
		var _target: Party_Member = friend_party_alive.pick_random()
		var _int: int
		#-------------------------------------------------------------------------------
		if(_target.is_in_guard):
			_int = 5
		#-------------------------------------------------------------------------------
		else:
			_int = 10
		#-------------------------------------------------------------------------------
		_target.hp -= _int
		#-------------------------------------------------------------------------------
		var _label: Label = Spawn_Label_in_User(_target)
		#-------------------------------------------------------------------------------
		if(_target.hp > 0):
			Flying_Label(_label, "-"+str(_int)+" HP")
			#-------------------------------------------------------------------------------
			if(_target.is_in_guard):
				PlayAnimation(_target.playback, "Crouch_Hurt")
			#-------------------------------------------------------------------------------
			else:
				PlayAnimation(_target.playback, "Hurt")
			#-------------------------------------------------------------------------------
			Set_HP_Label(_target)
		#-------------------------------------------------------------------------------
		else:
			_target.hp = 0
			Flying_Label(_label, "Down")
			Set_HP_Label(_target)
			PlayAnimation(_target.playback, "Death")
			#-------------------------------------------------------------------------------
			friend_party_alive.erase(_target)
			#-------------------------------------------------------------------------------
			if(friend_party_alive.size() <= 0):
				StopEverithing_and_Timer()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	else:
		StopEverithing_and_Timer()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Spawn_Label_in_User(_user:Party_Member) -> Label:
	var _label: Label = Label.new()
	var _global_position: Vector2 = _user.global_position
	_global_position.y -= 20.0
	#-------------------------------------------------------------------------------
	for _i in _user.damage_label_array.size():
		#-------------------------------------------------------------------------------
		if(_user.damage_label_array[_i] == null):
			_user.damage_label_array[_i] = _label
			_global_position.y -= 8.0 * float(_i)
			_label.global_position = _global_position
			add_child(_label)
			return _label
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	_user.damage_label_array.append(_label)
	_global_position.y -= 8.0 * float(_user.damage_label_array.size()-1)
	_label.global_position = _global_position
	add_child(_label)
	return _label
#-------------------------------------------------------------------------------
func You_Lose(_callable:Callable):
	#-------------------------------------------------------------------------------
	var _tween:Tween = create_tween()
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		timer_tween.kill()
		battle_box.hide()
		retry_menu.hide()
		win_label.text = "You Lose"
		win_label.show()
	)
	#-------------------------------------------------------------------------------
	_tween.tween_interval(1.0)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		retry_menu.show()
		singleton.Set_Button(retry_menu_button[0], func():singleton.Common_Selected(), func():LoseMenu_RetryButton_Submit(_callable), func():pass)
		singleton.Set_Button(retry_menu_button[1], func():singleton.Common_Selected(), func():LoseMenu_EscapeButton_Submit(), func():pass)
		singleton.Set_Button(retry_menu_button[2], func():singleton.Common_Selected(), func():LoseMenu_GiveUpButton_Submit(), func():pass)
		singleton.Move_to_Button(retry_menu_button[0])
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func LoseMenu_RetryButton_Submit(_callable:Callable):
	singleton.Common_Submited()
	You_Retry(_callable)
#-------------------------------------------------------------------------------
func LoseMenu_EscapeButton_Submit():
	singleton.Common_Submited()
	You_Escape()
#-------------------------------------------------------------------------------
func LoseMenu_GiveUpButton_Submit():
	RetryMenu_GiveUpButton_Submit()
#-------------------------------------------------------------------------------
func Bullet_Grazed_SP_Gain():
	var _target_party: Array[Party_Member] = []
	#-------------------------------------------------------------------------------
	for _i in friend_party_alive.size():
		#-------------------------------------------------------------------------------
		if(friend_party_alive[_i].sp < friend_party_alive[_i].max_sp):
			_target_party.append(friend_party_alive[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(_target_party.size() > 0):
		_target_party.shuffle()
		_target_party[0].sp += 1
		SP_Gain_VisualEffect(_target_party[0].global_position)
		#-------------------------------------------------------------------------------
		if(_target_party[0].sp > _target_party[0].max_sp):
			_target_party[0].sp = _target_party[0].max_sp
		#-------------------------------------------------------------------------------
		Set_SP_Label(_target_party[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Bullet_Grazed_TP_Gain():
	tp += 1
	#-------------------------------------------------------------------------------
	if(tp > max_tp):
		tp = max_tp
	#-------------------------------------------------------------------------------
	Set_TP_Label(tp)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PARTY_SKILLS CALLABLES
#-------------------------------------------------------------------------------
func Attack(_user:Party_Member):
	var _global_position: Vector2 = _user.target.global_position + Vector2(-30, -60)
	var _dir: float = Get_Dir_XY(Vector2(30,30))
	var _sprite2d: Bullet = Create_PlayerBullet(_global_position, _dir)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		PlayAnimation(_user.playback, "Shot")
		tp += 5
		Set_TP_Label(tp)
		HP_Damage(_user.target, 5)
	)
	#-------------------------------------------------------------------------------
	_tween.tween_property(_sprite2d, "global_position", _global_position + Vector2(60,60), 0.25)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_sprite2d.queue_free()
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Defense(_user:Party_Member):
	_user.is_in_guard = true
	var _label: Label = Spawn_Label_in_User(_user)
	tp += 5
	Set_TP_Label(tp)
	Flying_Label(_label, "+Guard")
#-------------------------------------------------------------------------------
func Skill_0_0(_user:Party_Member):
	var _global_position: Vector2 = _user.target.global_position + Vector2(-30, -50)
	var _dir: float = Get_Dir_XY(Vector2(15,30))
	var _bullet: Bullet = Create_PlayerBullet(_global_position, _dir)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	var _dx: float = 15
	var _dy: float = 15
	for _i in 4:
		_tween.tween_callback(func():
			PlayAnimation(_user.playback, "Shot")
			HP_Damage(_user.target, 5)
			_bullet.rotation = Get_Dir_XY(Vector2(15, _dy))
		)
		#-------------------------------------------------------------------------------
		_tween.tween_property(_bullet, "global_position", _bullet.global_position + Vector2(_dx,15+_dy), 0.1)
		_dx += 15
		_dy *=-1
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_bullet.queue_free()
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Skill_0_1(_user:Party_Member):
	var _global_position: Vector2 = _user.target.global_position + Vector2(-150, -30)
	var _sprite2d: Bullet = Create_PlayerBullet(_global_position, 0)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	PlayAnimation(_user.playback, "Shot")
	_tween.tween_property(_sprite2d, "global_position", _global_position + Vector2(150,0), 0.3)
	_tween.tween_interval(0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		HP_Damage(_user.target, 15)
	)
	#-------------------------------------------------------------------------------
	_tween.tween_property(_sprite2d, "global_position", _global_position + Vector2(200,0), 0.1)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_sprite2d.queue_free()
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Skill_0_2(_user:Party_Member):
	PlayAnimation(_user.playback, "Shot")
	var _hp = _user.target.hp
	HP_Heal_Porcentual(_user.target, 1.0)
	#-------------------------------------------------------------------------------
	if(_hp <= 0):
		PlayAnimation(_user.target.playback, "Idle")
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PARTY_ITEMS CALLABLES
#-------------------------------------------------------------------------------
func Item_0_0(_user:Party_Member):
	PlayAnimation(_user.playback, "Shot")
	HP_Heal_Porcentual(_user.target, 0.5)
	PlayAnimation(_user.target.playback, "Idle")
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func Item_0_1(_user:Party_Member):
	PlayAnimation(_user.playback, "Shot")
	HP_Heal_Porcentual(_user.target, 1.0)
	PlayAnimation(_user.target.playback, "Idle")
	await Seconds(0.3)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region COMMON FUNCTIONS
#-------------------------------------------------------------------------------
func Get_Dir_XY(_v2:Vector2) -> float:
	var _dir: float = atan2(_v2.y, _v2.x)
	return _dir
#-------------------------------------------------------------------------------
func Flying_Label(_label:Label, _s:String):
	_label.add_theme_font_size_override("font_size", 30)
	_label.add_theme_constant_override("outline_size", 5)
	_label.scale = Vector2.ONE /camera.zoom
	_label.text = _s
	_label.z_index = 10
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_property(_label, "global_position", _label.global_position + Vector2(20, -10), 0.12)
	_tween.tween_property(_label, "global_position", _label.global_position + Vector2(20, 0), 0.12)
	_tween.tween_property(_label, "global_position", _label.global_position + Vector2(20, -5), 0.12)
	_tween.tween_property(_label, "global_position", _label.global_position + Vector2(20, 0), 0.12)
	_tween.tween_interval(0.7)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_label.queue_free()
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SP_Gain_VisualEffect(_pos:Vector2):
	var _label: Label = Label.new()
	_label.add_theme_font_size_override("font_size", 12)
	_label.add_theme_constant_override("outline_size", 4)
	_label.scale = Vector2.ONE /camera.zoom
	_label.text = "+1 SP"
	_pos.y -= 3
	_pos.x = randf_range(_pos.x-25, _pos.x+25)
	_label.global_position = _pos
	_label.z_index = 2
	add_child(_label)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_property(_label, "global_position", _pos + Vector2(0, -30), 1.0)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_label.queue_free()
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func get_resource_filename(_resource: Resource) -> String:
	return _resource.resource_path.get_file().trim_suffix('.tres')
#-------------------------------------------------------------------------------
func Destroy_Childrens(_node:Node):
	var children = _node.get_children()
	#-------------------------------------------------------------------------------
	for _child in children:
		_child.queue_free()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func HP_Damage(_target:Party_Member, _int:int):
	if(_target.hp > 0):
		_target.hp -= _int
		#-------------------------------------------------------------------------------
		var _label: Label = Spawn_Label_in_User(_target)
		#-------------------------------------------------------------------------------
		if(_target.hp > 0):
			PlayAnimation(_target.playback, "Hurt 2")
			Flying_Label(_label, "-"+str(_int)+" HP")
		#-------------------------------------------------------------------------------
		else:
			_target.hp = 0
			PlayAnimation(_target.playback, "Death")
			Flying_Label(_label, "Down")
		#-------------------------------------------------------------------------------
		Set_HP_Label(_target)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func HP_Heal_Porcentual(_target:Party_Member, _float:float):
	var _int: int = int(float(_target.max_hp)*_float)
	_target.hp += _int
	#-------------------------------------------------------------------------------
	var _label: Label = Spawn_Label_in_User(_target)
	#-------------------------------------------------------------------------------
	if(_target.hp < _target.max_hp):
		Flying_Label(_label, "+"+str(_int)+" HP")
	#-------------------------------------------------------------------------------
	else:
		_target.hp = _target.max_hp
		Flying_Label(_label, "Max HP")
	#-------------------------------------------------------------------------------
	Set_HP_Label(_target)
#-------------------------------------------------------------------------------
func Set_HP_Label(_user:Party_Member):
	_user.party_member_ui.label_hp.text = "  "+str(_user.hp)+" / "+str(_user.max_hp)+" HP  "
	_user.party_member_ui.bar_hp.max_value = _user.max_hp
	_user.party_member_ui.bar_hp.value = _user.hp
#-------------------------------------------------------------------------------
func Set_SP_Label(_user:Party_Member):
	_user.party_member_ui.label_sp.text = "  "+str(_user.sp)+" / "+str(_user.max_sp)+" SP  "
	_user.party_member_ui.bar_sp.max_value = _user.max_sp
	_user.party_member_ui.bar_sp.value = _user.sp
#-------------------------------------------------------------------------------
func Set_TP_Label(_i: int):
	tp_bar_label.text = str(_i)+" / "+str(max_tp)+" TP"
	tp_bar_progressbar_present.max_value = max_tp
	tp_bar_progressbar_present.value = _i
#-------------------------------------------------------------------------------
func Set_TP_Label_from_the_future():
	var _tp: int = tp
	#-------------------------------------------------------------------------------
	for _i in current_player_turn:
		_tp -= friend_party[_i].item_serializable.item_resource.tp_cost
	#-------------------------------------------------------------------------------
	Set_TP_Label(_tp)
#-------------------------------------------------------------------------------
func PlayAnimation(_playback:AnimationNodeStateMachinePlayback, _s: String):
	#playback.travel(_s)
	_playback.call_deferred("travel", _s)
#-------------------------------------------------------------------------------
func Get_CircleSprite_Scale(_scale: float) -> Vector2:
	_scale *= 0.75/95.0
	var _v2: Vector2 = Vector2(_scale, _scale)
	return _v2
#-------------------------------------------------------------------------------
func Set_Vertical_Navigation(_button_array:Array[Button]):
	#-------------------------------------------------------------------------------
	if(_button_array.size() > 0):
		if(_button_array.size() > 2):
			Set_Vertical_Navigation_Button(_button_array[0], _button_array[_button_array.size()-1], _button_array[1])
			#-------------------------------------------------------------------------------
			for _i in range(1, _button_array.size()-1):
				Set_Vertical_Navigation_Button(_button_array[_i], _button_array[_i-1], _button_array[_i+1])
			#-------------------------------------------------------------------------------
			Set_Vertical_Navigation_Button(_button_array[_button_array.size()-1], _button_array[_button_array.size()-2], _button_array[0])
		#-------------------------------------------------------------------------------
		else:
			Set_Vertical_Navigation_Button(_button_array[0], _button_array[0], _button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Vertical_Navigation_Button(_button:Button, _button_top:Button, _button_botton:Button):
	_button.focus_neighbor_top = _button_top.get_path()
	_button.focus_neighbor_bottom = _button_botton.get_path()
	_button.focus_neighbor_left = _button.get_path()
	_button.focus_neighbor_right = _button.get_path()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ARRAY[TWEEN] FUNCTIONS
func CreateTween_ArrayAppend(_tween_Array: Array[Tween]) -> Tween:
	var _tween: Tween = create_tween()
	_tween_Array.append(_tween)
	_tween.finished.connect(func():_tween_Array.erase(_tween))
	return _tween
#-------------------------------------------------------------------------------
func KillTween_Array(_tween_Array: Array[Tween]):
	for _i in range(_tween_Array.size()-1, -1, -1):
		_tween_Array[_i].kill()
		_tween_Array[_i].finished.emit()
#endregion
#-------------------------------------------------------------------------------
#region DEBUG FUNCTIONS
func Debug_Information() -> void:
	var _s: String = ""
	_s += "Current Turn ID: " + str(current_player_turn)+"\n"
	_s += "Grab Focus: " + str(get_viewport().gui_get_focus_owner())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Tweens: "+str(tween_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Player: " + str(friend_party.size())+"\n"
	_s += "Player Alive: " + str(friend_party_alive.size())+"\n"
	_s += "Player Death: " + str(friend_party_dead.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Enemy: " + str(enemy_party.size())+"\n"
	_s += "Enemy Alive: " + str(enemy_party_alive.size())+"\n"
	_s += "Enemy Death: " + str(enemy_party_dead.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Enemy Bullets Enabled: " + str(enemyBullets_Enabled_Array.size())+"\n"
	_s += "Enemy Bullets Disabled: " + str(enemyBullets_Disabled_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	if(item_array.size() > 0):
		_s += "Potion Item: " + str(item_array[0].hold)+"\n"
	if(item_array_in_battle.size() > 0):
		_s += "Potion Item in Battle: " + str(item_array_in_battle[0].hold)+"\n"
	if(friend_party[2].skill_array.size() > 0):
		_s += "Potion Skill: " + str(friend_party[2].skill_array[0].hold)+"\n"
	if(friend_party[2].skill_array_in_battle.size() > 0):
		_s += "Potion Skill in Battle: " + str(friend_party[2].skill_array_in_battle[0].hold)+"\n"
	debug_label.text = _s
#-------------------------------------------------------------------------------
func Show_fps():
	fps_label.text = str(Engine.get_frames_per_second()) + " fps."
#-------------------------------------------------------------------------------
func Set_DebugInfo() -> void:
	#-------------------------------------------------------------------------------
	if(Input.is_action_just_pressed("Debug_Info")):
		debug_label.visible = !debug_label.visible
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_SlowMotion() -> void:
	#-------------------------------------------------------------------------------
	if(Input.is_action_just_pressed("Debug_SlowMotion")):
		if(isSlowMotion):
			NormalMotion()
		#-------------------------------------------------------------------------------
		else:
			Engine.time_scale = 0.3
			deltaTimeScale = 0.3
			isSlowMotion = true
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func NormalMotion():
	Engine.time_scale = 1.0
	deltaTimeScale = 1.0
	isSlowMotion = false
#-------------------------------------------------------------------------------
func Input_PauseGame() -> void:
	if(Input.is_action_just_pressed("Input_Pause")):
		PauseMenu_Open()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseMenu_Open():
	pause_menu_panel.show()
	pause_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_button_array[0])
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	PauseOn()
#-------------------------------------------------------------------------------
func PauseOn():
	#-------------------------------------------------------------------------------
	get_tree().set_deferred("paused", true)
#-------------------------------------------------------------------------------
func PauseMenu_Close():
	pause_menu_panel.hide()
	pause_menu.hide()
	#-------------------------------------------------------------------------------
	PauseOff()
#-------------------------------------------------------------------------------
func PauseOff():
	get_tree().set_deferred("paused", false)
#endregion
#-------------------------------------------------------------------------------
func PauseMenu_Set():
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _player_ui: Party_Button =pause_menu_party_button_array[_i]
		#-------------------------------------------------------------------------------
		_player_ui.label_hp.text = "  "+str(friend_party[_i].max_hp)+" / "+str(friend_party[_i].max_hp)+" HP  "
		_player_ui.bar_hp.max_value = friend_party[_i].max_hp
		_player_ui.bar_hp.value = friend_party[_i].max_hp
		#-------------------------------------------------------------------------------
		_player_ui.label_sp.text = "  "+str(friend_party[_i].max_sp)+" / "+str(friend_party[_i].max_sp)+" SP  "
		_player_ui.bar_sp.max_value = friend_party[_i].max_sp
		_player_ui.bar_sp.value = friend_party[_i].max_sp
		#-------------------------------------------------------------------------------
		pause_menu_party_button_array[_i].title.text = friend_party[_i].id + "\n"
		pause_menu_party_button_array[_i].title.text += "The Hero Number "+str(_i)
		pause_menu_party_button_array[_i].texture.texture = friend_party[_i].texture2d
		#-------------------------------------------------------------------------------
		_button_array.append(_player_ui.button)
	#-------------------------------------------------------------------------------
	Set_Vertical_Navigation(_button_array)
	#-------------------------------------------------------------------------------
	Set_Vertical_Navigation(pause_menu_button_array)
	#-------------------------------------------------------------------------------
	singleton.Set_Button(pause_menu_button_array[0],func():singleton.Common_Selected() , func():PauseMenu_SkillButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[1],func():singleton.Common_Selected() , func():PauseMenu_ItemButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[2],func():singleton.Common_Selected() , func():PauseMenu_EquipButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[3],func():singleton.Common_Selected() , func():PauseMenu_StatusButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[4],func():singleton.Common_Selected() , func():PauseMenu_OptionButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[5],func():singleton.Common_Selected() , func():get_tree().quit(), func():PauseMenu_AnyButton_Cancel())
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_Submit():
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		singleton.Set_Button(_b, func():singleton.Common_Selected() , func():PauseMenu_SkillButton_PartyButton_Submit(_i), func():PauseMenu_SkillButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_party_button_array[0].button)
	pause_menu_button_array[0].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_ItemButton_Submit():
	pause_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(item_menu.get_tab_bar(),func():ItemMenu_No_Description(), func():PauseMenu_ItemButton_ItemMenu_Cancel())
	#-------------------------------------------------------------------------------
	for _i in item_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		var _hold: int = item_array[_i].hold
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(item_array[_i] == (friend_party[_j].item_serializable)):
				_hold -= 1
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(item_array[_i].item_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_consumable_content.add_child(_button)
		item_menu_consumable_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = ""
		#-------------------------------------------------------------------------------
		if(item_array[_i].item_resource.hp_cost > 0):
			_label2.text += "("+str(item_array[_i].item_resource.hp_cost)+" HP)  "
		#-------------------------------------------------------------------------------
		if(item_array[_i].item_resource.sp_cost > 0):
			_label2.text += "("+str(item_array[_i].item_resource.sp_cost)+" SP)  "
		#-------------------------------------------------------------------------------
		if(item_array[_i].item_resource.tp_cost > 0):
			_label2.text += "("+str(item_array[_i].item_resource.tp_cost)+" TP)  "
		#-------------------------------------------------------------------------------
		if(item_array[_i].item_resource.max_hold > 0):
			_label2.text += "["+str(_hold)+" / "+str(item_array[_i].item_resource.max_hold)+"]  "
		#-------------------------------------------------------------------------------
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			singleton.Move_to_Button(item_menu_consumable_button_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():ItemMenu_Consumable_ItemButton_Selected(item_array[_i]), func():pass, func():PauseMenu_ItemButton_ItemMenu_Cancel())
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(equip_array[_i].equip_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_equipment_content.add_child(_button)
		item_menu_equipment_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(equip_array[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():ItemMenu_Equipment_ItemButton_Selected(equip_array[_i]), func():pass, func():PauseMenu_ItemButton_ItemMenu_Cancel())
	#-------------------------------------------------------------------------------
	for _i in key_item_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(key_item_array[_i].key_item_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_keyitems_content.add_child(_button)
		item_menu_keyitems_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(key_item_array[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():ItemMenu_KeyItem_ItemButton_Selected(key_item_array[_i]), func():pass, func():PauseMenu_ItemButton_ItemMenu_Cancel())
	#-------------------------------------------------------------------------------
	item_menu.current_tab = 0
	item_menu_consumable_scrollContainer.scroll_vertical = 0
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = item_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	if(item_menu_consumable_button_array.size() > 0):
		singleton.Move_to_Button(item_menu_consumable_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, false)
	_tabbar.set_tab_disabled(1, false)
	_tabbar.set_tab_disabled(2, false)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 0
#-------------------------------------------------------------------------------
func ItemMenu_No_Description():
	singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	item_menu_consumable_description.text = ""
	item_menu_consumable_lore.text = ""
	#-------------------------------------------------------------------------------
	item_menu_equipment_description.text = ""
	item_menu_equipment_lore.text = ""
	#-------------------------------------------------------------------------------
	item_menu_keyitems_description.text = ""
	item_menu_keyitems_lore.text = ""
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func EquipMenu_No_Description():
	singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	item_menu_equipment_lore.text = ""
	item_menu_equipment_description.text = ""
#-------------------------------------------------------------------------------
func StatusMenu_No_Description(_user:Party_Member):
	singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	status_menu_information_description.text = _user.description
	status_menu_information_lore.text = _user.lore
	#-------------------------------------------------------------------------------
	status_menu_stats_description.text = ""
	status_menu_stats_lore.text = ""
	#-------------------------------------------------------------------------------
	equipslot_menu_lore.text = ""
	equipslot_menu_description.text = ""
	#-------------------------------------------------------------------------------
	skill_menu_description.text = ""
	skill_menu_lore.text = ""
	#-------------------------------------------------------------------------------
	status_menu_statuseffect_description.text = ""
	status_menu_statuseffect_lore.text = ""
#-------------------------------------------------------------------------------
func TeleportMenu_No_Description():
	singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	teleporty_menu_rect.texture = null
	teleporty_menu_description.text = ""
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_Submit():
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		singleton.Set_Button(_b, func():singleton.Common_Selected() , func():PauseMenu_EquipButton_PartyButton_Submit(_i), func():PauseMenu_EquipButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_party_button_array[0].button)
	pause_menu_button_array[2].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_Submit():
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		singleton.Set_Button(_b, func():singleton.Common_Selected() , func():PauseMenu_StatusButton_PartyButton_Submit(_i), func():PauseMenu_StatusButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_party_button_array[0].button)
	pause_menu_button_array[3].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_AnyButton_Cancel():
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	await get_tree().physics_frame
	PauseMenu_Close()
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	status_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	var _user: Party_Member = friend_party[_index]
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(status_menu.get_tab_bar(),func():StatusMenu_No_Description(_user), func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	for _i in _user.skill_array.size():
		#-------------------------------------------------------------------------------
		var _item_serializable: Item_Serializable = _user.skill_array[_i]
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(_item_serializable.item_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		skill_menu_content.add_child(_button)
		skill_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = ""
		#-------------------------------------------------------------------------------
		if(_item_serializable.item_resource.hp_cost > 0):
			_label2.text += "  ("+str(_item_serializable.item_resource.hp_cost)+" HP)  "
		#-------------------------------------------------------------------------------
		if(_item_serializable.item_resource.sp_cost > 0):
			_label2.text += "  ("+str(_item_serializable.item_resource.sp_cost)+" SP)  "
		#-------------------------------------------------------------------------------
		if(_item_serializable.item_resource.tp_cost > 0):
			_label2.text += "  ("+str(_item_serializable.item_resource.tp_cost)+" TP)  "
		#-------------------------------------------------------------------------------
		if(_item_serializable.item_resource.max_hold > 0):
			_label2.text += "["+str(_item_serializable.hold)+" / "+str(_item_serializable.item_resource.max_hold)+"]  "
		#-------------------------------------------------------------------------------
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			status_menu.show()
			singleton.Move_to_Button(skill_menu_button_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():SkillMenu_SkillButton_Selected(_item_serializable), func():pass, func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = status_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	if(skill_menu_button_array.size() > 0):
		singleton.Move_to_Button(skill_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, true)
	_tabbar.set_tab_disabled(1, true)
	_tabbar.set_tab_disabled(2, true)
	_tabbar.set_tab_disabled(3, false)
	_tabbar.set_tab_disabled(4, true)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 3
	skill_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_PartyButton_Cancel():
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	pause_menu_button_array[0].disabled = false
	singleton.Move_to_Button(pause_menu_button_array[0])
#-------------------------------------------------------------------------------
func PauseMenu_ItemButton_ItemMenu_Cancel():
	PauseMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	pause_menu.show()
	singleton.Move_to_Button(pause_menu_button_array[1])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func PauseMenu_ItemMenu_Exit_Common():
	item_menu.hide()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(item_menu_consumable_button_array)
	Destroy_All_Items(item_menu_equipment_button_array)
	Destroy_All_Items(item_menu_keyitems_button_array)
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	status_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	var _user: Party_Member = friend_party[_index]
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(status_menu.get_tab_bar(), func():StatusMenu_No_Description(_user), func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	for _i in _user.equip_array.size():
		var _button:Button = Button.new()
		_button.theme = ui_theme
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		#-------------------------------------------------------------------------------
		var _equip_serializable: Equip_Serializable = _user.equip_array[_i]
		#-------------------------------------------------------------------------------
		if(_equip_serializable.equip_resource == null):
			_button.text = "  [Empty]  "
		#-------------------------------------------------------------------------------
		else:
			_button.text = get_resource_filename(_equip_serializable.equip_resource)
		#-------------------------------------------------------------------------------
		equipslot_menu_button_array.append(_button)
		equipslot_menu_content.add_child(_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(equipslot_menu_button_array[_i], func():EquipSlotMenu_EquipButton_Selected(_user, _user.equip_array, _i), func(): PauseMenu_EquipButton_PartyButton_EquipSlot_Submit(_user, _i), func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = status_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	if(equipslot_menu_button_array.size() > 0):
		singleton.Move_to_Button(equipslot_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, true)
	_tabbar.set_tab_disabled(1, true)
	_tabbar.set_tab_disabled(2, false)
	_tabbar.set_tab_disabled(3, true)
	_tabbar.set_tab_disabled(4, true)
	#-------------------------------------------------------------------------------
	_tabbar.current_tab = 2
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_Submit(_user:Party_Member, _index_slot:int):
	status_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(item_menu.get_tab_bar(), func():EquipMenu_No_Description(), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot))
	#-------------------------------------------------------------------------------
	var _empty_button: Button = Button.new()
	_empty_button.theme = ui_theme
	_empty_button.text = "  [Empty]  "
	_empty_button.add_theme_font_size_override("font_size", 24)
	_empty_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	item_menu_equipment_content.add_child(_empty_button)
	item_menu_equipment_button_array.append(_empty_button)
	singleton.Set_Button(_empty_button, func():EquipMenu_No_Description(), func():PauseMenu_EquipButton_PartyButton_EmptyEquipSlot_EquipMenu_Submit(_user, _index_slot), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot))
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(equip_array[_i].equip_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_equipment_content.add_child(_button)
		item_menu_equipment_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(equip_array[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			singleton.Move_to_Button(item_menu_equipment_button_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():EquipMenu_EquipButton_Selected(equip_array[_i]), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Submit(_user, equip_array[_i], _index_slot), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot))
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = item_menu.get_tab_bar()
	_tabbar.set_tab_disabled(0, true)
	_tabbar.set_tab_disabled(1, false)
	_tabbar.set_tab_disabled(2, true)
	#-------------------------------------------------------------------------------
	item_menu.current_tab = 1
	item_menu_equipment_scrollContainer.scroll_vertical = 0
	singleton.Move_to_Button(item_menu_equipment_button_array[0])
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Submit(_user: Party_Member, _equip_serializable:Equip_Serializable, _index_slot:int):
	#-------------------------------------------------------------------------------
	if(_user.equip_array[_index_slot].equip_resource != _equip_serializable.equip_resource):
		Remove_Equip_Serializable_to_Array(_equip_serializable)
		#-------------------------------------------------------------------------------
		_user.equip_array[_index_slot].equip_resource = _equip_serializable.equip_resource
		_user.equip_array[_index_slot].hold = 1
		#-------------------------------------------------------------------------------
		equipslot_menu_button_array[_index_slot].text = get_resource_filename(_equip_serializable.equip_resource)
	#-------------------------------------------------------------------------------
	PauseMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	status_menu.show()
	singleton.Common_Submited()
	singleton.Move_to_Button(equipslot_menu_button_array[_index_slot])
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EmptyEquipSlot_EquipMenu_Submit(_user: Party_Member, _index_slot:int):
	#-------------------------------------------------------------------------------
	if(_user.equip_array[_index_slot].equip_resource != null):
		Add_Equip_Serializable_to_Array(_user.equip_array[_index_slot].equip_resource)
		#-------------------------------------------------------------------------------
		_user.equip_array[_index_slot].equip_resource = null
		_user.equip_array[_index_slot].hold = 0
		#-------------------------------------------------------------------------------
		equipslot_menu_button_array[_index_slot].text = "  [Empty]  "
	#-------------------------------------------------------------------------------
	PauseMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	status_menu.show()
	singleton.Common_Submited()
	singleton.Move_to_Button(equipslot_menu_button_array[_index_slot])
#-------------------------------------------------------------------------------
func Add_Equip_Serializable_to_Array(_equip_resource: Equip_Resource):
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		if(equip_array[_i].equip_resource == _equip_resource):
			equip_array[_i].hold += 1
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
	_equip_serializable.equip_resource = _equip_resource
	_equip_serializable.hold = 1
	equip_array.append(_equip_serializable)
	return
#-------------------------------------------------------------------------------
func Remove_Equip_Serializable_to_Array(_equip_serializable: Equip_Serializable):
	_equip_serializable.hold -= 1
	#-------------------------------------------------------------------------------
	if(_equip_serializable.hold <= 0):
		equip_array.erase(_equip_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot:int):
	PauseMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	status_menu.show()
	singleton.Common_Canceled()
	singleton.Move_to_Button(equipslot_menu_button_array[_index_slot])
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_Cancel():
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	pause_menu_button_array[2].disabled = false
	singleton.Move_to_Button(pause_menu_button_array[2])
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	status_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	var _user: Party_Member = friend_party[_index]
	#-------------------------------------------------------------------------------
	Show_Status_Data(_user)
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(status_menu.get_tab_bar(), func():StatusMenu_No_Description(_user), func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	for _i in status_menu_stats_button_array.size():
		singleton.Set_Button(status_menu_stats_button_array[_i], func():StatusMenu_StatsButton_Selected(_i), func():pass, func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	for _i in _user.equip_array.size():
		var _button:Button = Button.new()
		_button.theme = ui_theme
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		#-------------------------------------------------------------------------------
		var _equip_serializable: Equip_Serializable = _user.equip_array[_i]
		#-------------------------------------------------------------------------------
		if(_equip_serializable.equip_resource == null):
			_button.text = "  [Empty]  "
		#-------------------------------------------------------------------------------
		else:
			_button.text = get_resource_filename(_equip_serializable.equip_resource)
		#-------------------------------------------------------------------------------
		equipslot_menu_button_array.append(_button)
		equipslot_menu_content.add_child(_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(equipslot_menu_button_array[_i], func():EquipSlotMenu_EquipButton_Selected(_user, _user.equip_array, _i), func(): pass, func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	for _i in _user.statuseffect_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+get_resource_filename(friend_party[_index].statuseffect_array[_i].statuseffect_resource)+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		status_menu_statuseffect_content.add_child(_button)
		status_menu_statuseffect_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "[x"+str(friend_party[_index].statuseffect_array[_i].hold)+"]  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			singleton.Move_to_Button(status_menu_statuseffect_button_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, func():StatusMenu_StatusEffectButton_Selected(friend_party[_index].statuseffect_array[_i]), func():pass, func():PauseMenu_StatusMenu_Exit_Common(_index))
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = status_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, false)
	_tabbar.set_tab_disabled(1, false)
	_tabbar.set_tab_disabled(2, true)
	_tabbar.set_tab_disabled(3, true)
	_tabbar.set_tab_disabled(4, false)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(_tabbar)
	_tabbar.current_tab = 0
#-------------------------------------------------------------------------------
func Show_Status_Data(_user:Party_Member):
	status_menu_information_image.texture = _user.texture2d
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseMenu_StatusMenu_Exit_Common(_index:int):
	status_menu.hide()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(status_menu_statuseffect_button_array)
	Destroy_All_Items(equipslot_menu_button_array)
	Destroy_All_Items(skill_menu_button_array)
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	pause_menu.show()
	singleton.Move_to_Button(pause_menu_party_button_array[_index].button)
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_PartyButton_Cancel():
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	pause_menu_button_array[3].disabled = false
	singleton.Move_to_Button(pause_menu_button_array[3])
#-------------------------------------------------------------------------------
func PauseMenu_OptionButton_Submit():
	singleton.optionMenu.show()
	singleton.Move_to_Button(singleton.optionMenu.back)
	pause_menu.hide()
	singleton.Common_Submited()
	singleton.Set_Button(singleton.optionMenu.back, func():singleton.Common_Selected(), func():OptionMenu_BackButton_Subited(), func():OptionMenu_BackButton_Canceled())
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Subited() -> void:
	OptionMenu_BackButton_Common()
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Canceled() -> void:
	OptionMenu_BackButton_Common()
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Common() -> void:
	singleton.optionMenu.Save_OptionSaveData_Json()
	singleton.optionMenu.hide()
	pause_menu.show()
	singleton.Move_to_Button(pause_menu_button_array[4])
#-------------------------------------------------------------------------------
func SaveMenu_Open(_s:String, _dialogue:String):	# Used by "SaveSpot_Script".
	Dialogue_Open()
	await Dialogue(false, _dialogue)
	Dialogue_Close()
	#-------------------------------------------------------------------------------
	pause_menu_panel.show()
	savespot_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(savespot_menu_button_array[0], func():singleton.Common_Selected(), func():SaveMenu_SaveButton_Submit(_s), func():SaveMenu_Close())
	singleton.Set_Button(savespot_menu_button_array[1], func():singleton.Common_Selected(), func():SaveMenu_TeleportButton_Submit(), func():SaveMenu_Close())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(savespot_menu_button_array[0])
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	PauseOn()
#-------------------------------------------------------------------------------
func Add_New_SaveSpot_for_Teleporting_Options(_savespot: String):
	var _array: Array = singleton.currentSaveData_Json.get("teleport_options", [])
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		if(_array[_i].get("room", "") == room_test.room_id):
			_array[_i]["savespot"] = _savespot
			#-------------------------------------------------------------------------------
			sort_by_name_ascending(_array)
			#-------------------------------------------------------------------------------
			singleton.currentSaveData_Json["teleport_options"] = _array
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _dictionaty: Dictionary = {}
	_dictionaty["room"] = room_test.room_id
	_dictionaty["savespot"] = _savespot
	_array.append(_dictionaty)
	#-------------------------------------------------------------------------------
	sort_by_name_ascending(_array)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json["teleport_options"] = _array
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func sort_by_name_ascending(_array: Array):
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		for _j in range(_i+1, _array.size()):
			#-------------------------------------------------------------------------------
			if(_array[_i]["room"] > _array[_j]["room"]):
				var _a: Dictionary = _array[_i]
				_array[_i] = _array[_j]
				_array[_j] = _a
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SaveMenu_Close():
	pause_menu_panel.hide()
	savespot_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	await get_tree().physics_frame
	PauseOff()
#-------------------------------------------------------------------------------
func SaveMenu_SaveButton_Submit(_s:String):
	singleton.currentSaveData_Json.set("key_dictionary", key_dictionary)
	#-------------------------------------------------------------------------------
	Save_SaveSpot(_s)
	Save_Items()
	Save_KeyItems()
	Save_Equip()
	Save_Friends()
	#-------------------------------------------------------------------------------
	singleton.SaveCurrent_SaveData_Json()
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func SaveMenu_TeleportButton_Submit():
	savespot_menu.hide()
	teleporty_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		Destroy_All_Items(teleporty_menu_button_array)
		savespot_menu.show()
		teleporty_menu.hide()
		singleton.Common_Canceled()
		singleton.Move_to_Button(savespot_menu_button_array[1])
	#-------------------------------------------------------------------------------
	singleton.Set_TabBar(teleporty_menu.get_tab_bar(),func():TeleportMenu_No_Description(), _cancel)
	#-------------------------------------------------------------------------------
	var _array: Array = singleton.currentSaveData_Json.get("teleport_options", [])
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		_button.theme = ui_theme
		_button.text = "  "+_array[_i].get("room", "")+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		teleporty_menu_content.add_child(_button)
		teleporty_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _selected: Callable = TeleportMenu_TeleportButton_Select(_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, _selected, func():TeleportMenu_TeleportButton_Submit(_array[_i]), _cancel)
	#-------------------------------------------------------------------------------
	var _tabbar: TabBar = teleporty_menu.get_tab_bar()
	#-------------------------------------------------------------------------------
	if(teleporty_menu_button_array.size() > 0):
		singleton.Move_to_Button(teleporty_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_tabbar)
	#-------------------------------------------------------------------------------
	_tabbar.set_tab_disabled(0, false)
	_tabbar.current_tab = 0
	teleporty_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func TeleportMenu_TeleportButton_Select(_dictionary:Dictionary) -> Callable:
	var _selected: Callable
	#-------------------------------------------------------------------------------
	match(_dictionary.get("room", "")):
		"room_test_01":
			#-------------------------------------------------------------------------------
			_selected = func():
				teleporty_menu_rect.show()
				teleporty_menu_rect.texture = load("res://Assets/room_previews/room_test_01.jpg")
				teleporty_menu_description.text = "* Its a little buggi zone, some enemies com back to life when i leave the rooms."
				singleton.Common_Selected()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		"room_test_05":
			#-------------------------------------------------------------------------------
			_selected = func():
				teleporty_menu_rect.show()
				teleporty_menu_rect.texture = load("res://Assets/room_previews/room_test_05.jpg")
				teleporty_menu_description.text = "* This plase is where some windows stars to appear, mayby it's a residential zone."
				singleton.Common_Selected()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		_:
			#-------------------------------------------------------------------------------
			_selected = func():
				TeleportMenu_No_Description()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _selected
#-------------------------------------------------------------------------------
func TeleportMenu_TeleportButton_Submit(_dictionary:Dictionary):
	var _new_room: Room_Script = load(Get_Room_Path(_dictionary["room"])).instantiate() as Room_Script
	_new_room.room_id = _dictionary.get("room", "")
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		PlayAnimation(friend_party[_i].playback, "Idle")
		friend_party[_i].is_Moving = false
		var _warp_array: Array[Node] = _new_room.find_children(_dictionary["savespot"], "Interactable_Script")
		#-------------------------------------------------------------------------------
		if(_i > 0):
			friend_party[_i].position = _warp_array[0].position
		#-------------------------------------------------------------------------------
		else:
			player_characterbody2d.position = _warp_array[0].position
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	call_deferred("add_child", _new_room)
	#-------------------------------------------------------------------------------
	room_test.queue_free()							#Importante: Cuidado con el Orden
	room_test = _new_room							#Importante: Cuidado con el Orden
	_new_room.Set_Room(self)						#Importante: Cuidado con el Orden
	camera.position = Camera_Set_Target_Position()	#Importante: Cuidado con el Orden
	#-------------------------------------------------------------------------------
	teleporty_menu.hide()
	singleton.Play_BGM(singleton.stage1)
	pause_menu_panel.hide()
	PauseOff()
	Destroy_All_Items(teleporty_menu_button_array)
#-------------------------------------------------------------------------------
func Save_SaveSpot(_s:String):
	var _dictionaty: Dictionary = {}
	_dictionaty["room"] = room_test.room_id
	_dictionaty["savespot"] = _s
	singleton.currentSaveData_Json.set("current_savespot", _dictionaty)
#-------------------------------------------------------------------------------
func Save_Items():
	var _array: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in item_array.size():
		var _dictionary: Dictionary = item_array[_i].SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("item_array", _array)
#-------------------------------------------------------------------------------
func Save_KeyItems():
	var _array: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in key_item_array.size():
		var _dictionary: Dictionary = key_item_array[_i].SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("key_item_array", _array)
#-------------------------------------------------------------------------------
func Save_Equip():
	var _array: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		var _dictionary: Dictionary = equip_array[_i].SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("equip_array", _array)
#-------------------------------------------------------------------------------
func Save_Friends():
	var _array: Array[Dictionary] = []
	for _i in friend_party.size():
		var _dictionary: Dictionary = friend_party[_i].SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("friend_party", _array)
#-------------------------------------------------------------------------------
func Get_Item_Script_ID(_node:Node) -> String:
	var _s: String = room_test.room_id+"_"+_node.name
	return _s
#-------------------------------------------------------------------------------
func Teleport_From_1_Room_to_Another(_room_name:String, _warp_name:String):
	#var _new_room: Room_Script = next_room_prefab.instantiate() as Room_Script
	var _new_room: Room_Script = load(Get_Room_Path(_room_name)).instantiate() as Room_Script
	_new_room.room_id = _room_name
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		PlayAnimation(friend_party[_i].playback, "Idle")
		friend_party[_i].is_Moving = false
		var _warp_array: Array[Node] = _new_room.find_children(_warp_name, "Interactable_Script")
		#-------------------------------------------------------------------------------
		if(_i > 0):
			friend_party[_i].position = _warp_array[0].position
		#-------------------------------------------------------------------------------
		else:
			player_characterbody2d.position = _warp_array[0].position
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	call_deferred("add_child", _new_room)
	#-------------------------------------------------------------------------------
	room_test.queue_free()							#Importante: Cuidado con el Orden
	room_test = _new_room							#Importante: Cuidado con el Orden
	_new_room.Set_Room(self)						#Importante: Cuidado con el Orden
	camera.position = Camera_Set_Target_Position()	#Importante: Cuidado con el Orden
#-------------------------------------------------------------------------------
func Get_Room_Path(_room_name:String) -> String:
	return "res://Nodes/Prefabs/Rooms/"+_room_name+".tscn"
#-------------------------------------------------------------------------------
func Load_Room_and_SaveSpot():
	var _dictionaty: Dictionary = singleton.currentSaveData_Json.get("current_savespot", {})
	var _room_name: String = _dictionaty.get("room", "")
	var _room_savespot_name: String = _dictionaty.get("savespot", "")
	var _path: String = Get_Room_Path(_room_name)
	#-------------------------------------------------------------------------------
	if(ResourceLoader.exists(_path)):
		Load_Keys_Dictionary()
		Load_Items()
		Load_KeyItems()
		Load_Equip()
		Load_FriendsParty()
		#-------------------------------------------------------------------------------
		var _new_room: Room_Script = load(Get_Room_Path(_room_name)).instantiate() as Room_Script
		call_deferred("add_child", _new_room)
		room_test.queue_free()
		room_test = _new_room
		#-------------------------------------------------------------------------------
		room_test.room_id = _room_name
		var _interactable_array: Array[Node] = _new_room.find_children(_room_savespot_name, "Interactable_Script")
		#-------------------------------------------------------------------------------
		if(_interactable_array.size() > 0):
			player_characterbody2d.global_position = _interactable_array[0].global_position
			#-------------------------------------------------------------------------------
			for _i in range(1, friend_party.size()):
				friend_party[_i].global_position = _interactable_array[0].global_position
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		room_test.room_id = room_test.name
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_Keys_Dictionary():
	key_dictionary.clear()
	#-------------------------------------------------------------------------------
	var _key_dictionary: Dictionary = singleton.currentSaveData_Json.get("key_dictionary", {})
	#-------------------------------------------------------------------------------
	for _i in _key_dictionary.size():
		key_dictionary[String(_key_dictionary.keys()[_i])] = int(_key_dictionary.values()[_i])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_Items():
	item_array.clear()
	#-------------------------------------------------------------------------------
	var _item_data: Array = singleton.currentSaveData_Json.get("item_array", [])
	#-------------------------------------------------------------------------------
	for _i in _item_data.size():
		var _item_serializable: Item_Serializable = Item_Serializable.new()
		_item_serializable.LoadData_Constructor(_item_data[_i])
		item_array.append(_item_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_KeyItems():
	key_item_array.clear()
	#-------------------------------------------------------------------------------
	var _keyitem_data: Array = singleton.currentSaveData_Json.get("key_item_array", [])
	#-------------------------------------------------------------------------------
	for _i in _keyitem_data.size():
		var _keyitem_serializable: Key_Item_Serializable = Key_Item_Serializable.new()
		_keyitem_serializable.LoadData_Constructor(_keyitem_data[_i])
		key_item_array.append(_keyitem_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_Equip():
	equip_array.clear()
	#-------------------------------------------------------------------------------
	var _equip_data: Array = singleton.currentSaveData_Json.get("equip_array", [])
	#-------------------------------------------------------------------------------
	for _i in _equip_data.size():
		var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
		_equip_serializable.LoadData_Constructor(_equip_data[_i])
		equip_array.append(_equip_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_FriendsParty():
	var _friend_data: Array = singleton.currentSaveData_Json.get("friend_party", [])
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].LoadData_Constructor(_friend_data[_i])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Wait_for_Player():
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE == BATTLE_STATE.STILL_FIGHTING):
		await dialogue_signal
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
