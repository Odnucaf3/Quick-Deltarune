extends Node
class_name Game_Scene
#-------------------------------------------------------------------------------
enum GAME_STATE{IN_WORLD, IN_MENU, IN_BATTLE}
#-------------------------------------------------------------------------------
#region VARIABLES
@export var world2d: Node2D
@export var ui_theme: Theme
@export var room_test: Room_Script
#-------------------------------------------------------------------------------
@export var bool_dictionary: Dictionary[String, bool]
#-------------------------------------------------------------------------------
@export var audioStreamPlayer_select: AudioStreamPlayer
@export var audioStreamPlayer_submit: AudioStreamPlayer
@export var audioStreamPlayer_cancel: AudioStreamPlayer
#-------------------------------------------------------------------------------
@export var dialogue_menu: Control
@export var dialogue_menu_label: Label
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
@export var item_menu_consumable_lore: Label
@export var item_menu_consumable_description: Label
#-------------------------------------------------------------------------------
@export var item_menu_equipment_scrollContainer: ScrollContainer
@export var item_menu_equipment_content: VBoxContainer
var item_menu_equipment_button_array: Array[Button]
@export var item_menu_equipment_title: Label
@export var item_menu_equipment_lore: Label
@export var item_menu_equipment_description: Label
#-------------------------------------------------------------------------------
@export var item_menu_keyitems_scrollContainer: ScrollContainer
@export var item_menu_keyitems_content: VBoxContainer
var item_menu_keyitems_button_array: Array[Button]
@export var item_menu_keyitems_title: Label
@export var item_menu_keyitems_lore: Label
@export var item_menu_keyitems_description: Label
#-------------------------------------------------------------------------------
@export var item_array: Array[Item_Resource]
@export var key_item_array: Array[Key_Item_Resource]
var item_array_in_battle: Array[Item_Resource]
@export var iten_resource_attack: Item_Resource
@export var iten_resource_defense: Item_Resource
#-------------------------------------------------------------------------------
@export var skill_menu: TabContainer
#-------------------------------------------------------------------------------
@export var skill_menu_scrollContainer: ScrollContainer
@export var skill_menu_content: VBoxContainer
var skill_menu_button_array: Array[Button]
@export var skill_menu_title: Label
@export var skill_menu_lore: Label
@export var skill_menu_description: Label
#-------------------------------------------------------------------------------
@export var equip_menu: TabContainer
@export var equip_menu_scrollContainer: ScrollContainer
@export var equip_menu_content: VBoxContainer
var equip_menu_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export var equipslot_menu: TabContainer
@export var equipslot_menu_content: VBoxContainer
var equipslot_menu_button_array: Array[Button]
@export var equip_array: Array[Equip_Resource]
#-------------------------------------------------------------------------------
@export var status_menu: TabContainer
@export var status_menu_content: VBoxContainer
@export var status_menu_stats_button_array: Array[Button]
var status_menu_statuseffect_button_array: Array[Button]
@export var status_menu_image: TextureRect
#-------------------------------------------------------------------------------
var camera_offset_y: float = 40
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
var clearbattle_callable: Callable = func(): pass
#endregion
#-------------------------------------------------------------------------------
#region MONOBEHAVIOUR
func _ready() -> void:
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].playback = friend_party[_i].animation_tree.get("parameters/playback")
		PlayAnimation(friend_party[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = ally_ui_prefab.instantiate() as Party_Member_UI
		friend_party[_i].party_member_ui = _party_member_ui
		friend_party[_i].party_member_ui.hide()
		friend_party[_i].party_member_ui.button_pivot.hide()
		#friend_party[_i].party_member_ui.label_sp.hide()
		#friend_party[_i].party_member_ui.bar_sp.hide()
		battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
	win_label.hide()
	retry_menu.hide()
	battle_menu.hide()
	item_menu.hide()
	skill_menu.hide()
	equipslot_menu.hide()
	equip_menu.hide()
	status_menu.hide()
	battle_box.hide()
	timer_label.hide()
	battle_black_panel.hide()
	dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	var _width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var _height: float = ProjectSettings.get_setting("display/window/size/viewport_height")
	viewport_size = Vector2(_width, _height)
	viewport_center = viewport_size/2.0
	camera_size = viewport_size / camera.zoom
	camera_center = viewport_center / camera.zoom
	#-------------------------------------------------------------------------------
	room_test.game_scene = self
	room_test.Set_Room()
	camera.position = Camera_Set_Target_Position()
	#-------------------------------------------------------------------------------
	hitbox.global_scale = Get_CircleSprite_Scale(hitBox_radius) + Vector2(0.01, 0.01)
	grazebox.global_scale = Get_CircleSprite_Scale(grazeBox_radius) + Vector2(0.01, 0.01)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(item_menu_consumable_content)
	Destroy_Childrens(item_menu_equipment_content)
	Destroy_Childrens(item_menu_keyitems_content)
	Destroy_Childrens(skill_menu_content)
	Destroy_Childrens(equipslot_menu_content)
	Destroy_Childrens(equip_menu_content)
	Destroy_Childrens(status_menu_content)
	#-------------------------------------------------------------------------------
	Create_EnemyBullets_Disabled(2000)
	PauseOff()
	NormalMotion()
	#-------------------------------------------------------------------------------
	SetParty_Skills()
	SetParty_Items()
	SetParty_KeyItems()
	SerParty_Equip()
	SetParty_Status()
	#-------------------------------------------------------------------------------
	PauseMenu_Set()
#-------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	Debug_Information()
	Show_fps()
	#-------------------------------------------------------------------------------
	Set_FullScreen()
	Set_Vsync()
	Set_SlowMotion()
	Set_MouseMode()
	Set_ResetGame()
#-------------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	tween_Array = get_tree().get_processed_tweens()
	#-------------------------------------------------------------------------------
	match(myGAME_STATE):
		GAME_STATE.IN_WORLD:
			Input_PauseGame()
			#-------------------------------------------------------------------------------
			if(!get_tree().paused):
				Player_Movement()
				Followers_Movement()
				Camera_Follow()
				#-------------------------------------------------------------------------------
				if(Input.is_action_just_pressed("ui_accept")):
					var _interactable_array : Array[Area2D] = player_interactable_area2d.get_overlapping_areas()
					#-------------------------------------------------------------------------------
					if(_interactable_array.size() > 0):
						var _interactable_item: Item_Script = _interactable_array[0]
						PickUp_Item(_interactable_item)
					#-------------------------------------------------------------------------------
				#-------------------------------------------------------------------------------
				if(can_enter_fight):
					var _enemy_detector_array : Array[Area2D] = player_enemyDetector_area2d.get_overlapping_areas()
					#-------------------------------------------------------------------------------
					if(_enemy_detector_array.size() > 0):
						var _enemy_detector: Enemy_Chaser = _enemy_detector_array[0].get_parent()
						_enemy_detector.Enter_Battle(self)
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
#region READY FUNCTIONS
#-------------------------------------------------------------------------------
func SetParty_Skills():
	Set_Skill2(iten_resource_attack)
	Set_Skill2(iten_resource_defense)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].skill_array.size():
			Set_Skill(friend_party[_i].skill_array, _j)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Skill(_item_resource_array:Array[Item_Resource], _index:int):
	_item_resource_array[_index].id = get_resource_filename(_item_resource_array[_index])
	_item_resource_array[_index] = _item_resource_array[_index].Constructor()
	_item_resource_array[_index].hold = _item_resource_array[_index].max_hold
#-------------------------------------------------------------------------------
func Set_Skill2(_item_resource:Item_Resource):
	_item_resource.id = get_resource_filename(_item_resource)
#-------------------------------------------------------------------------------
func SetParty_Items():
	#-------------------------------------------------------------------------------
	for _i in item_array.size():
		item_array[_i].id = get_resource_filename(item_array[_i])
		item_array[_i] = item_array[_i].Constructor()
		item_array[_i].hold = item_array[_i].max_hold
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SetParty_KeyItems():
	#-------------------------------------------------------------------------------
	for _i in key_item_array.size():
		key_item_array[_i].id = get_resource_filename(key_item_array[_i])
		key_item_array[_i] = key_item_array[_i].Constructor()
		key_item_array[_i].hold = 1
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SerParty_Equip():
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		equip_array[_i].id = get_resource_filename(equip_array[_i])
		equip_array[_i] = equip_array[_i].Constructor()
		equip_array[_i].hold = 1
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SetParty_Status():
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].status_array.size():
			Set_Status(friend_party[_i].status_array, _j)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Status(_status_resource_array:Array[Status_Resource], _index:int):
	_status_resource_array[_index].id = get_resource_filename(_status_resource_array[_index])
	_status_resource_array[_index] = _status_resource_array[_index].Constructor()
	_status_resource_array[_index].hold = 1
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region IN_WORLD FUNCTIONS
func Player_Movement():
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
			myPosition += _input_dir * 1.0 * deltaTimeScale * deltaTimeScale
		#-------------------------------------------------------------------------------
		else:
			myPosition += _input_dir * 2.0 * deltaTimeScale * deltaTimeScale
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
	_item_script.queue_free()
	bool_dictionary.set(room_test.Get_Item_Script_ID(_item_script), true)
	#-------------------------------------------------------------------------------
	var _item_id: String = get_resource_filename(_item_script.pickable_item)
	for _i in item_array.size():
		#-------------------------------------------------------------------------------
		if(item_array[_i].id == _item_id):
			item_array[_i].hold += 1
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _new_item: Item_Resource = _item_script.pickable_item.Constructor()
	_new_item.id = _item_id
	_new_item.hold = 1
	item_array.append(_new_item)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SET BATTLEFIELD
#-------------------------------------------------------------------------------
func EnterBattle():
	myGAME_STATE = GAME_STATE.IN_MENU
	#-------------------------------------------------------------------------------
	var _center: Vector2 = camera.position
	#-------------------------------------------------------------------------------
	var _top_limit: float = 0.45
	var _botton_limit: float = 1.15
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
	#-------------------------------------------------------------------------------
	battle_black_panel.global_position = _center-battle_black_panel.size/2.0
	battle_black_panel.show()
	#-------------------------------------------------------------------------------
	item_array_in_battle.clear()
	for _i in item_array.size():
		item_array_in_battle.append(item_array[_i].Constructor())
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_interval(0.5)
	_tween.tween_interval(0.5)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		var _y_pos: float = -camera_size.y*_top_limit + camera_size.y*_botton_limit* (float(_i+1)/(friend_party.size()+1))
		var _x_pos: float = -camera_size.x*0.3
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		friend_party[_i].party_member_ui.global_position = (camera_center + Vector2(_x_pos, _y_pos))*camera.zoom
		_tween.parallel().tween_property(friend_party[_i], "global_position", _position, 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _y_pos: float = -camera_size.y*_top_limit + camera_size.y*_botton_limit* (float(_i+1)/(enemy_party.size()+1))
		var _x_pos: float = camera_size.x*0.3
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		enemy_party[_i].party_member_ui.global_position = (camera_center + Vector2(_x_pos, _y_pos))*camera.zoom
		_tween.parallel().tween_property(enemy_party[_i], "global_position", _position, 0.5)
	#-------------------------------------------------------------------------------
	battle_menu.global_position = friend_party[current_player_turn].party_member_ui.button_pivot.global_position
	_tween.tween_interval(0.5)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		battle_menu.show()
		Move_to_Button(battle_menu_button[0])
		battle_box.position = camera.position - battle_box.size/2.0
		Set_Button(battle_menu_button[0],func():Common_Selected() , func():BattleMenu_AttackButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		Set_Button(battle_menu_button[1],func():Common_Selected() , func():BattleMenu_DefenseButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		Set_Button(battle_menu_button[2],func():Common_Selected() , func():BattleMenu_SkillButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		Set_Button(battle_menu_button[3],func():Common_Selected() , func():BattleMenu_ItemButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		Set_Button(battle_menu_button[4],func():Common_Selected() , func():BattleMenu_EquipButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		Set_Button(battle_menu_button[5],func():Common_Selected() , func():BattleMenu_StatusButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		#-------------------------------------------------------------------------------
		friend_party_alive.clear()
		friend_party_dead.clear()
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			#-------------------------------------------------------------------------------
			friend_party[_i].skill_array_in_battle.clear()
			for _j in friend_party[_i].skill_array.size():
				friend_party[_i].skill_array_in_battle.append(friend_party[_i].skill_array[_j].Constructor())
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
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region BATTLE_MENU FUNCTIONS
#-------------------------------------------------------------------------------
func BattleMenu_AttackButton_Submit():
	Common_Submit()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		TargetMenu_TargetButton_Cancel()
		battle_menu.show()
		Move_to_Button(battle_menu_button[0])
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(iten_resource_attack, battle_menu, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_DefenseButton_Submit():
	Common_Submit()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		TargetMenu_TargetButton_Cancel()
		battle_menu.show()
		Move_to_Button(battle_menu_button[1])
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(iten_resource_defense, battle_menu, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_SkillButton_Submit():
	battle_menu.hide()
	skill_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(skill_menu.get_tab_bar(),func():No_Description(), func():SkillMenu_SkillButton_Cancel())
	#-------------------------------------------------------------------------------
	for _i in friend_party_alive[current_player_turn].skill_array_in_battle.size():
		#-------------------------------------------------------------------------------
		var _item_resource: Item_Resource = friend_party_alive[current_player_turn].skill_array_in_battle[_i]
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		_button.theme = ui_theme
		_button.text = "  "+_item_resource.id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		skill_menu_content.add_child(_button)
		skill_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "  ("+str(_item_resource.sp_cost)+" SP)  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			skill_menu.show()
			Move_to_Button(skill_menu_button_array[_i])
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():SkillMenu_SkillButton_Selected(_item_resource), func(): SkillMenu_SkillButton_Submit(_item_resource, _cancel), func():SkillMenu_SkillButton_Cancel())
	#-------------------------------------------------------------------------------
	if(skill_menu_button_array.size() > 0):
		Move_to_Button(skill_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		Move_to_Button(skill_menu.get_tab_bar())
	#-------------------------------------------------------------------------------
	skill_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func BattleMenu_ItemButton_Submit():
	battle_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(item_menu.get_tab_bar(),func():No_Description(), func():ItemMenu_ItemButton_Cancel())
	#-------------------------------------------------------------------------------
	for _i in item_array_in_battle.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		var _hold: int = item_array_in_battle[_i].hold
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(item_array_in_battle[_i] == (friend_party[_j].item_resource)):
				_hold -= 1
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+item_array_in_battle[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_consumable_content.add_child(_button)
		item_menu_consumable_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "  ("+str(_hold)+" / "+str(item_array_in_battle[_i].max_hold)+")  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			Move_to_Button(item_menu_consumable_button_array[_i])
		#-------------------------------------------------------------------------------
		if(_hold > 0):
			Set_Button(_button, func():ItemMenu_ItemButton_Selected(item_array_in_battle[_i]), func():ItemMenu_ItemButton_Submit(item_array_in_battle[_i], _cancel), func():ItemMenu_ItemButton_Cancel())
		#-------------------------------------------------------------------------------
		else:
			Set_Button(_button, func():ItemMenu_ItemButton_Selected(item_array_in_battle[_i]), func():pass, func():ItemMenu_ItemButton_Cancel())
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+equip_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_equipment_content.add_child(_button)
		item_menu_equipment_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(equip_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():pass, func():ItemMenu_ItemButton_Cancel())
	#-------------------------------------------------------------------------------
	for _i in key_item_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+key_item_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_keyitems_content.add_child(_button)
		item_menu_keyitems_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(key_item_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():pass, func():ItemMenu_ItemButton_Cancel())
	#-------------------------------------------------------------------------------
	if(item_menu_consumable_button_array.size() > 0):
		Move_to_Button(item_menu_consumable_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		Move_to_Button(item_menu.get_tab_bar())
	#-------------------------------------------------------------------------------
	item_menu.current_tab = 0
	item_menu_consumable_scrollContainer.scroll_vertical = 0
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_Submit():
	equipslot_menu.show()
	battle_menu.hide()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(equipslot_menu.get_tab_bar(), func():Common_Selected(), func():BattleMenu_EquipButton_EquipSlot_Cancel())
	#-------------------------------------------------------------------------------
	for _i in friend_party_alive[current_player_turn].equip_array.size():
		var _button:Button = Button.new()
		_button.theme = ui_theme
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		#-------------------------------------------------------------------------------
		var _equip_resource: Equip_Resource = friend_party_alive[current_player_turn].equip_array[_i]
		#-------------------------------------------------------------------------------
		if(_equip_resource == null):
			_button.text = "  [Empty]  "
		#-------------------------------------------------------------------------------
		else:
			_button.text = _equip_resource.id
		#-------------------------------------------------------------------------------
		equipslot_menu_button_array.append(_button)
		equipslot_menu_content.add_child(_button)
		#-------------------------------------------------------------------------------
		Set_Button(equipslot_menu_button_array[_i], func():Common_Selected(), func():BattleMenu_EquipButton_EquipSlot_Submit(friend_party_alive[current_player_turn], _i), func():BattleMenu_EquipButton_EquipSlot_Cancel())
	#-------------------------------------------------------------------------------
	if(equipslot_menu_button_array.size() > 0):
		Move_to_Button(equipslot_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		Move_to_Button(equipslot_menu.get_tab_bar())
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_Submit(_user:Party_Member,_index:int):
	equipslot_menu.hide()
	equip_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(equip_menu.get_tab_bar(), func():Common_Selected(), func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	var _empty_button: Button = Button.new()
	_empty_button.theme = ui_theme
	_empty_button.text = "  [Empty]  "
	_empty_button.add_theme_font_size_override("font_size", 24)
	_empty_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	equip_menu_content.add_child(_empty_button)
	equip_menu_button_array.append(_empty_button)
	Set_Button(_empty_button, func():Common_Selected(), func():pass, func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+equip_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		equip_menu_content.add_child(_button)
		equip_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(equip_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			equip_menu.show()
			Move_to_Button(equip_menu_button_array[_i])
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():pass, func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	Move_to_Button(equip_menu_button_array[0])
	#-------------------------------------------------------------------------------
	equip_menu.current_tab = 0
	equip_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_Cancel():
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(equipslot_menu_button_array)
	equipslot_menu.hide()
	battle_menu.show()
	Move_to_Button(battle_menu_button[4])
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index:int):
	Common_Cancel()
	#-------------------------------------------------------------------------------
	equipslot_menu.show()
	equip_menu.hide()
	Move_to_Button(equipslot_menu_button_array[_index])
	Destroy_All_Items(equip_menu_button_array)
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_Submit():
	battle_menu.hide()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		Set_Button(friend_party[_i].party_member_ui.button, func():Common_Selected(), func():BattleMenu_StatusButton_TargetButton_Submit(friend_party[_i]), func():BattleMenu_StatusButton_TargetButton_Cancel())
		friend_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		Set_Button(enemy_party[_i].party_member_ui.button, func():Common_Selected(), func():BattleMenu_StatusButton_TargetButton_Submit(enemy_party[_i]), func():BattleMenu_StatusButton_TargetButton_Cancel())
		enemy_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	Move_to_Button(friend_party[0].party_member_ui.button)
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_Submit(_user:Party_Member):
	status_menu.show()
	Show_Status_Data(_user)
	status_menu.current_tab = 0
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	Set_TabBar(status_menu.get_tab_bar(), func():Common_Selected(), func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user))
	#-------------------------------------------------------------------------------
	for _i in status_menu_stats_button_array.size():
		Set_Button(status_menu_stats_button_array[_i], func():Common_Selected(), func():pass, func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user))
	#-------------------------------------------------------------------------------
	for _i in _user.status_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+_user.status_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		status_menu_content.add_child(_button)
		status_menu_statuseffect_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(_user.status_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			equip_menu.show()
			Move_to_Button(status_menu_statuseffect_button_array[_i])
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():pass, func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user))
	#-------------------------------------------------------------------------------
	Move_to_Button(status_menu.get_tab_bar())
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user:Party_Member):
	status_menu.hide()
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(status_menu_statuseffect_button_array)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	Move_to_Button(_user.party_member_ui.button)
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_Cancel():
	battle_menu.show()
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	Move_to_Button(battle_menu_button[5])
#-------------------------------------------------------------------------------
func BattleMenu_AnyButton_Cancel():
	Common_Cancel()
	#-------------------------------------------------------------------------------
	current_player_turn -= 1
	#-------------------------------------------------------------------------------
	if(current_player_turn < 0):
		current_player_turn = 0
		battle_menu.hide()
		win_label.text = "Escape?"
		win_label.show()
		retry_menu.show()
		Move_to_Button(retry_menu_button[0])
		Set_Button(retry_menu_button[0], func():Common_Selected(), func():RetryMenu_RetryButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		Set_Button(retry_menu_button[1], func():Common_Selected(), func():RetryMenu_EscapeButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		Set_Button(retry_menu_button[2], func():Common_Selected(), func():RetryMenu_ReturnToSavePointButton_Submit(), func():RetryMenu_AnyButton_Cancel())
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
		Move_to_Button(battle_menu_button[0])
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SKILL MENU FUNCTIONS
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Selected(_item_resource:Item_Resource):
	skill_menu_lore.text = _item_resource.lore
	skill_menu_description.text = _item_resource.description
	Common_Selected()
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Submit(_item_resource:Item_Resource, _cancel:Callable):
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	if(friend_party[current_player_turn].sp >= _item_resource.sp_cost):
		TargetMenu_Enter(_item_resource, skill_menu, _cancel)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Cancel():
	skill_menu.hide()
	battle_menu.show()
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(battle_menu_button[2])
	Destroy_All_Items(skill_menu_button_array)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ITEM MENU FUNCTIONS
#-------------------------------------------------------------------------------
func ItemMenu_ItemButton_Selected(_item_resource:Item_Resource):
	item_menu_consumable_lore.text = _item_resource.lore
	item_menu_consumable_description.text = _item_resource.description
	Common_Selected()
#-------------------------------------------------------------------------------
func ItemMenu_ItemButton_Submit(_item_resource:Item_Resource, _cancel:Callable):
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(_item_resource, item_menu, _cancel)
#-------------------------------------------------------------------------------
func ItemMenu_ItemButton_Cancel():
	item_menu.hide()
	battle_menu.show()
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(battle_menu_button[3])
	#-------------------------------------------------------------------------------
	Destroy_All_Items(item_menu_consumable_button_array)
	Destroy_All_Items(item_menu_equipment_button_array)
	Destroy_All_Items(item_menu_keyitems_button_array)
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
func TargetMenu_Enter(_item_resource:Item_Resource, _last_menu:Control, _cancel:Callable):	
	#-------------------------------------------------------------------------------
	match(_item_resource.myTARGET_TYPE):
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ENEMY_1:
			#-------------------------------------------------------------------------------
			if(enemy_party_alive.size() > 0):
				_last_menu.hide()
				#-------------------------------------------------------------------------------
				for _i in enemy_party_alive.size():
					enemy_party_alive[_i].party_member_ui.button_pivot.show()
					Set_Button(enemy_party_alive[_i].party_member_ui.button, func():Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_alive, enemy_party_alive[_i], enemy_party_alive, _item_resource), _cancel)
				#-------------------------------------------------------------------------------
				Move_to_Button(enemy_party_alive[0].party_member_ui.button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ALLY_1:
			#-------------------------------------------------------------------------------
			if(friend_party_alive.size() > 0):
				_last_menu.hide()
				#-------------------------------------------------------------------------------
				for _i in friend_party_alive.size():
					friend_party_alive[_i].party_member_ui.button_pivot.show()
					Set_Button(friend_party_alive[_i].party_member_ui.button, func():Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_alive, friend_party_alive[_i], friend_party_alive, _item_resource), _cancel)
				#-------------------------------------------------------------------------------
				Move_to_Button(friend_party_alive[0].party_member_ui.button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ALLY_DEATH:
			#-------------------------------------------------------------------------------
			if(friend_party_dead.size() > 0):
				_last_menu.hide()
				#-------------------------------------------------------------------------------
				for _i in friend_party_dead.size():
					friend_party_dead[_i].party_member_ui.button_pivot.show()
					Set_Button(friend_party_dead[_i].party_member_ui.button, func():Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_dead, friend_party_dead[_i], friend_party_dead, _item_resource), _cancel)
				#-------------------------------------------------------------------------------
				Move_to_Button(friend_party_dead[0].party_member_ui.button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.USER:
			_last_menu.hide()
			#-------------------------------------------------------------------------------
			friend_party_alive[current_player_turn].party_member_ui.button_pivot.show()
			Set_Button(friend_party_alive[current_player_turn].party_member_ui.button, func():Common_Selected(), func():TargetMenu_TargetButton_Submit(friend_party_alive, friend_party_alive[current_player_turn], friend_party_alive, _item_resource), _cancel)
			#-------------------------------------------------------------------------------
			Move_to_Button(friend_party_alive[current_player_turn].party_member_ui.button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Submit(_user_party:Array[Party_Member], _target:Party_Member, _target_party:Array[Party_Member], _item_resource:Item_Resource):
	Common_Submit()
	#-------------------------------------------------------------------------------
	friend_party_alive[current_player_turn].user_party = _user_party
	friend_party_alive[current_player_turn].target = _target
	friend_party_alive[current_player_turn].target_party = _target_party
	friend_party_alive[current_player_turn].item_resource = _item_resource
	#-------------------------------------------------------------------------------
	PlayAnimation(friend_party_alive[current_player_turn].playback, _item_resource.anim)
	Destroy_All_Items(item_menu_consumable_button_array)
	Destroy_All_Items(item_menu_equipment_button_array)
	Destroy_All_Items(item_menu_keyitems_button_array)
	Destroy_All_Items(skill_menu_button_array)
	After_Choose_Target_Logic()
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Cancel():
	friend_party_alive[current_player_turn].user_party = []
	friend_party_alive[current_player_turn].target = null
	friend_party_alive[current_player_turn].target_party = []
	friend_party_alive[current_player_turn].item_resource = null
	#-------------------------------------------------------------------------------
	Common_Cancel()
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
		Move_to_Button(battle_menu_button[0])
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
	await Seconds(0.3)
	#-------------------------------------------------------------------------------
	var _player_alive_attacking: Array[Party_Member] = []
	var _player_alive_defending: Array[Party_Member] = []
	var _player_alive_using_skill_or_item: Array[Party_Member] = []
	#-------------------------------------------------------------------------------
	for _i in friend_party_alive.size():
		match(friend_party_alive[_i].item_resource):
			iten_resource_attack:
				_player_alive_attacking.append(friend_party_alive[_i])
			iten_resource_defense:
				_player_alive_defending.append(friend_party_alive[_i])
			_:
				_player_alive_using_skill_or_item.append(friend_party_alive[_i])
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
			dialogue_menu_label.text = _user.id + " uses " + _user.item_resource.id + " on " + _user.target.id
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
	friend_party_alive.clear()
	friend_party_dead.clear()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		if(friend_party[_i].hp > 0):
			friend_party_alive.append(friend_party[_i])
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
		if(enemy_party[_i].hp > 0):
			enemy_party_alive.append(enemy_party[_i])
			PlayAnimation(enemy_party[_i].playback, "Idle")
		else:
			enemy_party_dead.append(enemy_party[_i])
	#-------------------------------------------------------------------------------
	if(enemy_party_alive.size() > 0):
		if(friend_party_alive.size() > 0):
			Set_Players_and_Enemies_before_action()
			await Start_BulletHell()
		else:
			You_Lose()
	#-------------------------------------------------------------------------------
	else:
		You_Win()
	#-------------------------------------------------------------------------------
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
	match(_user.item_resource.myTARGET_TYPE):
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
	_user.item_resource.hold -= 1
	_user.sp -= _user.item_resource.sp_cost
	_user.hp -= _user.item_resource.hp_cost
	Set_HP_Label(_user)
	Set_SP_Label(_user)
	await call(_user.item_resource.action_string, _user)
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
			dialogue_menu_label.text = "Normal Attack Minigame"
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
			dialogue_menu.hide()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Nothing(_user:Party_Member):
	print("The actions Does not exist")
#-------------------------------------------------------------------------------
func Start_BulletHell():
	battle_box.show()
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
	await Seconds(0.5)
	var _tween: Tween = CreateTween_ArrayAppend(main_tween_Array)
	_tween.set_loops()
	Stage1_Fire2(_tween)
	#-------------------------------------------------------------------------------
	await TimeOut_Tween(15)
	myGAME_STATE = GAME_STATE.IN_MENU
	current_player_turn = 0
	#-------------------------------------------------------------------------------
	for _i in range(item_array_in_battle.size()-1, -1, -1):
		#-------------------------------------------------------------------------------
		if(item_array_in_battle[_i].hold <= 0):
			item_array_in_battle.remove_at(_i)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	friend_party_alive.clear()
	friend_party_dead.clear()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
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
		if(friend_party_alive.size() > 0):
			battle_menu.show()
			battle_box.hide()
			myGAME_STATE = GAME_STATE.IN_MENU
			Move_to_Button(battle_menu_button[current_player_turn])
			battle_menu.global_position = friend_party_alive[current_player_turn].party_member_ui.button_pivot.global_position
		else:
			You_Lose()
	#-------------------------------------------------------------------------------
	else:
		You_Win()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func You_Win():
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.hide()
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.hide()
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	retry_menu.hide()
	win_label.text = "You Win"
	win_label.show()
	#-------------------------------------------------------------------------------
	can_enter_fight = false
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
		myGAME_STATE = GAME_STATE.IN_WORLD
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			friend_party[_i].z_index = 0
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			enemy_party[_i].z_index = 0
		#-------------------------------------------------------------------------------
		battle_black_panel.hide()
		await clearbattle_callable.call()
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region RETRY MENU FUNCTIONS
#-------------------------------------------------------------------------------
func RetryMenu_RetryButton_Submit():
	Common_Submit()
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	black_panel.self_modulate = Color.TRANSPARENT
	_tween.tween_property(black_panel, "self_modulate", Color.BLACK, 0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		retry_menu.hide()
		win_label.hide()
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
			for _j in friend_party[_i].skill_array.size():
				friend_party[_i].skill_array_in_battle.append(friend_party[_i].skill_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			PlayAnimation(friend_party[_i].playback, "Idle")
			#-------------------------------------------------------------------------------
			friend_party[_i].hp = friend_party[_i].max_hp
			Set_HP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].sp = 0
			Set_SP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].item_resource = null
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
		Move_to_Button(battle_menu_button[0])
	)
	#-------------------------------------------------------------------------------
	_tween.tween_interval(0.05)
	#-------------------------------------------------------------------------------
	_tween.tween_property(black_panel, "self_modulate", Color.TRANSPARENT, 0.3)
#-------------------------------------------------------------------------------
func RetryMenu_EscapeButton_Submit():
	Common_Submit()
	#-------------------------------------------------------------------------------
	You_Escape()
#-------------------------------------------------------------------------------
func RetryMenu_ReturnToSavePointButton_Submit():
	Common_Submit()
	#-------------------------------------------------------------------------------
	get_tree().reload_current_scene()
#-------------------------------------------------------------------------------
func RetryMenu_AnyButton_Cancel():
	battle_menu.show()
	win_label.hide()
	retry_menu.hide()
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(battle_menu_button[0])
#-------------------------------------------------------------------------------
func You_Escape():
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.hide()
		PlayAnimation(friend_party[_i].playback, "Idle")
		friend_party[_i].z_index = 0
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.hide()
		enemy_party[_i].z_index = 0
	#-------------------------------------------------------------------------------
	win_label.hide()
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
	world2d.add_child(_bullet)
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
func Stage1_Fire2(_tween:Tween):
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
					Bullet_Grazed()
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
			world2d.add_child(_label)
			return _label
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	_user.damage_label_array.append(_label)
	_global_position.y -= 8.0 * float(_user.damage_label_array.size()-1)
	_label.global_position = _global_position
	world2d.add_child(_label)
	return _label
#-------------------------------------------------------------------------------
func You_Lose():
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
		Set_Button(retry_menu_button[0], func():Common_Selected(), func():RetryMenu_RetryButton_Submit(), func():pass)
		Set_Button(retry_menu_button[1], func():Common_Selected(), func():RetryMenu_EscapeButton_Submit(), func():pass)
		Set_Button(retry_menu_button[2], func():Common_Selected(), func():RetryMenu_ReturnToSavePointButton_Submit(), func():pass)
		Move_to_Button(retry_menu_button[0])
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Bullet_Grazed():
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
	_tween.tween_property(_sprite2d, "global_position", _global_position + Vector2(150,0), 0.3)
	_tween.tween_interval(0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		PlayAnimation(_user.playback, "Shot")
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
	HP_Heal_Porcentual(_user.target, 1.0)
	PlayAnimation(_user.target.playback, "Idle")
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
	world2d.add_child(_label)
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
#region COMMON BUTTON FUNCTIONS
func Set_Button(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
	DisconnectButton(_b)
	#-------------------------------------------------------------------------------
	_b.focus_entered.connect(_selected)
	_b.pressed.connect(_submited)
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func DisconnectButton(_b:Button) -> void:
	DisconnectAll(_b.focus_entered)
	DisconnectAll(_b.pressed)
	DisconnectAll(_b.gui_input)
#-------------------------------------------------------------------------------
func Set_TabBar(_tb:TabBar, _selected:Callable, _canceled:Callable) -> void:
	Disconnect_TabBar(_tb)
	_tb.focus_entered.connect(_selected)
	_tb.tab_changed.connect(func(_tab:int):_selected.call())
	#-------------------------------------------------------------------------------
	_tb.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_TabBar(_tb:TabBar) -> void:
	DisconnectAll(_tb.gui_input)
	DisconnectAll(_tb.focus_entered)
	DisconnectAll(_tb.tab_changed)
#-------------------------------------------------------------------------------
func DisconnectAll(_signal:Signal):
	var _dictionaryArray : Array = _signal.get_connections()
	#-------------------------------------------------------------------------------
	for _dictionary in _dictionaryArray:
		_signal.disconnect(_dictionary["callable"])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Move_to_Button(_button):
	_button.grab_focus()
#-------------------------------------------------------------------------------
func Common_Selected():
	audioStreamPlayer_select.play()
#-------------------------------------------------------------------------------
func Common_Submit():
	audioStreamPlayer_submit.play()
#-------------------------------------------------------------------------------
func Common_Cancel():
	audioStreamPlayer_cancel.play()
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
func Set_FullScreen() -> void:
	if(Input.is_action_just_pressed("Debug_FullScreen")):
		var _wm: DisplayServer.WindowMode = DisplayServer.window_get_mode()
		#-------------------------------------------------------------------------------
		if(_wm == DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#-------------------------------------------------------------------------------
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Vsync() -> void:
	#-------------------------------------------------------------------------------
	if(Input.is_action_just_pressed("Debug_Vsync")):
		var _vs: DisplayServer.VSyncMode = DisplayServer.window_get_vsync_mode()
		#-------------------------------------------------------------------------------
		if(_vs == DisplayServer.VSYNC_DISABLED):
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		#-------------------------------------------------------------------------------
		elif(_vs == DisplayServer.VSYNC_ENABLED):
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_MouseMode() -> void:
	#-------------------------------------------------------------------------------
	if(Input.is_action_just_pressed("Debug_Mouse")):
		var _mm: Input.MouseMode = Input.mouse_mode
		if(_mm == Input.MOUSE_MODE_VISIBLE):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#-------------------------------------------------------------------------------
		elif(_mm == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#-------------------------------------------------------------------------------
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
func Set_ResetGame() -> void:
	if(Input.is_action_just_pressed("Debug_Reset")):
		get_tree().reload_current_scene()
#-------------------------------------------------------------------------------
func Input_PauseGame() -> void:
	if(Input.is_action_just_pressed("Input_Pause")):
		if(!get_tree().paused):
			PauseOn()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseOn():
	pause_menu_panel.show()
	pause_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_button_array[0])
	#-------------------------------------------------------------------------------
	get_tree().set_deferred("paused", true)
#-------------------------------------------------------------------------------
func PauseOff():
	pause_menu_panel.hide()
	pause_menu.hide()
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
	Set_Button(pause_menu_button_array[0],func():Common_Selected() , func():PauseMenu_SkillButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	Set_Button(pause_menu_button_array[1],func():Common_Selected() , func():PauseMenu_ItemButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	Set_Button(pause_menu_button_array[2],func():Common_Selected() , func():PauseMenu_EquipButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	Set_Button(pause_menu_button_array[3],func():Common_Selected() , func():PauseMenu_StatusButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	Set_Button(pause_menu_button_array[4],func():Common_Selected() , func():pass, func():PauseMenu_AnyButton_Cancel())
	Set_Button(pause_menu_button_array[5],func():Common_Selected() , func():pass, func():PauseMenu_AnyButton_Cancel())
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_Submit():
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		Set_Button(_b, func():Common_Selected() , func():PauseMenu_SkillButton_PartyButton_Submit(_i), func():PauseMenu_SkillButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_party_button_array[0].button)
	pause_menu_button_array[0].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_ItemButton_Submit():
	pause_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(item_menu.get_tab_bar(),func():No_Description(), func():PauseMenu_ItemButton_ItemMenu_Cancel())
	#-------------------------------------------------------------------------------
	for _i in item_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		var _hold: int = item_array[_i].hold
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(item_array[_i] == (friend_party[_j].item_resource)):
				_hold -= 1
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+item_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_consumable_content.add_child(_button)
		item_menu_consumable_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "  ("+str(_hold)+" / "+str(item_array[_i].max_hold)+")  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			item_menu.show()
			Move_to_Button(item_menu_consumable_button_array[_i])
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():ItemMenu_ItemButton_Selected(item_array[_i]), func():pass, func():PauseMenu_ItemButton_ItemMenu_Cancel())
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+equip_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_equipment_content.add_child(_button)
		item_menu_equipment_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(equip_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():pass, func():PauseMenu_ItemButton_ItemMenu_Cancel())
	#-------------------------------------------------------------------------------
	for _i in key_item_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+key_item_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_keyitems_content.add_child(_button)
		item_menu_keyitems_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(key_item_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():pass, func():PauseMenu_ItemButton_ItemMenu_Cancel())
	#-------------------------------------------------------------------------------
	if(item_menu_consumable_button_array.size() > 0):
		Move_to_Button(item_menu_consumable_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		Move_to_Button(item_menu.get_tab_bar())
	#-------------------------------------------------------------------------------
	item_menu.current_tab = 0
	item_menu_consumable_scrollContainer.scroll_vertical = 0
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func No_Description():
	Common_Selected()
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
	skill_menu_description.text = ""
	skill_menu_lore.text = ""
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_Submit():
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		Set_Button(_b, func():Common_Selected() , func():PauseMenu_EquipButton_PartyButton_Submit(_i), func():PauseMenu_EquipButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_party_button_array[0].button)
	pause_menu_button_array[2].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_Submit():
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		Set_Button(_b, func():Common_Selected() , func():PauseMenu_StatusButton_PartyButton_Submit(_i), func():PauseMenu_StatusButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_party_button_array[0].button)
	pause_menu_button_array[3].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_AnyButton_Cancel():
	Common_Cancel()
	#-------------------------------------------------------------------------------
	PauseOff()
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	skill_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(skill_menu.get_tab_bar(),func():No_Description(), func():PauseMenu_SkillButton_PartyButton_SkillMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	for _i in friend_party[_index].skill_array.size():
		#-------------------------------------------------------------------------------
		var _item_resource: Item_Resource = friend_party[_index].skill_array[_i]
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		_button.theme = ui_theme
		_button.text = "  "+_item_resource.id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		skill_menu_content.add_child(_button)
		skill_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "  ("+str(_item_resource.sp_cost)+" SP)  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			skill_menu.show()
			Move_to_Button(skill_menu_button_array[_i])
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():SkillMenu_SkillButton_Selected(_item_resource), func():pass, func():PauseMenu_SkillButton_PartyButton_SkillMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	if(skill_menu_button_array.size() > 0):
		Move_to_Button(skill_menu_button_array[0])
	#-------------------------------------------------------------------------------
	skill_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_PartyButton_Cancel():
	Common_Cancel()
	#-------------------------------------------------------------------------------
	pause_menu_button_array[0].disabled = false
	Move_to_Button(pause_menu_button_array[0])
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_PartyButton_SkillMenu_Cancel(_index: int):
	skill_menu.hide()
	pause_menu.show()
	#--------------------------------------------------------------------------
	Destroy_All_Items(skill_menu_button_array)
	#--------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_party_button_array[_index].button)
#-------------------------------------------------------------------------------
func PauseMenu_ItemButton_ItemMenu_Cancel():
	item_menu.hide()
	pause_menu.show()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(item_menu_consumable_button_array)
	Destroy_All_Items(item_menu_equipment_button_array)
	Destroy_All_Items(item_menu_keyitems_button_array)
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_button_array[1])
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	equipslot_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(equipslot_menu.get_tab_bar(), func():Common_Selected(), func():PauseMenu_EquipButton_PartyButton_EquipSlot_Cancel(_index))
	#-------------------------------------------------------------------------------
	for _i in friend_party[_index].equip_array.size():
		var _button:Button = Button.new()
		_button.theme = ui_theme
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		#-------------------------------------------------------------------------------
		var _equip_resource: Equip_Resource = friend_party[_index].equip_array[_i]
		#-------------------------------------------------------------------------------
		if(_equip_resource == null):
			_button.text = "  [Empty]  "
		#-------------------------------------------------------------------------------
		else:
			_button.text = _equip_resource.id
		#-------------------------------------------------------------------------------
		equipslot_menu_button_array.append(_button)
		equipslot_menu_content.add_child(_button)
		#-------------------------------------------------------------------------------
		Set_Button(equipslot_menu_button_array[_i], func():Common_Selected(), func(): PauseMenu_EquipButton_PartyButton_EquipSlot_Submit(friend_party[_index], _i), func():PauseMenu_EquipButton_PartyButton_EquipSlot_Cancel(_index))
	#-------------------------------------------------------------------------------
	if(equipslot_menu_button_array.size() > 0):
		Move_to_Button(equipslot_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		Move_to_Button(equipslot_menu.get_tab_bar())
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_Submit(_user:Party_Member, _index_slot:int):
	equipslot_menu.hide()
	equip_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Set_TabBar(equip_menu.get_tab_bar(), func():Common_Selected(), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot))
	#-------------------------------------------------------------------------------
	var _empty_button: Button = Button.new()
	_empty_button.theme = ui_theme
	_empty_button.text = "  [Empty]  "
	_empty_button.add_theme_font_size_override("font_size", 24)
	_empty_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	equip_menu_content.add_child(_empty_button)
	equip_menu_button_array.append(_empty_button)
	Set_Button(_empty_button, func():Common_Selected(), func():PauseMenu_EquipButton_PartyButton_EmptyEquipSlot_EquipMenu_Submit(_user, _index_slot), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot))
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+equip_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		equip_menu_content.add_child(_button)
		equip_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(equip_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			equip_menu.show()
			Move_to_Button(equip_menu_button_array[_i])
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Submit(_user, equip_array[_i], _index_slot), func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot))
	#-------------------------------------------------------------------------------
	Move_to_Button(equip_menu_button_array[0])
	#-------------------------------------------------------------------------------
	equip_menu.current_tab = 0
	equip_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_Cancel(_index:int):
	pause_menu.show()
	equipslot_menu.hide()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(equipslot_menu_button_array)
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_party_button_array[_index].button)
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Submit(_user: Party_Member, _equip_resource:Equip_Resource, _index_slot:int):
	Common_Submit()
	#-------------------------------------------------------------------------------
	equipslot_menu_button_array[_index_slot].text = _equip_resource.id
	Destroy_All_Items(equip_menu_button_array)
	equipslot_menu.show()
	equip_menu.hide()
	Move_to_Button(equipslot_menu_button_array[_index_slot])
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EmptyEquipSlot_EquipMenu_Submit(_user: Party_Member, _index_slot:int):
	Common_Submit()
	#-------------------------------------------------------------------------------
	equipslot_menu_button_array[_index_slot].text = "  [Empty]  "
	Destroy_All_Items(equip_menu_button_array)
	equipslot_menu.show()
	equip_menu.hide()
	Move_to_Button(equipslot_menu_button_array[_index_slot])
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot:int):
	equipslot_menu.show()
	equip_menu.hide()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(equip_menu_button_array)
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(equipslot_menu_button_array[_index_slot])
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_Cancel():
	Common_Cancel()
	#-------------------------------------------------------------------------------
	pause_menu_button_array[2].disabled = false
	Move_to_Button(pause_menu_button_array[2])
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	status_menu.show()
	#-------------------------------------------------------------------------------
	Common_Submit()
	#-------------------------------------------------------------------------------
	Show_Status_Data(friend_party[_index])
	#-------------------------------------------------------------------------------
	Set_TabBar(status_menu.get_tab_bar(), func():Common_Selected(), func():PauseMenu_StatusButton_PartyButton_StatusMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	for _i in status_menu_stats_button_array.size():
		Set_Button(status_menu_stats_button_array[_i], func():Common_Selected(), func():pass, func():PauseMenu_StatusButton_PartyButton_StatusMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	for _i in friend_party[_index].status_array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+friend_party[_index].status_array[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		status_menu_content.add_child(_button)
		status_menu_statuseffect_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _label2: Label = Label.new()
		_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
		_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_label2.text = "x"+str(friend_party[_index].status_array[_i].hold)+"  "
		_button.add_child(_label2)
		#-------------------------------------------------------------------------------
		var _cancel: Callable = func():
			TargetMenu_TargetButton_Cancel()
			equip_menu.show()
			Move_to_Button(status_menu_statuseffect_button_array[_i])
		#-------------------------------------------------------------------------------
		Set_Button(_button, func():Common_Selected(), func():pass, func():PauseMenu_StatusButton_PartyButton_StatusMenu_Cancel(_index))
	#-------------------------------------------------------------------------------
	status_menu.current_tab = 0
	Move_to_Button(status_menu.get_tab_bar())
#-------------------------------------------------------------------------------
func Show_Status_Data(_user:Party_Member):
	status_menu_image.texture = _user.texture2d
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_PartyButton_StatusMenu_Cancel(_index:int):
	status_menu.hide()
	pause_menu.show()
	#-------------------------------------------------------------------------------
	Destroy_All_Items(status_menu_statuseffect_button_array)
	#-------------------------------------------------------------------------------
	Common_Cancel()
	#-------------------------------------------------------------------------------
	Move_to_Button(pause_menu_party_button_array[_index].button)
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_PartyButton_Cancel():
	Common_Cancel()
	#-------------------------------------------------------------------------------
	pause_menu_button_array[3].disabled = false
	Move_to_Button(pause_menu_button_array[3])
#-------------------------------------------------------------------------------
