extends Node
class_name Game_Scene
#-------------------------------------------------------------------------------
enum GAME_STATE{IN_WORLD, IN_MENU, IN_BATTLE}
enum BATTLE_STATE{STILL_FIGHTING, YOU_WIN, YOU_LOSE, YOU_ESCAPE, YOU_RETRY}
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
const consumable_item_resource_path: String = "res://Resources/Consumable_Items/"
const equip_item_resource_path: String = "res://Resources/Equip_Items/"
const key_item_resource_path: String = "res://Resources/Key_Items/"
const user_resource_path: String = "res://Resources/Users/"
const user_skill_resource_path: String = "res://Resources/User_Skills/"
const user_status_effect_resource_path: String = "res://Resources/User_Status_Effects/"
const skill_animation_effect_path: String = "res://Nodes/Prefabs/Skill Animation Effects/"
#-------------------------------------------------------------------------------
@export var world_2d: Node2D
@export var room_test: Room_Script
#-------------------------------------------------------------------------------
@export var ui_theme: Theme
var hex_color_yellow: String = "ffe500"
#var hex_color_yellow: String = "yellow"
var hex_color_orange: String = "fb7927"
#var hex_color_orange: String = "orange"
#-------------------------------------------------------------------------------
var key_dictionary: Dictionary[String, int]
#-------------------------------------------------------------------------------
@export_group("Important Resources")
@export var attack_skill_resource: Item_Resource
@export var guard_skill_resource: Item_Resource
@export var down_statuseffect_resource: StatusEffect_Resource
#-------------------------------------------------------------------------------
@export_group("Dialogue Menu")
@export var dialogue_menu: Control
@export var dialogue_menu_button_next: Button
@export var dialogue_menu_speaker1: Control
@export var dialogue_menu_speaker1_image: TextureRect
@export var dialogue_menu_speaker1_name: RichTextLabel
@export var dialogue_menu_speaking_label: RichTextLabel
#-------------------------------------------------------------------------------
@export_group("Save Menu")
@export var savespot_menu: Control
@export var savespot_menu_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Prefabs")
@export var ally_ui_prefab: PackedScene
@export var ally_popup_prefab: PackedScene
@export var enemy_ui_prefab: PackedScene
@export var enemy_popup_prefab: PackedScene
@export var party_button_prefab: PackedScene
#-------------------------------------------------------------------------------
@export_group("Player Nodes")
@export var player_characterbody2d: CharacterBody2D
@export var player_collider: CollisionShape2D
@export var player_interactable_by_action_area2d: Area2D
@export var player_interactable_by_touch_not_enemy_area2d: Area2D
@export var player_interactable_by_touch_enemy_area2d: Area2D
@export var friend_party: Array[Party_Member_Node]
#-------------------------------------------------------------------------------
var enemy_party: Array[Party_Member_Node]
#-------------------------------------------------------------------------------
@export_group("Item Menues")
@export var item_menu: Control
@export var item_menu_title: Label
@export var item_menu_description_title: Label
@export var item_menu_description: RichTextLabel
@export var item_menu_cost_label: Label
@export var item_menu_tp_cost_num_label: Label
@export var item_menu_cooldown_num_label: Label
@export var item_menu_hold_label: Label
@export var item_menu_hold_num_label: Label
@export var item_menu_storage_num_label: Label
#-------------------------------------------------------------------------------
@export_group("All Item Menu")
@export var item_menu_all_scrollContainer: ScrollContainer
@export var item_menu_all_content: VBoxContainer
@export var item_menu_all_button: Button
var item_menu_all_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Consumable Item Menu")
@export var item_menu_consumable_scrollContainer: ScrollContainer
@export var item_menu_consumable_content: VBoxContainer
@export var item_menu_consumable_button: Button
var item_menu_consumable_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Equip Item Menu")
@export var item_menu_equip_scrollContainer: ScrollContainer
@export var item_menu_equip_content: VBoxContainer
@export var item_menu_equip_button: Button
var item_menu_equip_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Key Item Menu")
@export var item_menu_key_scrollContainer: ScrollContainer
@export var item_menu_key_content: VBoxContainer
@export var item_menu_key_button: Button
var item_menu_key_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Inventory")
@export var inventory_serializable: Inventory_Serializable
var inventory_serializable_in_battle: Inventory_Serializable
#-------------------------------------------------------------------------------
@export_group("User Menues")
@export var user_menu: Control
@export var user_menu_title: Label
@export var user_menu_description_title: Label
@export var user_menu_description: RichTextLabel
@export var user_menu_cost_label: Label
@export var user_menu_tp_cost_num_label: Label
@export var user_menu_cooldown_num_label: Label
@export var user_menu_held_label: Label
@export var user_menu_hold_num_label: Label
@export var user_menu_storage_num_label: Label
#-------------------------------------------------------------------------------
@export_group("User Menu Skill")
@export var user_menu_skill_scrollContainer: ScrollContainer
@export var user_menu_skill_content: VBoxContainer
@export var user_menu_skill_button: Button
var user_menu_skill_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("User Menu Equip")
@export var user_menu_equip_scrollContainer: ScrollContainer
@export var user_menu_equip_content: VBoxContainer
@export var user_menu_equip_button: Button
var user_menu_equip_button_array: Array[Button]
@export var user_menu_equip_button_label: Label
#-------------------------------------------------------------------------------
@export_group("User Menu Info")
@export var user_menu_info_container: Control
@export var user_menu_info_button: Button
@export var user_menu_info_party_button: Party_Button
@export var user_menu_info_image: TextureRect
#-------------------------------------------------------------------------------
@export_group("User Menu Stats")
@export var user_menu_stats_scrollContainer: ScrollContainer
@export var user_menu_stats_content: VBoxContainer
@export var user_menu_stats_button: Button
var user_menu_stats_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("User Menu Status-Effect")
@export var user_menu_statuseffect_scrollContainer: ScrollContainer
@export var user_menu_statuseffect_content: VBoxContainer
@export var user_menu_statuseffect_button: Button
var user_menu_statuseffect_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Teleport Menu")
@export var teleport_menu: Control
@export var teleport_menu_title: Label
@export var teleport_menu_rect: TextureRect
@export var teleport_menu_description: RichTextLabel
#-------------------------------------------------------------------------------
@export var teleport_menu_zone_scrollContainer: ScrollContainer
@export var teleport_menu_zone_content: HBoxContainer
@export var teleport_menu_zone_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export var teleport_menu_bonfire_scrollContainer: ScrollContainer
@export var teleport_menu_bonfire_content: VBoxContainer
var teleport_menu_bonfire_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Confirm Buy Menu")
@export var confirm_buy_menu: Control
@export var confirm_buy_menu_item_name: Label
@export var confirm_buy_menu_button: Button
@export var confirm_buy_menu_item_price: Label
#-------------------------------------------------------------------------------
@export_group("Money Menu")
@export var money_menu: Control
@export var money_menu_label: Label
#-------------------------------------------------------------------------------
@export_group("Pause Menu")
var camera_offset_y: float = 28
var current_player_turn: int = 0
@export var black_panel: Panel
@export var black_panel_on_top_of_everithing: Panel
@export var battle_black_panel: Panel
@export var pause_menu_panel: Panel
@export var pause_menu_money_label: Label
@export var pause_menu: Control
@export var pause_menu_title_label: Label
@export var pause_menu_button_array: Array[Button]
@export var pause_menu_party_label: Label
@export var pause_menu_party_button_content: Control
var pause_menu_party_button_array: Array[Party_Button]
#-------------------------------------------------------------------------------
@export var go_to_title_menu: Control
@export var go_to_title_menu_title_label: Label
@export var go_to_title_menu_button_array: Array[Button]
#-------------------------------------------------------------------------------
var isSlowMotion: bool = false
#-------------------------------------------------------------------------------
var can_enter_fight: bool = true
var player_last_position: Array[Vector2]
var enemy_last_position: Array[Vector2]
#-------------------------------------------------------------------------------
const submitInput: String = "ui_accept"
const cancelInput: String = "ui_cancel"
@export_group("Win_Lose_Retry_Escape Menu")
@export var win_lose_retry_escape_menu_label: Label
@export var win_lose_retry_escape_menu_vboxcontainer: VBoxContainer
@export var win_lose_retry_escape_menu_button: Array[Button]
#-------------------------------------------------------------------------------
@export_group("Debug Nodes")
@export var debug_label: Label
@export var fps_label: Label
var tween_Array: Array[Tween]
#-------------------------------------------------------------------------------
@export_group("Camera")
@export var camera: Camera2D
#-------------------------------------------------------------------------------
@export_group("Battle Menu")
@export var battle_control: Control
@export var battle_menu: Control
@export var battle_menu_button: Array[Button]
@export var battle_box: Control
#-------------------------------------------------------------------------------
@export var hitbox: Sprite2D
@export var grazebox: Sprite2D
@export var hitbox_animation_tree: AnimationTree
#-------------------------------------------------------------------------------
@export var can_equip_midbattle: bool = false
@export var battlemenu_equipbutton_emptyspace: Control
#-------------------------------------------------------------------------------
@export var timer_label: Label
var timer_tween: Tween
var timer: int
var main_tween_Array: Array[Tween]
#-------------------------------------------------------------------------------
var can_be_hit: bool = true
var i_frames: int = 0
#-------------------------------------------------------------------------------
@export_group("TP Bar")
@export var tp_bar_root: Control
@export var tp_bar_progressbar_present: ProgressBar
@export var tp_bar_progressbar_future: ProgressBar
@export var tp_label: Label
@export var max_tp_label: Label
var tp_bar_original_size: float
var tp: int
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
var grazeBox_radius: float = 10.0
var hitBox_radius: float = 1.5
var canBeHit: bool = true
var camera_size: Vector2
var camera_center: Vector2
var viewport_size: Vector2
var viewport_center: Vector2
#-------------------------------------------------------------------------------
var deltaTimeScale: float = 1.0
signal dialogue_signal
var is_in_dialogue: bool = false
var how_many_would_you_buy: int = 0
var input_dir: Vector2
var input_dir_normal: Vector2
var dead_zone: float = 0.001
#endregion
#-------------------------------------------------------------------------------
#region MONOBEHAVIOUR
func _enter_tree() -> void:
	singleton.game_scene =  self
#-------------------------------------------------------------------------------
func _exit_tree() -> void:
	singleton.game_scene =  null
#-------------------------------------------------------------------------------
func _ready() -> void:
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json = singleton.LoadCurrent_SaveData_Json()
	Load_All_Data()
	Fill_the_ConsumableItems_Stored_from_Hold()
	ReFill_All_Skills()
	#-------------------------------------------------------------------------------
	singleton.Play_BGM(singleton.stage1)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = ally_ui_prefab.instantiate() as Party_Member_UI
		friend_party[_i].party_member_ui = _party_member_ui
		friend_party[_i].party_member_ui.hide()
		friend_party[_i].party_member_ui.button_pivot.hide()
		friend_party[_i].party_member_ui.label_sp.hide()
		friend_party[_i].party_member_ui.bar_sp.hide()
		battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
	win_lose_retry_escape_menu_vboxcontainer.hide()
	win_lose_retry_escape_menu_label.hide()
	battle_menu.hide()
	dialogue_menu.hide()
	savespot_menu.hide()
	item_menu.hide()
	teleport_menu.hide()
	user_menu.hide()
	battle_box.hide()
	timer_label.hide()
	battle_black_panel.hide()
	tp_bar_root.hide()
	confirm_buy_menu.hide()
	money_menu.hide()
	go_to_title_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Horizontal_Navigation(go_to_title_menu_button_array)
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(user_menu_info_button)
	singleton.Button_Remove_Navigation(user_menu_stats_button)
	singleton.Button_Remove_Navigation(user_menu_statuseffect_button)
	singleton.Button_Remove_Navigation(user_menu_equip_button)
	singleton.Button_Remove_Navigation(user_menu_skill_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(item_menu_all_button)
	singleton.Button_Remove_Navigation(item_menu_consumable_button)
	singleton.Button_Remove_Navigation(item_menu_equip_button)
	singleton.Button_Remove_Navigation(item_menu_key_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(dialogue_menu_button_next)
	#-------------------------------------------------------------------------------
	for _i in teleport_menu_zone_button_array.size():
		singleton.Button_Remove_Navigation(teleport_menu_zone_button_array[_i])
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
	room_test.Set_Room()
	camera.global_position = Camera_Set_Target_Position()
	#-------------------------------------------------------------------------------
	hitbox.global_scale = Get_CircleSprite_Scale(hitBox_radius) + Vector2(0.01, 0.01)
	grazebox.global_scale = Get_CircleSprite_Scale(grazeBox_radius) + Vector2(0.01, 0.01)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(item_menu_all_content)
	Destroy_Childrens(item_menu_consumable_content)
	Destroy_Childrens(item_menu_equip_content)
	Destroy_Childrens(item_menu_key_content)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(user_menu_skill_content)
	Destroy_Childrens(user_menu_equip_content)
	Destroy_Childrens(user_menu_stats_content)
	Destroy_Childrens(user_menu_statuseffect_content)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(pause_menu_party_button_content)
	#-------------------------------------------------------------------------------
	Destroy_Childrens(teleport_menu_bonfire_content)
	#Destroy_Childrens(teleport_menu_zone_content)
	#-------------------------------------------------------------------------------
	Create_EnemyBullets_Disabled(2000)
	PauseMenu_Close()
	NormalMotion()
	#-------------------------------------------------------------------------------
	PauseMenu_Set()
	#-------------------------------------------------------------------------------
	Set_Idiome()
	#-------------------------------------------------------------------------------
	Set_All_Menu_Descriptions_Minimum_Size_Y(418)
	#-------------------------------------------------------------------------------
	tp_bar_original_size = tp_bar_progressbar_present.size.y
#-------------------------------------------------------------------------------
func Set_All_Menu_Descriptions_Minimum_Size_Y(_minimum_size_x:float):
	item_menu_description.custom_minimum_size.x = _minimum_size_x
	user_menu_description.custom_minimum_size.x = _minimum_size_x
	teleport_menu_description.custom_minimum_size.x = _minimum_size_x
#-------------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	tween_Array = get_tree().get_processed_tweens()
	#-------------------------------------------------------------------------------
	match(myGAME_STATE):
		GAME_STATE.IN_WORLD:
			#-------------------------------------------------------------------------------
			if(!get_tree().paused):
				#-------------------------------------------------------------------------------
				if(is_in_dialogue):
					return
				#-------------------------------------------------------------------------------
				else:
					Player_Movement()
					Followers_Movement()
					Camera_Follow()
					#-------------------------------------------------------------------------------
					if(Input.is_action_just_pressed("Input_Pause")):
						PauseMenu_Open()
						return
					#-------------------------------------------------------------------------------
					if(Input.is_action_just_pressed("ui_accept")):
						var _interactable_by_action_array : Array[Area2D] = player_interactable_by_action_area2d.get_overlapping_areas()
						#-------------------------------------------------------------------------------
						if(_interactable_by_action_array.size() > 0):
							var _interactable_by_action: Interactable_Script = _interactable_by_action_array[0] as Interactable_Script
							_interactable_by_action.Interactable_Action()
							return
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
					var _interactable_by_touch_not_enemy_array : Array[Area2D] = player_interactable_by_touch_not_enemy_area2d.get_overlapping_areas()
					#-------------------------------------------------------------------------------
					if(_interactable_by_touch_not_enemy_array.size() > 0):
						var _interactable_by_touch_not_enemy: Interactable_Script = _interactable_by_touch_not_enemy_array[0] as Interactable_Script
						_interactable_by_touch_not_enemy.Interactable_Action()
						return
					#-------------------------------------------------------------------------------
					var _interactable_by_touch_enemy_array : Array[Area2D] = player_interactable_by_touch_enemy_area2d.get_overlapping_areas()
					#-------------------------------------------------------------------------------
					if(_interactable_by_touch_enemy_array.size() > 0 and can_enter_fight):
						var _interactable_by_touch_enemy: Interactable_Script = _interactable_by_touch_enemy_array[0] as Interactable_Script
						_interactable_by_touch_enemy.Interactable_Action()
						return
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
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#-------------------------------------------------------------------------------
	if(abs(input_dir.x) < dead_zone):
		input_dir.x = 0
	#-------------------------------------------------------------------------------
	if(abs(input_dir.y) < dead_zone):
		input_dir.y = 0
	#-------------------------------------------------------------------------------
	if(friend_party[0].is_Moving):
		#-------------------------------------------------------------------------------
		if(input_dir == Vector2.ZERO):
			Animation_StateMachine(friend_party[0].animation_tree, "", "Idle")
			friend_party[0].is_Moving = false
			input_dir_normal = Vector2.ZERO
			return
		#-------------------------------------------------------------------------------
		else:
			input_dir_normal = input_dir.normalized()
			#-------------------------------------------------------------------------------
			if(is_Running):
				var _new_velocity: Vector2 = input_dir_normal * 180.0 * deltaTimeScale
				player_characterbody2d.velocity = _new_velocity
				#-------------------------------------------------------------------------------
				if(!_run_flag):
					Animation_StateMachine(friend_party[0].animation_tree, "", "Walk")
					is_Running = false
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				var _new_velocity: Vector2 = input_dir_normal * 90.0 * deltaTimeScale
				player_characterbody2d.velocity = _new_velocity
				#-------------------------------------------------------------------------------
				if(_run_flag):
					Animation_StateMachine(friend_party[0].animation_tree, "", "Run")
					is_Running = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			if(friend_party[0].is_Facing_Left):
				if(input_dir_normal.x > 0):
					Face_Left(friend_party[0], false)
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				if(input_dir_normal.x < 0):
					Face_Left(friend_party[0], true)
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		if(input_dir != Vector2.ZERO):
			#-------------------------------------------------------------------------------
			if(_run_flag):
				Animation_StateMachine(friend_party[0].animation_tree, "", "Run")
				is_Running = true
			#-------------------------------------------------------------------------------
			else:
				Animation_StateMachine(friend_party[0].animation_tree, "", "Walk")
				is_Running = false
			#-------------------------------------------------------------------------------
			friend_party[0].is_Moving = true
			return
		#-------------------------------------------------------------------------------
		else:
			var _new_velocity: Vector2 = Vector2.ZERO
			player_characterbody2d.velocity = _new_velocity
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
					Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
					friend_party[_i].is_Moving = false
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				#-------------------------------------------------------------------------------
				if(friend_party[_i].global_position.distance_to(_new_position) > 10):
					Animation_StateMachine(friend_party[_i].animation_tree, "", "Run")
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
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#-------------------------------------------------------------------------------
	if(abs(input_dir.x) < dead_zone):
		input_dir.x = 0
	#-------------------------------------------------------------------------------
	if(abs(input_dir.y) < dead_zone):
		input_dir.y = 0
	#-------------------------------------------------------------------------------
	if(input_dir != Vector2.ZERO):
		input_dir_normal = input_dir.normalized()
		var myPosition: Vector2 = hitbox.position
		#-------------------------------------------------------------------------------
		if(_run_flag):
			myPosition += input_dir_normal * 0.7 * deltaTimeScale
		#-------------------------------------------------------------------------------
		else:
			myPosition += input_dir_normal * 1.8 * deltaTimeScale
		#-------------------------------------------------------------------------------
		myPosition.y = clampf(myPosition.y, box_limit_up, box_limit_down)
		myPosition.x = clampf(myPosition.x, box_limit_left, box_limit_right)
		hitbox.position = myPosition
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Camera_Follow():
	var _new_position: Vector2 = Camera_Set_Target_Position()
	camera.global_position = lerp(camera.global_position, _new_position, 0.2)
#-------------------------------------------------------------------------------
func Camera_Set_Target_Position() -> Vector2:
	var _new_position: Vector2 = friend_party[0].global_position + Vector2(0, -camera_offset_y)
	#-------------------------------------------------------------------------------
	_new_position.x = clampf(_new_position.x, room_test.limit_left, room_test.limit_right)
	_new_position.y = clampf(_new_position.y, room_test.limit_top, room_test.limit_botton)
	#-------------------------------------------------------------------------------
	return _new_position
#-------------------------------------------------------------------------------
func Face_Left(_user:Party_Member_Node, _b:bool):
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
	singleton.Common_Submited()
	await PickUp_Item_2(_item_script)
	#await Dialogue(false, "* Bla bla bla bla bla bla bla.")
	Dialogue_Close()
	singleton.Common_Canceled()
	return
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PickUp_Item_2(_item_script:Item_Script):
	_item_script.queue_free()
	key_dictionary.set(room_test.Get_Item_Script_ID(_item_script), 1)
	#-------------------------------------------------------------------------------
	var _s:String = "* "
	#-------------------------------------------------------------------------------
	for _i in _item_script.pickable_consumableitem.size():
		var _hold: int = _item_script.pickable_consumableitem[_i].hold
		#-------------------------------------------------------------------------------
		var _item_name: String = tr("name_"+get_resource_filename(_item_script.pickable_consumableitem[_i].item_resource))
		var _hold_text: String = " ["+str(_hold)+"]"
		#-------------------------------------------------------------------------------
		var _item: String = "[color="+hex_color_yellow+"]"+_item_name+"[/color]"+_hold_text
		#-------------------------------------------------------------------------------
		_s += _item
		#-------------------------------------------------------------------------------
		if(_i < _item_script.pickable_consumableitem.size()-1):
			_s += ", "
		#-------------------------------------------------------------------------------
		else:
			_s += " "
		#-------------------------------------------------------------------------------
		Add_ConsumableItem_to_Inventory(_item_script.pickable_consumableitem[_i], _hold)
	#-------------------------------------------------------------------------------
	if(_item_script.pickable_consumableitem.size() > 0):
		_s += ", "
	#-------------------------------------------------------------------------------
	for _i in _item_script.pickable_equipitem.size():
		var _stored: int = _item_script.pickable_equipitem[_i].stored
		#-------------------------------------------------------------------------------
		var _equip_name: String = tr("name_"+get_resource_filename(_item_script.pickable_equipitem[_i].equip_resource))
		var _hold_text: String = " ["+str(_stored)+"]"
		#-------------------------------------------------------------------------------
		var _equip: String = "[color="+hex_color_yellow+"]"+_equip_name+"[/color]"+_hold_text
		#-------------------------------------------------------------------------------
		_s += _equip
		#-------------------------------------------------------------------------------
		if(_i < _item_script.pickable_equipitem.size()-1):
			_s += ", "
		#-------------------------------------------------------------------------------
		else:
			_s += " "
		#-------------------------------------------------------------------------------
		Add_EquipItem_to_Inventory(_item_script.pickable_equipitem[_i], _stored)
	#-------------------------------------------------------------------------------
	if(_item_script.pickable_equipitem.size() > 0):
		_s += ", "
	#-------------------------------------------------------------------------------
	for _i in _item_script.pickable_keyitem.size():
		var _stored: int = _item_script.pickable_keyitem[_i].stored
		#-------------------------------------------------------------------------------
		var _keyitem_name: String = tr("name_"+get_resource_filename(_item_script.pickable_keyitem[_i].key_item_resource))
		var _hold_text: String = " ["+str(_stored)+"]"
		#-------------------------------------------------------------------------------
		var _keyitem: String = "[color="+hex_color_yellow+"]"+_keyitem_name+"[/color]"+_hold_text
		#-------------------------------------------------------------------------------
		_s += _keyitem
		#-------------------------------------------------------------------------------
		if(_i < _item_script.pickable_keyitem.size()-1):
			_s += ", "
		#-------------------------------------------------------------------------------
		else:
			_s += " "
		#-------------------------------------------------------------------------------
		Add_KeyItem_to_Inventory(_item_script.pickable_keyitem[_i], _stored)
	#-------------------------------------------------------------------------------
	_s += "was picked."
	await Dialogue(_s)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SET BATTLEFIELD
#-------------------------------------------------------------------------------
func EnterBattle(_enemy_array:Array[Party_Member_Node]):
	myGAME_STATE = GAME_STATE.IN_MENU
	myBATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
	#-------------------------------------------------------------------------------
	singleton.Play_SFX_Enter_Battle()
	#-------------------------------------------------------------------------------
	enemy_party.clear()
	#-------------------------------------------------------------------------------
	for _i in _enemy_array.size():
		enemy_party.append(_enemy_array[_i])
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = enemy_ui_prefab.instantiate() as Party_Member_UI
		_enemy_array[_i].party_member_ui = _party_member_ui
		_enemy_array[_i].party_member_ui.hide()
		_enemy_array[_i].party_member_ui.button_pivot.hide()
		_enemy_array[_i].party_member_ui.label_sp.hide()
		_enemy_array[_i].party_member_ui.bar_sp.hide()
		_enemy_array[_i].party_member_ui.dialogue_root.hide()
		battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
	var _center: Vector2 = camera.global_position
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
		Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
		friend_party[_i].z_index = 1
		Face_Left(friend_party[_i], false)
		#friend_party[_i].global_position = friend_party[0].global_position
		friend_party[_i].party_member_ui.button.text = "  " + tr("name_"+get_instance_filename(friend_party[_i])) + "  "
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
		Animation_StateMachine(enemy_party[_i].animation_tree, "Base_StateMachine/", "Idle")
		enemy_party[_i].z_index = 1
		Face_Left(enemy_party[_i], true)
		#enemy_party[_i].global_position = enemy_party[0].global_position
		enemy_party[_i].party_member_ui.button.text = "  " + tr("name_"+get_instance_filename(enemy_party[_i])) + "  "
	#-------------------------------------------------------------------------------
	current_player_turn = 0
	singleton.bgmPlayer.stop()
	#-------------------------------------------------------------------------------
	battle_black_panel.global_position = _center - battle_black_panel.size/2.0 * battle_black_panel.scale
	battle_black_panel.show()
	#-------------------------------------------------------------------------------
	Set_AllItems_When_Enter_Battle()
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
		dialogue_menu_button_next.hide()
		battle_menu.show()
		tp_bar_root.show()
		#-------------------------------------------------------------------------------
		battle_box.global_position = camera.global_position - battle_box.size/2.0
		singleton.Set_Button(battle_menu_button[0],func():singleton.Common_Selected() , func():BattleMenu_AttackButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[1],func():singleton.Common_Selected() , func():BattleMenu_DefenseButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[2],func():singleton.Common_Selected() , func():BattleMenu_SkillButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[3],func():singleton.Common_Selected() , func():BattleMenu_ItemButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[4],func():singleton.Common_Selected() , func():BattleMenu_EquipButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		singleton.Set_Button(battle_menu_button[5],func():singleton.Common_Selected() , func():BattleMenu_StatusButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		#-------------------------------------------------------------------------------
		singleton.Move_to_First_Button(battle_menu_button)
		singleton.Common_Submited()
		#-------------------------------------------------------------------------------
		singleton.Play_BGM(singleton.battle1)
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			Set_All_User_Skills_Equip_StatusEffect_When_Enter_Battle(friend_party[_i])
			#-------------------------------------------------------------------------------
			var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(friend_party[_i].party_member_serializable, "max_hp")
			friend_party[_i].party_member_serializable.hp = _max_hp
			Set_HP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].party_member_serializable.sp = 0
			Set_SP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			Set_Status_Effect_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].party_member_ui.show()
			friend_party[_i].party_member_ui.button_pivot.hide()
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			Set_All_User_Skills_Equip_StatusEffect_When_Enter_Battle(enemy_party[_i])
			#-------------------------------------------------------------------------------
			var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(enemy_party[_i].party_member_serializable, "max_hp")
			enemy_party[_i].party_member_serializable.hp = _max_hp
			Set_HP_Label(enemy_party[_i])
			#-------------------------------------------------------------------------------
			enemy_party[_i].party_member_serializable.sp = 0
			Set_SP_Label(enemy_party[_i])
			#-------------------------------------------------------------------------------
			Set_Status_Effect_Label(enemy_party[_i])
			#-------------------------------------------------------------------------------
			enemy_party[_i].party_member_ui.show()
			enemy_party[_i].party_member_ui.button_pivot.hide()
		#-------------------------------------------------------------------------------
		Set_Starting_TP()
		Set_TP_Label(tp)
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Set_Starting_TP():
	tp = 30
	Set_TP_Label(tp)
#-------------------------------------------------------------------------------
func Set_AllItems_When_Enter_Battle():
	inventory_serializable_in_battle = inventory_serializable.Constructor()
#-------------------------------------------------------------------------------
func Set_AllItems_When_Exit_Battle():
	inventory_serializable = inventory_serializable_in_battle.Constructor()
#-------------------------------------------------------------------------------
func Set_All_User_Skills_Equip_StatusEffect_When_Enter_Battle(_user:Party_Member_Node):
	_user.party_member_serializable_in_battle = _user.party_member_serializable.Constructor()
	_user.party_member_serializable_in_battle.Set_Skills()
#-------------------------------------------------------------------------------
func Set_All_User_Skills_Equip_StatusEffect_When_Exit_Battle(_user:Party_Member_Node):
	_user.party_member_serializable = _user.party_member_serializable_in_battle.Constructor()
#-------------------------------------------------------------------------------
func Move_Fighters_to_Position_2(_is_menu_position:bool):
	var _tween: Tween = create_tween()
	Move_Fighters_to_Position(_tween, _is_menu_position, 0.3)
	_tween.tween_interval(0.2)
	await _tween.finished
#-------------------------------------------------------------------------------
func Move_Fighters_to_Position(_tween:Tween, _is_menu_position:bool, _timer:float):
	var _center: Vector2 = camera.global_position
	var _top_limit: float
	var _botton_limit: float
	#-------------------------------------------------------------------------------
	if(_is_menu_position):
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
#endregion
#-------------------------------------------------------------------------------
#region BATTLE_MENU FUNCTIONS
#-------------------------------------------------------------------------------
func BattleMenu_AttackButton_Submit():
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		battle_menu.show()
		dialogue_menu.show()
		dialogue_menu_button_next.hide()
		#-------------------------------------------------------------------------------
		Set_TP_Label_from_the_future()
		TargetMenu_TargetButton_Cancel()
		#-------------------------------------------------------------------------------
		singleton.Move_to_First_Button(battle_menu_button)
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	var _skill_serializable: Item_Serializable = Item_Serializable.new()
	_skill_serializable.item_resource = attack_skill_resource
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(_skill_serializable, battle_menu, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_DefenseButton_Submit():
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		battle_menu.show()
		dialogue_menu.show()
		dialogue_menu_button_next.hide()
		#-------------------------------------------------------------------------------
		TargetMenu_TargetButton_Cancel()
		Set_TP_Label_from_the_future()
		#-------------------------------------------------------------------------------
		singleton.Move_to_Button(battle_menu_button[1])
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	var _skill_serializable: Item_Serializable = Item_Serializable.new()
	_skill_serializable.item_resource = guard_skill_resource
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(_skill_serializable, battle_menu, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_SkillButton_Submit():
	battle_menu.hide()
	dialogue_menu.hide()
	user_menu.show()
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(user_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(user_menu_description)
	#-------------------------------------------------------------------------------
	var _a: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _d: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():User_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():SkillMenu_SkillButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(user_menu_skill_button, _selected_0, _submit_0, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	var _user: Party_Member_Node = _friend_party_alive[current_player_turn]
	var _skill_serializable_array: Array[Item_Serializable] = _user.party_member_serializable_in_battle.Get_Skills()
	#-------------------------------------------------------------------------------
	for _i in _skill_serializable_array.size():
		var _button: Button = Create_Skill_Button(_skill_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _cancel_back: Callable = func():
			user_menu.show()
			dialogue_menu.hide()
			#-------------------------------------------------------------------------------
			Set_TP_Label_from_the_future()
			TargetMenu_TargetButton_Cancel()
			#-------------------------------------------------------------------------------
			singleton.Move_to_Button(user_menu_skill_button_array[_i])
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():SkillMenu_SkillButton_Selected(_skill_serializable_array[_i])
		var _submit_1: Callable = func(): SkillMenu_SkillButton_Submit(_skill_serializable_array[_i], _cancel_back)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_button, _selected_1, _submit_1, _cancel_0, _w, _s, _a, _d)
		user_menu_skill_content.add_child(_button)
		user_menu_skill_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_skill_button_array)
	#-------------------------------------------------------------------------------
	User_Menu_Hide_All_Button()
	User_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button(user_menu_skill_scrollContainer, user_menu_skill_button_array, user_menu_skill_button)
	user_menu_title.text = tr("user_menu_skill_label")
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func BattleMenu_ItemButton_Submit():
	battle_menu.hide()
	dialogue_menu.hide()
	item_menu.show()
	item_menu_title.text = "Skills:"
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(item_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(item_menu_description)
	#-------------------------------------------------------------------------------
	var _all_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_all_scrollContainer, item_menu_all_button)
		Enable_Menu_And_Move_to_Button(item_menu_key_scrollContainer, item_menu_key_button_array, item_menu_key_button)
		item_menu_title.text = tr("item_menu_key_items_label")
	#-------------------------------------------------------------------------------
	var _all_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_all_scrollContainer, item_menu_all_button)
		Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
		item_menu_title.text = tr("item_menu_consumable_items_label")
	#-------------------------------------------------------------------------------
	var _consumable_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button)
		Enable_Menu_And_Move_to_Button(item_menu_all_scrollContainer, item_menu_all_button_array, item_menu_all_button)
		item_menu_title.text = tr("item_menu_all_items_label")
	#-------------------------------------------------------------------------------
	var _consumable_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button)
		Enable_Menu_And_Move_to_Button(item_menu_equip_scrollContainer, item_menu_equip_button_array, item_menu_equip_button)
		item_menu_title.text = tr("item_menu_equip_items_label")
	#-------------------------------------------------------------------------------
	var _equip_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_equip_scrollContainer, item_menu_equip_button)
		Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
		item_menu_title.text = tr("item_menu_consumable_items_label")
	#-------------------------------------------------------------------------------
	var _equip_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_equip_scrollContainer, item_menu_equip_button)
		Enable_Menu_And_Move_to_Button(item_menu_key_scrollContainer, item_menu_key_button_array, item_menu_key_button)
		item_menu_title.text = tr("item_menu_key_items_label")
	#-------------------------------------------------------------------------------
	var _key_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_key_scrollContainer, item_menu_key_button)
		Enable_Menu_And_Move_to_Button(item_menu_equip_scrollContainer, item_menu_equip_button_array, item_menu_equip_button)
		item_menu_title.text = tr("item_menu_equip_items_label")
	#-------------------------------------------------------------------------------
	var _key_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_key_scrollContainer, item_menu_key_button)
		Enable_Menu_And_Move_to_Button(item_menu_all_scrollContainer, item_menu_all_button_array, item_menu_all_button)
		item_menu_title.text = tr("item_menu_all_items_label")
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():Item_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():ItemMenu_ItemButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(item_menu_all_button, _selected_0, _submit_0, _cancel_0, _w, _s, _all_a, _all_d)
	singleton.Set_Button_WSAD(item_menu_consumable_button, _selected_0, _submit_0, _cancel_0, _w, _s, _consumable_a, _consumable_d)
	singleton.Set_Button_WSAD(item_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _equip_a, _equip_d)
	singleton.Set_Button_WSAD(item_menu_key_button, _selected_0, _submit_0, _cancel_0, _w, _s, _key_a, _key_d)
	#-------------------------------------------------------------------------------
	var _inventory_serializable: Inventory_Serializable = inventory_serializable_in_battle
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.consumable_item_array.size():
		var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
		#-------------------------------------------------------------------------------
		var _hold: int = _inventory_serializable.consumable_item_array[_i].hold
		var _cooldown: int = _inventory_serializable.consumable_item_array[_i].cooldown
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(_inventory_serializable.consumable_item_array[_i].item_resource == (_friend_party_alive[_j].item_serializable.item_resource)):
				_hold -= 1
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(_inventory_serializable.consumable_item_array[_i].item_resource == (_friend_party_alive[_j].item_serializable.item_resource)):
				_cooldown += _inventory_serializable.consumable_item_array[_i].item_resource.max_cooldown
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(_inventory_serializable.consumable_item_array[_i].hold > 0):
			var _consumableitem_button: Button = Create_ConsumableItem_Button(_inventory_serializable.consumable_item_array[_i], _hold, _cooldown)
			#-------------------------------------------------------------------------------
			var _back_consumableitem: Callable = func():
				item_menu.show()
				dialogue_menu.hide()
				#-------------------------------------------------------------------------------
				TargetMenu_TargetButton_Cancel()
				Set_TP_Label_from_the_future()
				#-------------------------------------------------------------------------------
				singleton.Move_to_Button(_consumableitem_button)
				singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			var _selected_consumableitem: Callable = func():ItemMenu_Consumable_ItemButton_Selected(_inventory_serializable.consumable_item_array[_i])
			var _submit_consumableitem: Callable = func():ItemMenu_ItemButton_Submit(_inventory_serializable.consumable_item_array[_i], _hold, _cooldown, _back_consumableitem)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD(_consumableitem_button, _selected_consumableitem, _submit_consumableitem, _cancel_0, _w, _s, _consumable_a, _consumable_d)
			item_menu_consumable_content.add_child(_consumableitem_button)
			item_menu_consumable_button_array.append(_consumableitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_ConsumableItem_Button(_inventory_serializable.consumable_item_array[_i], _hold, _cooldown)
		#-------------------------------------------------------------------------------
		var _back_allitem: Callable = func():
			item_menu.show()
			dialogue_menu.hide()
			#-------------------------------------------------------------------------------
			TargetMenu_TargetButton_Cancel()
			Set_TP_Label_from_the_future()
			#-------------------------------------------------------------------------------
			singleton.Move_to_Button(_allitem_button)
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		var _selected_allitem: Callable = func():ItemMenu_Consumable_ItemButton_Selected(_inventory_serializable.consumable_item_array[_i])
		var _submit_allitem: Callable = func():ItemMenu_ItemButton_Submit(_inventory_serializable.consumable_item_array[_i], _hold, _cooldown, _back_allitem)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected_allitem, _submit_allitem, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.equip_item_array.size():
		var _equipitem_button: Button = Create_EquipItem_Button(_inventory_serializable.equip_item_array[_i])
		#-------------------------------------------------------------------------------
		var _selected: Callable = func():ItemMenu_Equipment_ItemButton_Selected(_inventory_serializable.equip_item_array[_i])
		var _submit: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_equipitem_button, _selected, _submit, _cancel_0, _w, _s, _equip_a, _equip_d)
		item_menu_equip_content.add_child(_equipitem_button)
		item_menu_equip_button_array.append(_equipitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_EquipItem_Button(_inventory_serializable.equip_item_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected, _submit, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	var _new_key_item_array: Array[Key_Item_Serializable] = Get_Key_Item_Serializable_Array(_inventory_serializable)
	#-------------------------------------------------------------------------------
	for _i in _new_key_item_array.size():
		var _keyitem_button: Button = Create_KeyItem_Button(_new_key_item_array[_i])
		#-------------------------------------------------------------------------------
		var _selected: Callable = func():ItemMenu_KeyItem_ItemButton_Selected(_new_key_item_array[_i])
		var _submit: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_keyitem_button, _selected, _submit, _cancel_0, _w, _s, _key_a, _key_d)
		item_menu_key_content.add_child(_keyitem_button)
		item_menu_key_button_array.append(_keyitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_KeyItem_Button(_new_key_item_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected, _submit, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_all_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	Item_Menu_Show_and_Enable_All_Button()
	Item_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
	item_menu_title.text = tr("item_menu_consumable_items_label")
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Item_Menu_Button_Selected():
	singleton.Common_Selected()
	user_menu_skill_scrollContainer.scroll_vertical = 0
	Item_Menu_No_Description()
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_Submit():
	user_menu.show()
	battle_menu.hide()
	dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)	
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(user_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(user_menu_description)
	#-------------------------------------------------------------------------------
	var _a: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _d: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():User_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():BattleMenu_EquipButton_EquipSlot_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(user_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	var _user: Party_Member_Node = _friend_party_alive[current_player_turn]
	var _equip_serializable_array: Array[Equip_Serializable] = _user.party_member_serializable_in_battle.equip_serializable_array
	#-------------------------------------------------------------------------------
	for _i in _equip_serializable_array.size():
		var _button:Button = Create_EquipSlot_Button(_equip_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():EquipSlotMenu_EquipButton_Selected(_user, _equip_serializable_array, _i)
		var _submit_1: Callable = func():BattleMenu_EquipButton_EquipSlot_Submit(_user, _i)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_button, _selected_1, _submit_1, _cancel_0, _w, _s, _a, _d)
		user_menu_equip_button_array.append(_button)
		user_menu_equip_content.add_child(_button)
	#-------------------------------------------------------------------------------
	Create_EquipSlot_Label(_equip_serializable_array)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	User_Menu_Hide_All_Button()
	User_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button(user_menu_equip_scrollContainer, user_menu_equip_button_array, user_menu_equip_button)
	user_menu_title.text = tr("user_menu_equip_label")
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_Submit(_user:Party_Member_Node,_index:int):
	user_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(item_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(item_menu_description)
	#-------------------------------------------------------------------------------
	var _a: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _d: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():Item_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(item_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	var _empty_button: Button = Create_EquipEmpty_Button()
	#-------------------------------------------------------------------------------
	var _selected_empty: Callable = func():Item_Menu_No_Description()
	var _submit_empty: Callable = func():pass
	var _cancel_empty: Callable = func():BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(_empty_button, _selected_empty, _submit_empty, _cancel_empty, _w, _s, _a, _d)
	item_menu_equip_content.add_child(_empty_button)
	item_menu_equip_button_array.append(_empty_button)
	#-------------------------------------------------------------------------------
	var _inventory_serializable: Inventory_Serializable = inventory_serializable_in_battle
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.equip_item_array.size():
		var _button: Button = Create_EquipItem_Button(_inventory_serializable.equip_item_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():ItemMenu_Equipment_ItemButton_Selected(_inventory_serializable.equip_item_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_button, _selected_1, _submit_1, _cancel_0, _w, _s, _a, _d)
		item_menu_equip_content.add_child(_button)
		item_menu_equip_button_array.append(_button)
	#-------------------------------------------------------------------------------
	Item_Menu_Hide_All_ScrollContainer()
	Item_Menu_Hide_All_Buttons()
	item_menu_equip_button.show()
	item_menu_equip_button.disabled = true
	item_menu_equip_scrollContainer.scroll_vertical = 0
	singleton.Move_to_Button(item_menu_equip_button_array[0])
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_Cancel():
	battle_menu.show()
	Battle_Menu_StatusMenu_Exit_Common()
	singleton.Move_to_Button(battle_menu_button[4])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func BattleMenu_EquipButton_EquipSlot_EquipMenu_Cancel(_index:int):
	user_menu.show()
	BattleMenu_ItemMenu_Exit_Common()
	singleton.Move_to_Button(user_menu_equip_button_array[_index])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_Submit():
	battle_menu.hide()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		singleton.Set_Button(friend_party[_i].party_member_ui.button, func():singleton.Common_Selected(), func():BattleMenu_StatusButton_TargetButton_Submit(friend_party[_i], false), func():BattleMenu_StatusButton_TargetButton_Cancel())
		friend_party[_i].party_member_ui.button_pivot.show()
		friend_party[_i].party_member_ui.button.disabled = false
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		singleton.Set_Button(enemy_party[_i].party_member_ui.button, func():singleton.Common_Selected(), func():BattleMenu_StatusButton_TargetButton_Submit(enemy_party[_i], true), func():BattleMenu_StatusButton_TargetButton_Cancel())
		enemy_party[_i].party_member_ui.button_pivot.show()
		enemy_party[_i].party_member_ui.button.disabled = false
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(friend_party[0].party_member_ui.button)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_Submit(_user:Party_Member_Node, _is_enemy:bool):
	user_menu.show()
	dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(user_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(user_menu_description)
	#-------------------------------------------------------------------------------
	var _info_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_info_container, user_menu_info_button)
		#-------------------------------------------------------------------------------
		if(_is_enemy):
			Enable_Menu_And_Move_to_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button_array, user_menu_statuseffect_button)
			user_menu_title.text = tr("user_menu_status_effect_label")
		#-------------------------------------------------------------------------------
		else:
			Enable_Menu_And_Move_to_Button(user_menu_skill_scrollContainer, user_menu_skill_button_array, user_menu_skill_button)
			user_menu_title.text = tr("user_menu_skill_label")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _info_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_info_container, user_menu_info_button)
		Enable_Menu_And_Move_to_Button(user_menu_stats_scrollContainer, user_menu_stats_button_array, user_menu_stats_button)
		user_menu_title.text = tr("user_menu_stats_label")
	#-------------------------------------------------------------------------------
	var _stats_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_stats_scrollContainer, user_menu_stats_button)
		Enable_Menu_And_Move_to_Button_0(user_menu_info_container, user_menu_info_button)
		user_menu_title.text = tr("user_menu_info_label")
	#-------------------------------------------------------------------------------
	var _stats_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_stats_scrollContainer, user_menu_stats_button)
		Enable_Menu_And_Move_to_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button_array, user_menu_statuseffect_button)
		user_menu_title.text = tr("user_menu_status_effect_label")
	#-------------------------------------------------------------------------------
	var _statuseffect_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button)
		Enable_Menu_And_Move_to_Button(user_menu_stats_scrollContainer, user_menu_stats_button_array, user_menu_stats_button)
		user_menu_title.text = tr("user_menu_stats_label")
	#-------------------------------------------------------------------------------
	var _statuseffect_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button)
		#-------------------------------------------------------------------------------
		if(_is_enemy):
			Enable_Menu_And_Move_to_Button_0(user_menu_info_container, user_menu_info_button)
			user_menu_title.text = tr("user_menu_info_label")
		#-------------------------------------------------------------------------------
		else:
			Enable_Menu_And_Move_to_Button(user_menu_equip_scrollContainer, user_menu_equip_button_array, user_menu_equip_button)
			user_menu_title.text = tr("user_menu_equip_label")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_equip_scrollContainer, user_menu_equip_button)
		Enable_Menu_And_Move_to_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button_array, user_menu_statuseffect_button)
		user_menu_title.text = tr("user_menu_status_effect_label")
	#-------------------------------------------------------------------------------
	var _equip_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_equip_scrollContainer, user_menu_equip_button)
		Enable_Menu_And_Move_to_Button(user_menu_skill_scrollContainer, user_menu_skill_button_array, user_menu_skill_button)
		user_menu_title.text = tr("user_menu_skill_label")
	#-------------------------------------------------------------------------------
	var _skill_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_skill_scrollContainer, user_menu_skill_button)
		Enable_Menu_And_Move_to_Button(user_menu_equip_scrollContainer, user_menu_equip_button_array, user_menu_equip_button)
		user_menu_title.text = tr("user_menu_equip_label")
	#-------------------------------------------------------------------------------
	var _skill_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_skill_scrollContainer, user_menu_skill_button)
		Enable_Menu_And_Move_to_Button_0(user_menu_info_container, user_menu_info_button)
		user_menu_title.text = tr("user_menu_info_label")
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():User_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(user_menu_info_button, func():User_Menu_Info_Button_Selected(_user), _submit_0, _cancel_0, _w, _s, _info_a, _info_d)
	singleton.Set_Button_WSAD(user_menu_stats_button, _selected_0, _submit_0, _cancel_0, _w, _s, _stats_a, _stats_d)
	singleton.Set_Button_WSAD(user_menu_statuseffect_button, _selected_0, _submit_0, _cancel_0, _w, _s, _statuseffect_a, _statuseffect_d)
	singleton.Set_Button_WSAD(user_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _equip_a, _equip_d)
	singleton.Set_Button_WSAD(user_menu_skill_button, _selected_0, _submit_0, _cancel_0, _w, _s, _skill_a, _skill_d)
	#-------------------------------------------------------------------------------
	Create_Stats_Button_Array(_user.party_member_serializable, _cancel_0, _w, _s, _stats_a, _stats_d)
	#-------------------------------------------------------------------------------
	var _new_status_effect_serializable_array: Array[StatusEffect_Serializable] = Get_Status_Effect_Serializable_Array(_user)
	#-------------------------------------------------------------------------------
	for _i in _new_status_effect_serializable_array.size():
		var _statuseffect_button: Button = Create_StatusEffect_Button(_new_status_effect_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():StatusMenu_StatusEffectButton_Selected(_new_status_effect_serializable_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_statuseffect_button, _selected_1, _submit_1, _cancel_0, _w, _s, _statuseffect_a, _statuseffect_d)
		user_menu_statuseffect_content.add_child(_statuseffect_button)
		user_menu_statuseffect_button_array.append(_statuseffect_button)
	#-------------------------------------------------------------------------------
	var _equip_serializable_array: Array[Equip_Serializable] = _user.party_member_serializable_in_battle.equip_serializable_array
	#-------------------------------------------------------------------------------
	for _i in _equip_serializable_array.size():
		var _equipslot_button:Button = Create_EquipSlot_Button(_equip_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():EquipSlotMenu_EquipButton_Selected(_user, _equip_serializable_array, _i)
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_equipslot_button, _selected_1, _submit_1, _cancel_0, _w, _s, _equip_a, _equip_d)
		user_menu_equip_button_array.append(_equipslot_button)
		user_menu_equip_content.add_child(_equipslot_button)
	#-------------------------------------------------------------------------------
	Create_EquipSlot_Label(_equip_serializable_array)
	#-------------------------------------------------------------------------------
	var _skill_serializable_array: Array[Item_Serializable] = _user.party_member_serializable_in_battle.Get_Skills()
	#-------------------------------------------------------------------------------
	for _i in _skill_serializable_array.size():
		var _skill_button:Button = Create_Skill_Button(_skill_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():SkillMenu_SkillButton_Selected(_skill_serializable_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_skill_button, _selected_1, _submit_1, _cancel_0, _w, _s, _skill_a, _skill_d)
		user_menu_skill_button_array.append(_skill_button)
		user_menu_skill_content.add_child(_skill_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_stats_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_statuseffect_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_equip_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_skill_button_array)
	#-------------------------------------------------------------------------------
	User_Menu_Hide_All_ScrollContainer()
	User_Menu_Show_and_Enable_All_Button()
	#-------------------------------------------------------------------------------
	if(_is_enemy):
		user_menu_equip_button.hide()
		user_menu_skill_button.hide()
	#-------------------------------------------------------------------------------
	Enable_Menu_And_Move_to_Button_0(user_menu_info_container, user_menu_info_button)
	user_menu_title.text = tr("user_menu_info_label")
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_StatusMenu_Cancel(_user:Party_Member_Node):
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.show()
	#-------------------------------------------------------------------------------
	Battle_Menu_StatusMenu_Exit_Common()
	singleton.Move_to_Button(_user.party_member_ui.button)
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func Battle_Menu_StatusMenu_Exit_Common():
	user_menu.hide()
	dialogue_menu.show()
	dialogue_menu_button_next.hide()
	#-------------------------------------------------------------------------------
	Destroy_Button_Array(user_menu_stats_button_array)
	Destroy_Button_Array(user_menu_statuseffect_button_array)
	Destroy_Button_Array(user_menu_equip_button_array)
	Destroy_Button_Array(user_menu_skill_button_array)
#-------------------------------------------------------------------------------
func BattleMenu_StatusButton_TargetButton_Cancel():
	battle_menu.show()
	dialogue_menu.show()
	dialogue_menu_button_next.hide()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(battle_menu_button[5])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func BattleMenu_AnyButton_Cancel():
	current_player_turn -= 1
	Set_TP_Label_from_the_future()
	#-------------------------------------------------------------------------------
	if(current_player_turn < 0):
		current_player_turn = 0
		battle_menu.hide()
		dialogue_menu.show()
		win_lose_retry_escape_menu_label.text = tr("escape_menu_title")
		#-------------------------------------------------------------------------------
		for _i in win_lose_retry_escape_menu_button.size():
			win_lose_retry_escape_menu_button[_i].text = "  "+tr("escape_menu_button_"+str(_i))+"  "
		#-------------------------------------------------------------------------------
		win_lose_retry_escape_menu_label.show()
		win_lose_retry_escape_menu_vboxcontainer.show()
		singleton.Set_Button(win_lose_retry_escape_menu_button[0], func():singleton.Common_Selected(), func():RetryMenu_RetryButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		singleton.Set_Button(win_lose_retry_escape_menu_button[1], func():singleton.Common_Selected(), func():RetryMenu_EscapeButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		singleton.Set_Button(win_lose_retry_escape_menu_button[2], func():singleton.Common_Selected(), func():RetryMenu_GiveUpButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		#-------------------------------------------------------------------------------
		singleton.Move_to_Button(win_lose_retry_escape_menu_button[0])
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
		#-------------------------------------------------------------------------------
		for _i in range(current_player_turn, _friend_party_alive.size()):
			Animation_StateMachine(_friend_party_alive[_i].animation_tree, "", "Idle")
		#-------------------------------------------------------------------------------
		var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
		#-------------------------------------------------------------------------------
		for _i in _enemy_party_alive.size():
			Animation_StateMachine(_enemy_party_alive[_i].animation_tree, "Base_StateMachine/", "Idle")
		#-------------------------------------------------------------------------------
		battle_menu.global_position = _friend_party_alive[current_player_turn].party_member_ui.button_pivot.global_position
		#-------------------------------------------------------------------------------
		singleton.Move_to_First_Button(battle_menu_button)
		singleton.Common_Canceled()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SKILL MENU FUNCTIONS
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Selected(_item_serializable:Item_Serializable):
	Set_Skill_Information(_item_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func SkillMenu_SkillButton_Submit(_item_serializable:Item_Serializable, _cancel:Callable):
	#-------------------------------------------------------------------------------
	if(_item_serializable.hold > 0 or _item_serializable.item_resource.max_hold <= 0):
		#-------------------------------------------------------------------------------
		if(_item_serializable.cooldown <= 0 or _item_serializable.item_resource.max_cooldown <= 0):
			TargetMenu_Enter(_item_serializable, user_menu, _cancel)
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
	battle_menu.show()
	Battle_Menu_StatusMenu_Exit_Common()
	singleton.Move_to_Button(battle_menu_button[2])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ITEM MENU FUNCTIONS
#-------------------------------------------------------------------------------
func ItemMenu_Consumable_ItemButton_Selected(_item_serializable:Item_Serializable):
	Set_ConsumableItem_Information(_item_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func ItemMenu_Equipment_ItemButton_Selected(_equip_serializable:Equip_Serializable):
	Set_EquipItem_Information(_equip_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func ItemMenu_KeyItem_ItemButton_Selected(keyitem_serializable:Key_Item_Serializable):
	Set_KeyItem_Information(keyitem_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func EquipSlotMenu_EquipButton_Selected(_user:Party_Member_Node, _equip_serializable_array:Array[Equip_Serializable], _index: int):
	#-------------------------------------------------------------------------------
	if(_equip_serializable_array[_index].equip_resource == null):
		User_Menu_No_Description()
	#-------------------------------------------------------------------------------
	else:
		User_Menu_No_Description()
		user_menu_description.text = Set_EquipItem_Information_Common(_equip_serializable_array[_index].equip_resource)
		user_menu_description.get_v_scroll_bar().value = 0
		#-------------------------------------------------------------------------------
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func StatusMenu_StatusEffectButton_Selected(_statuseffect_serializable:StatusEffect_Serializable):
	user_menu_description.text = tr("description_"+get_resource_filename(_statuseffect_serializable.statuseffect_resource))
	user_menu_description.get_v_scroll_bar().value = 0
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func StatusMenu_StatsButton_Selected(_id:String):
	user_menu_description.text = tr("description_stat_"+_id)
	user_menu_description.get_v_scroll_bar().value = 0
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
	battle_menu.show()
	dialogue_menu.show()
	dialogue_menu_button_next.hide()
	BattleMenu_ItemMenu_Exit_Common()
	singleton.Move_to_Button(battle_menu_button[3])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func BattleMenu_ItemMenu_Exit_Common():
	item_menu.hide()
	#----------------------------------------------------------------
	Destroy_Button_Array(item_menu_all_button_array)
	Destroy_Button_Array(item_menu_consumable_button_array)
	Destroy_Button_Array(item_menu_equip_button_array)
	Destroy_Button_Array(item_menu_key_button_array)
#-------------------------------------------------------------------------------
func Destroy_Button_Array(_button_array:Array[Button]):
	for _i in _button_array.size():
		_button_array[_i].queue_free()
	#-------------------------------------------------------------------------------
	_button_array.clear()
#-------------------------------------------------------------------------------
func Destroy_Party_Button_Array(_party_button_array:Array[Party_Button]):
	for _i in _party_button_array.size():
		_party_button_array[_i].queue_free()
	#-------------------------------------------------------------------------------
	_party_button_array.clear()
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
	if(friend_party[current_player_turn].party_member_serializable.hp >= _item_serializable.item_resource.hp_cost and friend_party[current_player_turn].party_member_serializable.sp >= _item_serializable.item_resource.sp_cost and _tp >= _item_serializable.item_resource.tp_cost):
		match(_item_serializable.item_resource.myTARGET_TYPE):
			Item_Resource.TARGET_TYPE.ONE_ENEMY:
				#-------------------------------------------------------------------------------
				var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
				var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
				#-------------------------------------------------------------------------------
				if(_enemy_party_alive.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					#-------------------------------------------------------------------------------
					singleton.Disconnect_Button(dialogue_menu_button_next)
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					for _i in _enemy_party_alive.size():
						_enemy_party_alive[_i].party_member_ui.button_pivot.show()
						singleton.Set_Button(_enemy_party_alive[_i].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(_friend_party_alive, _enemy_party_alive[_i], _enemy_party_alive, _item_serializable), _cancel)
						_enemy_party_alive[_i].party_member_ui.button.disabled = false
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(_enemy_party_alive[0].party_member_ui.button)
					singleton.Common_Submited()
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.ALL_ENEMIES:
				#-------------------------------------------------------------------------------
				var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
				var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
				#-------------------------------------------------------------------------------
				if(_enemy_party_alive.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					#-------------------------------------------------------------------------------
					singleton.Set_Button(dialogue_menu_button_next, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(_friend_party_alive, _enemy_party_alive[0], _enemy_party_alive, _item_serializable), _cancel)
					dialogue_menu_button_next.show()
					dialogue_menu_button_next.disabled = false
					#-------------------------------------------------------------------------------
					for _i in _enemy_party_alive.size():
						_enemy_party_alive[_i].party_member_ui.button_pivot.show()
						_enemy_party_alive[_i].party_member_ui.button.disabled = true
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(dialogue_menu_button_next)
					singleton.Common_Submited()
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.ONE_ALLY:
				#-------------------------------------------------------------------------------
				var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
				#-------------------------------------------------------------------------------
				if(_friend_party_alive.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					#-------------------------------------------------------------------------------
					singleton.Disconnect_Button(dialogue_menu_button_next)
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					for _i in _friend_party_alive.size():
						_friend_party_alive[_i].party_member_ui.button_pivot.show()
						singleton.Set_Button(_friend_party_alive[_i].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(_friend_party_alive, _friend_party_alive[_i], _friend_party_alive, _item_serializable), _cancel)
						_friend_party_alive[_i].party_member_ui.button.disabled = false
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(_friend_party_alive[0].party_member_ui.button)
					singleton.Common_Submited()
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.ALL_ALLIES:
				#-------------------------------------------------------------------------------
				var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
				#-------------------------------------------------------------------------------
				if(_friend_party_alive.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					#-------------------------------------------------------------------------------
					singleton.Set_Button(dialogue_menu_button_next, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(_friend_party_alive, _friend_party_alive[0], _friend_party_alive, _item_serializable), _cancel)
					dialogue_menu_button_next.show()
					dialogue_menu_button_next.disabled = false
					#-------------------------------------------------------------------------------
					for _i in _friend_party_alive.size():
						_friend_party_alive[_i].party_member_ui.button_pivot.show()
						_friend_party_alive[_i].party_member_ui.button.disabled = true
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(dialogue_menu_button_next)
					singleton.Common_Submited()
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.ONE_DEAD_ALLY:
				#-------------------------------------------------------------------------------
				var _friend_party_dead: Array[Party_Member_Node] = Get_Dead_Party_Array(friend_party)
				#-------------------------------------------------------------------------------
				if(_friend_party_dead.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					#-------------------------------------------------------------------------------
					singleton.Disconnect_Button(dialogue_menu_button_next)
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					for _i in _friend_party_dead.size():
						_friend_party_dead[_i].party_member_ui.button_pivot.show()
						singleton.Set_Button(_friend_party_dead[_i].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(_friend_party_dead, _friend_party_dead[_i], _friend_party_dead, _item_serializable), _cancel)
						_friend_party_dead[_i].party_member_ui.button.disabled = false
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(_friend_party_dead[0].party_member_ui.button)
					singleton.Common_Submited()
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.ALL_DEAD_ALLIES:
				#-------------------------------------------------------------------------------
				var _friend_party_dead: Array[Party_Member_Node] = Get_Dead_Party_Array(friend_party)
				#-------------------------------------------------------------------------------
				if(_friend_party_dead.size() > 0):
					_last_menu.hide()
					dialogue_menu.show()
					dialogue_menu_button_next.hide()
					#-------------------------------------------------------------------------------
					_tp -= _item_serializable.item_resource.tp_cost
					Set_TP_Label(_tp)
					#-------------------------------------------------------------------------------
					singleton.Set_Button(dialogue_menu_button_next, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(_friend_party_dead, _friend_party_dead[0], _friend_party_dead, _item_serializable), _cancel)
					dialogue_menu_button_next.show()
					dialogue_menu_button_next.disabled = false
					#-------------------------------------------------------------------------------
					for _i in _friend_party_dead.size():
						_friend_party_dead[_i].party_member_ui.button_pivot.show()
						_friend_party_dead[_i].party_member_ui.button.disabled = true
					#-------------------------------------------------------------------------------
					singleton.Move_to_Button(dialogue_menu_button_next)
					singleton.Common_Submited()
				#-------------------------------------------------------------------------------
				else:
					singleton.Common_Canceled()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Item_Resource.TARGET_TYPE.USER:
				#-------------------------------------------------------------------------------
				var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
				#-------------------------------------------------------------------------------
				_last_menu.hide()
				dialogue_menu.show()
				dialogue_menu_button_next.hide()
				#-------------------------------------------------------------------------------
				_tp -= _item_serializable.item_resource.tp_cost
				Set_TP_Label(_tp)
				#-------------------------------------------------------------------------------
				singleton.Disconnect_Button(dialogue_menu_button_next)
				dialogue_menu_button_next.hide()
				#-------------------------------------------------------------------------------
				_friend_party_alive[current_player_turn].party_member_ui.button_pivot.show()
				singleton.Set_Button(_friend_party_alive[current_player_turn].party_member_ui.button, func():singleton.Common_Selected(), func():TargetMenu_TargetButton_Submit(_friend_party_alive, _friend_party_alive[current_player_turn], _friend_party_alive, _item_serializable), _cancel)
				_friend_party_alive[current_player_turn].party_member_ui.button.disabled = false
				#-------------------------------------------------------------------------------
				singleton.Move_to_Button(_friend_party_alive[current_player_turn].party_member_ui.button)
				singleton.Common_Submited()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------	
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Submit(_user_party:Array[Party_Member_Node], _target:Party_Member_Node, _target_party:Array[Party_Member_Node], _item_serializable:Item_Serializable):	
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	_friend_party_alive[current_player_turn].user_party = _user_party
	_friend_party_alive[current_player_turn].target = _target
	_friend_party_alive[current_player_turn].target_party = _target_party
	_friend_party_alive[current_player_turn].item_serializable = _item_serializable
	#-------------------------------------------------------------------------------
	Animation_StateMachine(_friend_party_alive[current_player_turn].animation_tree, "", _item_serializable.item_resource.anim)
	#-------------------------------------------------------------------------------
	Destroy_Button_Array(item_menu_all_button_array)
	Destroy_Button_Array(item_menu_consumable_button_array)
	Destroy_Button_Array(item_menu_equip_button_array)
	Destroy_Button_Array(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	Destroy_Button_Array(user_menu_stats_button_array)
	Destroy_Button_Array(user_menu_statuseffect_button_array)
	Destroy_Button_Array(user_menu_equip_button_array)
	Destroy_Button_Array(user_menu_skill_button_array)
	#-------------------------------------------------------------------------------
	After_Choose_Target_Logic()
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Cancel():
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	_friend_party_alive[current_player_turn].user_party = []
	_friend_party_alive[current_player_turn].target = null
	_friend_party_alive[current_player_turn].target_party = []
	_friend_party_alive[current_player_turn].item_serializable = null
	#-------------------------------------------------------------------------------
	Hide_AllTarget()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region AFTER MENU ACTIONS
#-------------------------------------------------------------------------------
func After_Choose_Target_Logic():
	Hide_AllTarget()
	current_player_turn += 1
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	if(current_player_turn < _friend_party_alive.size()):
		#-------------------------------------------------------------------------------
		battle_menu.global_position = _friend_party_alive[current_player_turn].party_member_ui.button_pivot.global_position
		battle_menu.show()
		dialogue_menu.show()
		dialogue_menu_button_next.hide()
		singleton.Move_to_First_Button(battle_menu_button)
		singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Submited()
		dialogue_signal.emit()
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
	dialogue_menu_button_next.hide()
#-------------------------------------------------------------------------------
func Seconds(_timer:float):
	await get_tree().create_timer(_timer, true, true).timeout
#-------------------------------------------------------------------------------
func Party_Actions():
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE != BATTLE_STATE.STILL_FIGHTING):
		return
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	current_player_turn = _friend_party_alive.size()
	Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
	#-------------------------------------------------------------------------------
	var _player_alive_attacking: Array[Party_Member_Node] = []
	var _player_alive_defending: Array[Party_Member_Node] = []
	var _player_alive_using_skill_or_item: Array[Party_Member_Node] = []
	#-------------------------------------------------------------------------------
	for _i in _friend_party_alive.size():
		#-------------------------------------------------------------------------------
		match(_friend_party_alive[_i].item_serializable.item_resource):
			attack_skill_resource:
				_player_alive_attacking.append(_friend_party_alive[_i])
			#-------------------------------------------------------------------------------
			guard_skill_resource:
				_player_alive_defending.append(_friend_party_alive[_i])
			#-------------------------------------------------------------------------------
			_:
				_player_alive_using_skill_or_item.append(_friend_party_alive[_i])
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await Do_Defence_Minigame(_player_alive_defending)
	#-------------------------------------------------------------------------------
	for _i in _player_alive_using_skill_or_item.size():
		#-------------------------------------------------------------------------------
		Set_Players_and_Enemies_before_action()
		#-------------------------------------------------------------------------------
		var _user: Party_Member_Node = _player_alive_using_skill_or_item[_i]
		Set_Target_Avalible(_user)
		#-------------------------------------------------------------------------------
		if(_user.target != null):
			dialogue_menu.show()
			dialogue_menu_button_next.hide()
			var _user_name: String = "[color="+hex_color_orange+"]"+tr("name_"+get_instance_filename(_user))+"[/color]"
			var _item_name: String = "[color="+hex_color_yellow+"]"+ tr("name_"+get_resource_filename(_user.item_serializable.item_resource))+"[/color]"
			var _target_name: String = "[color="+hex_color_orange+"]"+tr("name_"+get_instance_filename(_user.target))+"[/color]"
			dialogue_menu_speaking_label.text = "* "+_user_name+ " uses " +_item_name+ " on " +_target_name + "."
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
	for _i in _friend_party_alive.size():
		#-------------------------------------------------------------------------------
		if(Has_Status_Effect_Guard(_friend_party_alive[_i])):
			Animation_StateMachine(_friend_party_alive[_i].animation_tree, "", "Crouch")
		#-------------------------------------------------------------------------------
		else:
			Animation_StateMachine(_friend_party_alive[_i].animation_tree, "", "Idle")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
	#-------------------------------------------------------------------------------
	for _i in range(enemy_party.size()-1,-1,-1):
		var _enemy: Party_Member_Node = enemy_party[_i]
		#-------------------------------------------------------------------------------
		if(_enemy.party_member_serializable.hp <= 0 and _enemy.disappears_when_dies):
			enemy_party.erase(_enemy)
			_enemy.party_member_ui.hide()
			_enemy.hide()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _enemy_party_alive.size():
		Animation_StateMachine(_enemy_party_alive[_i].animation_tree, "Base_StateMachine/", "Idle")
	#-------------------------------------------------------------------------------
	if(_enemy_party_alive.size() > 0):
		#-------------------------------------------------------------------------------
		if(_friend_party_alive.size() > 0):
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
func Set_Target_Avalible(_user:Party_Member_Node):
	#-------------------------------------------------------------------------------
	match(_user.item_serializable.item_resource.myTARGET_TYPE):
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ONE_ENEMY:
			#-------------------------------------------------------------------------------
			if(_user.target.party_member_serializable.hp > 0):
				pass
			#-------------------------------------------------------------------------------
			else:
				var _target_array_alive: Array[Party_Member_Node] = []
				#-------------------------------------------------------------------------------
				for _i in _user.target_party.size():
					#-------------------------------------------------------------------------------
					if(_user.target_party[_i].party_member_serializable.hp > 0):
						_target_array_alive.append(_user.target_party[_i])
					#-------------------------------------------------------------------------------
				#-------------------------------------------------------------------------------
				if(_target_array_alive.size() > 0):
					_user.target = _target_array_alive[0]
					#-------------------------------------------------------------------------------
					for _i in _target_array_alive.size():
						#-------------------------------------------------------------------------------
						if(_target_array_alive[_i].party_member_serializable.hp < _user.target.party_member_serializable.hp):
							_user.target = _target_array_alive[_i]
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
				#-------------------------------------------------------------------------------
				else:
					_user.target = null
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ONE_ALLY:
			pass
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ONE_DEAD_ALLY:
			pass
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.USER:
			pass
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Player_Action(_user:Party_Member_Node):
	#-------------------------------------------------------------------------------
	if(_user.target == null):
		return
	#-------------------------------------------------------------------------------
	_user.item_serializable.hold -= 1
	_user.item_serializable.cooldown = _user.item_serializable.item_resource.max_cooldown + 1
	#-------------------------------------------------------------------------------
	_user.party_member_serializable.hp -= _user.item_serializable.item_resource.hp_cost
	_user.party_member_serializable.sp -= _user.item_serializable.item_resource.sp_cost
	tp -= _user.item_serializable.item_resource.tp_cost
	#-------------------------------------------------------------------------------
	Set_HP_Label(_user)
	Set_SP_Label(_user)
	Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
	var _action_string: StringName = get_resource_filename(_user.item_serializable.item_resource)
	await call(_action_string, _user)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Defence_Minigame(_player_alive_defending: Array[Party_Member_Node]):
	if(_player_alive_defending.size() > 0):
		Set_Players_and_Enemies_before_action()
		#-------------------------------------------------------------------------------
		for _i in _player_alive_defending.size():
			await Seconds(0.1)
			await Do_Player_Action(_player_alive_defending[_i])
		#-------------------------------------------------------------------------------
		await Seconds(0.5)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Attack_Minigame(_attacking_party: Array[Party_Member_Node]):
	if(_attacking_party.size() > 0):
		Set_Players_and_Enemies_before_action()
		#-------------------------------------------------------------------------------
		var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
		#-------------------------------------------------------------------------------
		if(_enemy_party_alive.size() > 0):
			dialogue_menu.show()
			dialogue_menu_button_next.hide()
			dialogue_menu_speaking_label.text = "* Normal Attack Minigame."
			await Seconds(0.5)
			#-------------------------------------------------------------------------------
			for _i in _attacking_party.size():
				Set_Target_Avalible(_attacking_party[_i])
				#-------------------------------------------------------------------------------
				if(_attacking_party[_i].target != null):
					await Seconds(0.1)
					await Do_Player_Action(_attacking_party[_i])
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			await Seconds(0.5)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Start_BulletHell(_callable: Callable, _timer:int):
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE != BATTLE_STATE.STILL_FIGHTING):
		return
	#-------------------------------------------------------------------------------
	can_be_hit = true
	Animation_Transition(hitbox_animation_tree, "Transition/", "Normal")
	#-------------------------------------------------------------------------------
	dialogue_menu.hide()
	#dialogue_menu_speaking_label.text = ""
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
	var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
	#-------------------------------------------------------------------------------
	for _i in _enemy_party_alive.size():
		Animation_StateMachine(_enemy_party_alive[_i].animation_tree, "Base_StateMachine/", "Aim")
		_enemy_party_alive[_i].party_member_ui.dialogue_root.show()
	#-------------------------------------------------------------------------------
	await Move_Fighters_to_Position_2(false)
	await Seconds(1.0)
	#-------------------------------------------------------------------------------
	battle_box.show()
	hitbox.global_position = battle_box.global_position + battle_box.size/2.0
	myGAME_STATE = GAME_STATE.IN_BATTLE
	#-------------------------------------------------------------------------------
	for _i in _enemy_party_alive.size():
		_enemy_party_alive[_i].party_member_ui.dialogue_root.hide()
	#-------------------------------------------------------------------------------
	_callable.call()
	await TimeOut_Tween(_timer)
	#-------------------------------------------------------------------------------
	myGAME_STATE = GAME_STATE.IN_MENU
	current_player_turn = 0
	var _inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in range(inventory_serializable_in_battle.consumable_item_array.size()-1, -1, -1):
		#-------------------------------------------------------------------------------
		if(inventory_serializable_in_battle.consumable_item_array[_i].hold <= 0):
			inventory_serializable_in_battle.consumable_item_array[_i].hold = 0
			#-------------------------------------------------------------------------------
			if(inventory_serializable_in_battle.consumable_item_array[_i].stored <= 0):
				inventory_serializable_in_battle.consumable_item_array.remove_at(_i)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			inventory_serializable_in_battle.consumable_item_array[_i].cooldown -= 1
			#-------------------------------------------------------------------------------
			if(inventory_serializable_in_battle.consumable_item_array[_i].cooldown < 0):
				inventory_serializable_in_battle.consumable_item_array[_i].cooldown = 0
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	battle_box.hide()
	await Status_Effect_Action_When_Turn_Start()
	await Status_Effect_Action_When_Turn_Start_and_Status_Effect_is_Removed()
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	if(_enemy_party_alive.size() > 0):
		#-------------------------------------------------------------------------------
		if(_friend_party_alive.size() > 0):
			Animation_Transition(hitbox_animation_tree, "Transition/", "Normal")
			myGAME_STATE = GAME_STATE.IN_MENU
			#-------------------------------------------------------------------------------
			await Move_Fighters_to_Position_2(true)
			#await Seconds(0.25)
			#-------------------------------------------------------------------------------
			dialogue_menu_speaking_label.text = "* The Battle began!"
			dialogue_menu_button_next.hide()
			dialogue_menu.show()
			#-------------------------------------------------------------------------------
			battle_menu.global_position = _friend_party_alive[current_player_turn].party_member_ui.button_pivot.global_position
			battle_menu.show()
			singleton.Move_to_First_Button(battle_menu_button)
			singleton.Common_Submited()
		#-------------------------------------------------------------------------------
		else:
			myBATTLE_STATE = BATTLE_STATE.YOU_LOSE
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		myBATTLE_STATE = BATTLE_STATE.YOU_WIN
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func You_Win():
	#-------------------------------------------------------------------------------
	Set_AllItems_When_Exit_Battle()
	Fill_the_ConsumableItems_Hold_from_Stored_and_Remove_Cooldown()
	ReFill_All_Skills()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		Set_All_User_Skills_Equip_StatusEffect_When_Exit_Battle(friend_party[_i])
	#-------------------------------------------------------------------------------
	await Move_Fighters_to_Position_2(true)
	#-------------------------------------------------------------------------------
	dialogue_menu_speaking_label.text = "* Yay! You Won 1000 gold and an a cool weapon."
	dialogue_menu.show()
	win_lose_retry_escape_menu_label.text = tr("win_menu_title")
	win_lose_retry_escape_menu_vboxcontainer.hide()
	win_lose_retry_escape_menu_label.show()
	#-------------------------------------------------------------------------------
	await Seconds(2.0)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.hide()
		friend_party[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.hide()
		enemy_party[_i].party_member_ui.button_pivot.hide()
		enemy_party[_i].party_member_ui.queue_free()
	#-------------------------------------------------------------------------------
	tp_bar_root.hide()
	#-------------------------------------------------------------------------------
	win_lose_retry_escape_menu_label.hide()
	dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].z_index = 0
		Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
		friend_party[_i].is_Moving = false
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].z_index = 0
	#-------------------------------------------------------------------------------
	battle_black_panel.hide()
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_interval(0.5)
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		_tween.parallel().tween_property(friend_party[_i], "global_position", player_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _new_global_position: Vector2 = Vector2(enemy_party[_i].global_position.x+150, enemy_party[_i].global_position.y)
		_tween.parallel().tween_property(enemy_party[_i], "global_position", _new_global_position, 0.5)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		singleton.Play_BGM(singleton.stage1)
		myGAME_STATE = GAME_STATE.IN_WORLD
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region RETRY MENU FUNCTIONS
#-------------------------------------------------------------------------------
func RetryMenu_RetryButton_Submit():
	myBATTLE_STATE = BATTLE_STATE.YOU_RETRY
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func You_Retry(_enemy_array:Array[Party_Member_Node]):
	#-------------------------------------------------------------------------------
	enemy_party.clear()
	#-------------------------------------------------------------------------------
	for _i in _enemy_array.size():
		enemy_party.append(_enemy_array[_i])
	#-------------------------------------------------------------------------------
	win_lose_retry_escape_menu_vboxcontainer.hide()
	win_lose_retry_escape_menu_label.hide()
	#dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	black_panel_on_top_of_everithing.self_modulate = Color.TRANSPARENT
	_tween.tween_property(black_panel_on_top_of_everithing, "self_modulate", Color.BLACK, 0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		#-------------------------------------------------------------------------------
		for _i in _enemy_array.size():
			_enemy_array[_i].show()
			_enemy_array[_i].party_member_ui.show()
			_enemy_array[_i].party_member_ui.button_pivot.hide()
		#-------------------------------------------------------------------------------
		Set_AllItems_When_Enter_Battle()
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			#-------------------------------------------------------------------------------
			Set_All_User_Skills_Equip_StatusEffect_When_Enter_Battle(friend_party[_i])
			#-------------------------------------------------------------------------------
			Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
			#-------------------------------------------------------------------------------
			var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(friend_party[_i].party_member_serializable, "max_hp")
			friend_party[_i].party_member_serializable.hp = _max_hp
			Set_HP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].party_member_serializable.sp = 0
			Set_SP_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			Set_Status_Effect_Label(friend_party[_i])
			#-------------------------------------------------------------------------------
			friend_party[_i].item_serializable = null
			#-------------------------------------------------------------------------------
			friend_party[_i].party_member_ui.show()
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			#-------------------------------------------------------------------------------
			Set_All_User_Skills_Equip_StatusEffect_When_Enter_Battle(enemy_party[_i])
			#-------------------------------------------------------------------------------
			Animation_StateMachine(enemy_party[_i].animation_tree, "Base_StateMachine/", "Idle")
			#-------------------------------------------------------------------------------
			var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(enemy_party[_i].party_member_serializable, "max_hp")
			enemy_party[_i].party_member_serializable.hp = _max_hp
			Set_HP_Label(enemy_party[_i])
			#-------------------------------------------------------------------------------
			Set_Status_Effect_Label(enemy_party[_i])
			#-------------------------------------------------------------------------------
			enemy_party[_i].party_member_ui.show()
		#-------------------------------------------------------------------------------
		Set_Starting_TP()
		#-------------------------------------------------------------------------------
		current_player_turn = 0
		battle_menu.global_position = friend_party[0].party_member_ui.button_pivot.global_position
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
	#_tween.tween_interval(0.05)
	Move_Fighters_to_Position(_tween, true, 0.05)
	#-------------------------------------------------------------------------------
	_tween.tween_property(black_panel_on_top_of_everithing, "self_modulate", Color.TRANSPARENT, 0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		battle_menu.show()
		dialogue_menu.show()
		dialogue_menu_button_next.hide()
		#-------------------------------------------------------------------------------
		singleton.Move_to_First_Button(battle_menu_button)
		singleton.Common_Submited()
		#-------------------------------------------------------------------------------
		myBATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func RetryMenu_EscapeButton_Submit():
	myBATTLE_STATE = BATTLE_STATE.YOU_ESCAPE
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func RetryMenu_GiveUpButton_Submit():
	get_tree().reload_current_scene()
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func RetryMenu_AnyButton_Cancel():
	battle_menu.show()
	dialogue_menu.show()
	dialogue_menu_button_next.hide()
	win_lose_retry_escape_menu_label.hide()
	win_lose_retry_escape_menu_vboxcontainer.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_First_Button(battle_menu_button)
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func You_Escape():
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_ui.hide()
		Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
		friend_party[_i].is_Moving = false
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].party_member_ui.hide()
		#Animation_StateMachine(enemy_party[_i].animation_tree, "Base_StateMachine/", "Idle")
		enemy_party[_i].is_Moving = false
		enemy_party[_i].party_member_ui.queue_free()
	#-------------------------------------------------------------------------------
	win_lose_retry_escape_menu_label.hide()
	win_lose_retry_escape_menu_vboxcontainer.hide()
	dialogue_menu.hide()
	tp_bar_root.hide()
	singleton.audioStreamPlayer_escape.play()
	#-------------------------------------------------------------------------------
	Invincible_after_escape()
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	#_tween.tween_interval(1.0)
	for _i in friend_party.size():
		_tween.parallel().tween_property(friend_party[_i], "global_position", player_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _new_global_position: Vector2 = Vector2(enemy_party[_i].global_position.x+100, enemy_party[_i].global_position.y)
		_tween.parallel().tween_property(enemy_party[_i], "global_position", _new_global_position, 0.5)
	#-------------------------------------------------------------------------------
	_tween.tween_interval(0.3)
	_tween.tween_callback(func():
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			friend_party[_i].z_index = 0
		#-------------------------------------------------------------------------------
		for _i in enemy_party.size():
			enemy_party[_i].z_index = 0
		#-------------------------------------------------------------------------------
		battle_black_panel.hide()
		myGAME_STATE = GAME_STATE.IN_WORLD
		singleton.Play_BGM(singleton.stage1)
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Invincible_after_escape():
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		can_enter_fight = false
	)
	#-------------------------------------------------------------------------------
	_tween.tween_interval(3.0)
	_tween.tween_callback(func():
		can_enter_fight = true
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
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
		#-------------------------------------------------------------------------------
		_tween.tween_callback(func():
			timer-=1
			PrintTimer(timer, _iMax)
		)
		#-------------------------------------------------------------------------------
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
	timer_label.text = "   "+str(_i).pad_zeros(2)+"/" +str(_iMax).pad_zeros(2) + " s"
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
	_bullet.global_position.x += _bullet.vel_X * deltaTimeScale
	_bullet.global_position.y += _bullet.vel_Y * deltaTimeScale
	return
	#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SPELLCARD FUNCTIONS
func Set_Difficulty() -> float:
	#return enemy_party.size() - enemy_party_alive.size()
	var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
	return 3.0 - _enemy_party_alive.size()
#-------------------------------------------------------------------------------
func Stage1_Fire2():
	var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	var _mirror = 1
	#-------------------------------------------------------------------------------
	var _tween: Tween = CreateTween_ArrayAppend(main_tween_Array)
	_tween.set_loops()
	#-------------------------------------------------------------------------------
	for _j in 2:
		#-------------------------------------------------------------------------------
		for _i in _enemy_party_alive.size():
			_tween.tween_callback(func():
				Animation_StateMachine(_enemy_party_alive[_i].animation_tree, "Base_StateMachine/", "Shot")
				Stage1_Fire2_Bullet1(_enemy_party_alive[_i], _mirror)
			)
			_tween.tween_interval(1.0+1.2*_difficulty)
			_mirror *= -1
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Stage1_Fire2_Bullet1(_user:Party_Member_Node, _mirror:float):
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	#-------------------------------------------------------------------------------
	var _max1: float = 10 + 2*_difficulty
	var _max2: float = 10 + 5*_difficulty
	#-------------------------------------------------------------------------------
	var _x: float = camera.global_position.x+camera_center.x*0.5 * _mirror
	var _y: float = camera.global_position.y-camera_center.y*0.5
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
	var _tween: Tween = CreateTween_ArrayAppend(_bullet.tween_Array)
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
	var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	var _mirror = 1
	#-------------------------------------------------------------------------------
	var _tween: Tween = CreateTween_ArrayAppend(main_tween_Array)
	_tween.set_loops()
	#-------------------------------------------------------------------------------
	for _j in 2:
		#-------------------------------------------------------------------------------
		for _i in _enemy_party_alive.size():
			_tween.tween_callback(func():
				Animation_StateMachine(_enemy_party_alive[_i].animation_tree, "Base_StateMachine/", "Shot")
				Stage1_Fire1_Bullet1(_enemy_party_alive[_i], _mirror)
			)
			_tween.tween_interval(0.8+0.6*_difficulty)
			_mirror *= -1
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Stage1_Fire1_Bullet1(_user:Party_Member_Node, _mirror:float):
	#-------------------------------------------------------------------------------
	var _difficulty: float = Set_Difficulty()
	#-------------------------------------------------------------------------------
	var _max1: float = 10 + 5*_difficulty
	var _max2: float = 5 + 2*_difficulty
	#-------------------------------------------------------------------------------
	var _x: float = camera.global_position.x+camera_center.x*0.25 * _mirror
	var _y: float = camera.global_position.y-camera_center.y*0.65
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
			Animation_Transition(hitbox_animation_tree, "Transition/", "Normal")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Player_Shooted():
	#-------------------------------------------------------------------------------
	i_frames = 30
	can_be_hit = false
	Animation_Transition(hitbox_animation_tree, "Transition/", "Hurt")
	#-------------------------------------------------------------------------------
	var _friend_party_alive:Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	if(_friend_party_alive.size() > 0):
		var _target: Party_Member_Node = _friend_party_alive.pick_random()
		var _int: int
		#-------------------------------------------------------------------------------
		if(Has_Status_Effect_Guard(_target)):
			_int = 5
		#-------------------------------------------------------------------------------
		else:
			_int = 10
		#-------------------------------------------------------------------------------
		_target.party_member_serializable.hp -= _int
		#-------------------------------------------------------------------------------
		Flying_PopUp(_target, "-"+str(_int)+" HP")
		#-------------------------------------------------------------------------------
		if(_target.party_member_serializable.hp > 0):
			Player_Receive_Status_Effect(_target)
			#-------------------------------------------------------------------------------
			if(Has_Status_Effect_Guard(_target)):
				Animation_StateMachine(_target.animation_tree, "", "Crouch_Hurt")
			#-------------------------------------------------------------------------------
			else:
				Animation_StateMachine(_target.animation_tree, "", "Hurt")
			#-------------------------------------------------------------------------------
			Set_HP_Label(_target)
			singleton.audioStreamPlayer_ally_damage.play()
		#-------------------------------------------------------------------------------
		else:
			User_Got_KnockDown(_target)
			#-------------------------------------------------------------------------------
			Animation_StateMachine(_target.animation_tree, "", "Death")
			#-------------------------------------------------------------------------------
			_friend_party_alive.erase(_target)
			#-------------------------------------------------------------------------------
			if(_friend_party_alive.size() <= 0):
				StopEverithing_and_Timer()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	else:
		StopEverithing_and_Timer()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Player_Receive_Status_Effect(_user:Party_Member_Node):
	var _status_effect_name: StringName = "status_damage_3"
	#-------------------------------------------------------------------------------
	if(Has_Status_Effect(_user, _status_effect_name)):
		return
	#-------------------------------------------------------------------------------
	var _chance: int = randi_range(0, 100)
	#-------------------------------------------------------------------------------
	if(_chance >= 0):
		var status_effect_resource: StatusEffect_Resource = Get_StatusEffect_Resource(_status_effect_name)
		#-------------------------------------------------------------------------------
		Add_Status_Effect(_user, status_effect_resource, status_effect_resource.max_hold)
		Flying_PopUp(_user, "+"+tr("name_"+_status_effect_name))
	#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Flying_PopUp(_user:Party_Member_Node, _s:String):
	var _is_enemy:bool
	#-------------------------------------------------------------------------------
	if(friend_party.has(_user)):
		_is_enemy = false
	#-------------------------------------------------------------------------------
	else:
		_is_enemy = true
	#-------------------------------------------------------------------------------
	var _popup: PopUp_UI = Spawn_Label_in_User(_user, _is_enemy)
	await Flying_PopUp_Actions(_popup, _s, _is_enemy)
#-------------------------------------------------------------------------------
func Spawn_Label_in_User(_user:Party_Member_Node, _is_enemy:bool) -> PopUp_UI:
	#-------------------------------------------------------------------------------
	for _i in _user.damage_label_array.size():
		#-------------------------------------------------------------------------------
		if(_user.damage_label_array[_i] == null):
			var _popup: PopUp_UI = Spawn_Label_in_User_2(_user, _is_enemy, _i)
			_user.damage_label_array[_i] = _popup
			return _popup
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _popup_2: PopUp_UI = Spawn_Label_in_User_2(_user, _is_enemy, _user.damage_label_array.size())
	_user.damage_label_array.append(_popup_2)
	return _popup_2
#-------------------------------------------------------------------------------
func Spawn_Label_in_User_2(_user:Party_Member_Node, _is_enemy:bool, _index:int) -> PopUp_UI:
	var _popup: PopUp_UI
	#-------------------------------------------------------------------------------
	if(_is_enemy):
		_popup = enemy_popup_prefab.instantiate() as PopUp_UI
	#-------------------------------------------------------------------------------
	else:
		_popup = ally_popup_prefab.instantiate() as PopUp_UI
	#-------------------------------------------------------------------------------
	var _global_position: Vector2 = _user.global_position
	_global_position.y -= 8.0 * float(_index)
	_user.add_child(_popup)
	_popup.global_position = _global_position
	return _popup
#-------------------------------------------------------------------------------
func You_Lose():
	timer_tween.kill()
	battle_box.hide()
	#-------------------------------------------------------------------------------
	await Seconds(1.0)
	await Move_Fighters_to_Position_2(true)
	#-------------------------------------------------------------------------------
	win_lose_retry_escape_menu_label.text = tr("lose_menu_title")
	win_lose_retry_escape_menu_label.show()
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	for _i in win_lose_retry_escape_menu_button.size():
		win_lose_retry_escape_menu_button[_i].text = "  "+tr("escape_menu_button_"+str(_i))+"  "
	#-------------------------------------------------------------------------------
	win_lose_retry_escape_menu_vboxcontainer.show()
	singleton.Set_Button(win_lose_retry_escape_menu_button[0], func():singleton.Common_Selected(), func():LoseMenu_RetryButton_Submit(), func():pass)
	singleton.Set_Button(win_lose_retry_escape_menu_button[1], func():singleton.Common_Selected(), func():LoseMenu_EscapeButton_Submit(), func():pass)
	singleton.Set_Button(win_lose_retry_escape_menu_button[2], func():singleton.Common_Selected(), func():LoseMenu_GiveUpButton_Submit(), func():pass)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(win_lose_retry_escape_menu_button[0])
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	await dialogue_signal
#-------------------------------------------------------------------------------
func LoseMenu_RetryButton_Submit():
	myBATTLE_STATE = BATTLE_STATE.YOU_RETRY
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func LoseMenu_EscapeButton_Submit():
	myBATTLE_STATE = BATTLE_STATE.YOU_ESCAPE
	dialogue_signal.emit()
#-------------------------------------------------------------------------------
func LoseMenu_GiveUpButton_Submit():
	get_tree().reload_current_scene()
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Bullet_Grazed_SP_Gain():
	var _target_party: Array[Party_Member_Node] = []
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	#-------------------------------------------------------------------------------
	for _i in _friend_party_alive.size():
		var _max_sp: int = Get_Party_Member_Calculated_Base_Stat(_friend_party_alive[_i].party_member_serializable, "max_sp")
		#-------------------------------------------------------------------------------
		if(_friend_party_alive[_i].party_member_serializable.sp < _max_sp):
			_target_party.append(_friend_party_alive[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(_target_party.size() > 0):
		_target_party.shuffle()
		_target_party[0].party_member_serializable.sp += 1
		SP_Gain_VisualEffect(_target_party[0].global_position)
		#-------------------------------------------------------------------------------
		var _max_sp: int = Get_Party_Member_Calculated_Base_Stat(_target_party[0].party_member_serializable, "max_sp")
		#-------------------------------------------------------------------------------
		if(_target_party[0].party_member_serializable.sp > _max_sp):
			_target_party[0].party_member_serializable.sp = _max_sp
		#-------------------------------------------------------------------------------
		Set_SP_Label(_target_party[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Bullet_Grazed_TP_Gain():
	var _max_tp: int = Get_Max_TP()
	tp += 1
	#-------------------------------------------------------------------------------
	if(tp > _max_tp):
		tp = _max_tp
	#-------------------------------------------------------------------------------
	else:
		singleton.audioStreamPlayer_graze.play()
		Animation_OneShot(hitbox_animation_tree, "OneShot", AnimationNodeOneShot.OneShotRequest.ONE_SHOT_REQUEST_FIRE)
		Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Gain_Tp(_int:int):
	var _max_tp: int = Get_Max_TP()
	tp += _int
	#-------------------------------------------------------------------------------
	if(tp > _max_tp):
		tp = _max_tp
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PARTY_SKILLS CALLABLES
#-------------------------------------------------------------------------------
func skill_damage_0(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_normal_attack")
	#-------------------------------------------------------------------------------
	Gain_Tp(5)
	Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
	HP_Damage(_user.target, 5)
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func skill_damage_1(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_poison")
	#-------------------------------------------------------------------------------
	var _status_effect_name: StringName = "status_damage_1"
	var _status_effect: StatusEffect_Resource = Get_StatusEffect_Resource(_status_effect_name)
	#-------------------------------------------------------------------------------
	Add_Status_Effect(_user.target, _status_effect, 3)
	Flying_PopUp(_user.target, "+"+tr("name_"+_status_effect_name))
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func Get_StatusEffect_Resource(_status_effect_name:StringName) -> StatusEffect_Resource:
	var _status_effect: StatusEffect_Resource = load(user_status_effect_resource_path+_status_effect_name+".tres") as StatusEffect_Resource
	return _status_effect
#-------------------------------------------------------------------------------
func skill_damage_2(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_heavy_bullet")
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
	#-------------------------------------------------------------------------------
	HP_Damage(_user.target, 5)
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func skill_damage_3(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_skill_1")
	#-------------------------------------------------------------------------------
	for _i in 2:
		await Seconds(0.1)
		HP_Damage(_user.target, 5)
	#-------------------------------------------------------------------------------	
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func skill_damage_4(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_skill_1")
	#-------------------------------------------------------------------------------
	for _i in 4:
		await Seconds(0.1)
		HP_Damage(_user.target, 5)
	#-------------------------------------------------------------------------------	
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func skill_damage_5(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	#-------------------------------------------------------------------------------
	for _i in _user.target_party.size():
		Play_AttackAnimation(_user.target_party[_i], "anim_skill_1")
		#-------------------------------------------------------------------------------
		var _callable: Callable = func():
			#-------------------------------------------------------------------------------
			for _j in 4:
				await Seconds(0.1)
				HP_Damage(_user.target_party[_i], 5)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		await Seconds(0.15)
		_callable.call()
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func skill_heal_0(_user:Party_Member_Node):
	Gain_Tp(5)
	Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
	var _status_effect_resource_name: StringName = "status_heal_0"
	var _status_effect_resource: StatusEffect_Resource = load(user_status_effect_resource_path+_status_effect_resource_name+".tres") as StatusEffect_Resource
	Add_Status_Effect(_user, _status_effect_resource, 0)
	Flying_PopUp(_user, "+"+tr("name_"+_status_effect_resource_name))
#-------------------------------------------------------------------------------
func skill_heal_1(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_healing")
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
	#-------------------------------------------------------------------------------
	if(_user.target.party_member_serializable.hp <= 0):
		Animation_StateMachine(_user.target.animation_tree, "", "Idle")
	#-------------------------------------------------------------------------------
	HP_Heal_Porcentual(_user.target, 1.0)
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func skill_heal_2(_user:Party_Member_Node):
	skill_heal_1(_user)
#-------------------------------------------------------------------------------
func skill_heal_3(_user:Party_Member_Node):
	#-------------------------------------------------------------------------------
	for _i in _user.user_party.size():
		#-------------------------------------------------------------------------------
		if(_user.user_party[_i].party_member_serializable.hp > 0):
			await Seconds(0.1)
			var _status_effect_resource_name: StringName = "status_heal_0"
			var _status_effect_resource: StatusEffect_Resource = load(user_status_effect_resource_path+_status_effect_resource_name+".tres") as StatusEffect_Resource
			Add_Status_Effect(_user.user_party[_i], _status_effect_resource, 0)
			Flying_PopUp(_user.user_party[_i], "+"+tr("name_"+_status_effect_resource_name))
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await Seconds(0.1)
#-------------------------------------------------------------------------------
func skill_heal_4(_user:Party_Member_Node):
	skill_heal_1(_user)
#-------------------------------------------------------------------------------
func Play_AttackAnimation(_user:Party_Member_Node, _name: String):
	#-------------------------------------------------------------------------------
	var _animation_effect: Animation_Effect = load(skill_animation_effect_path+_name+".tscn").instantiate() as Animation_Effect
	_animation_effect.animation_player.play("action")
	_animation_effect.z_index = 2
	_animation_effect.global_position = _user.global_position
	#-------------------------------------------------------------------------------
	world_2d.add_child(_animation_effect)
	await _animation_effect.animation_player.animation_finished
	_animation_effect.queue_free()
#-------------------------------------------------------------------------------
func Add_Status_Effect(_user:Party_Member_Node, _status_effect:StatusEffect_Resource, _int:int):
	#-------------------------------------------------------------------------------
	var _status_effect_serializable_array: Array[StatusEffect_Serializable] = _user.party_member_serializable_in_battle.status_effect_serializable_array
	#-------------------------------------------------------------------------------
	for _i in _status_effect_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_status_effect_serializable_array[_i].statuseffect_resource == _status_effect):
			_status_effect_serializable_array[_i].stored += _int + 1
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _status_effect_serializable: StatusEffect_Serializable = StatusEffect_Serializable.new()
	_status_effect_serializable.statuseffect_resource = _status_effect
	_status_effect_serializable.stored = _int + 1
	_status_effect_serializable_array.append(_status_effect_serializable)
	#-------------------------------------------------------------------------------
	Set_Skills_in_Status_Effect_Serializable_when_is_Applied(_status_effect_serializable)
	#-------------------------------------------------------------------------------
	Set_TP_Label(tp)
	Set_Status_Effect_Label(_user)
	#-------------------------------------------------------------------------------
	return
#-------------------------------------------------------------------------------
func Set_Skills_in_Status_Effect_Serializable_when_is_Applied(_status_effect_serializable:StatusEffect_Serializable):
	var _status_effect_resource: StatusEffect_Resource = _status_effect_serializable.statuseffect_resource
	#-------------------------------------------------------------------------------
	_status_effect_serializable.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in _status_effect_resource.skill_resource_array.size():
		var _skill_serializable: Item_Serializable = Item_Serializable.new()
		#-------------------------------------------------------------------------------
		_skill_serializable.item_resource = _status_effect_resource.skill_resource_array[_i]
		_skill_serializable.cooldown = 0
		_skill_serializable.hold = _status_effect_resource.skill_resource_array[_i].max_hold
		#-------------------------------------------------------------------------------
		_status_effect_serializable.skill_serializable_array.append(_skill_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Max_TP():
	var _max_tp = 100
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		var _status_effect_serializable_array: Array[StatusEffect_Serializable] = friend_party[_i].party_member_serializable_in_battle.status_effect_serializable_array
		#-------------------------------------------------------------------------------
		for _j in _status_effect_serializable_array.size():
			var _status_effect_resource: StatusEffect_Resource = _status_effect_serializable_array[_j].statuseffect_resource
			#-------------------------------------------------------------------------------
			if(get_resource_filename(_status_effect_resource) == "status_damage_3"):
				_max_tp -= 33
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _max_tp
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PARTY_ITEMS CALLABLES
#-------------------------------------------------------------------------------
func item_heal_0(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_healing")
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
	#-------------------------------------------------------------------------------
	HP_Heal_Porcentual(_user.target, 1.0)
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func item_heal_1(_user:Party_Member_Node):
	Animation_StateMachine(_user.animation_tree, "", "Shot")
	Play_AttackAnimation(_user.target, "anim_revive")
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
	#-------------------------------------------------------------------------------
	if(_user.target.party_member_serializable.hp <= 0):
		Animation_StateMachine(_user.target.animation_tree, "", "Idle")
	#-------------------------------------------------------------------------------
	HP_Heal_Porcentual(_user.target, 1.0)
	#-------------------------------------------------------------------------------
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func item_heal_2(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
func item_heal_3(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
func item_heal_4(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
func item_damage_0(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
func item_damage_1(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
func item_damage_2(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
func item_damage_3(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
func item_damage_4(_user:Party_Member_Node):
	item_heal_1(_user)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region COMMON FUNCTIONS
#-------------------------------------------------------------------------------
func Get_Dir_XY(_v2:Vector2) -> float:
	var _dir: float = atan2(_v2.y, _v2.x)
	return _dir
#-------------------------------------------------------------------------------
func Flying_PopUp_Actions(_popup:PopUp_UI, _s:String, _is_enemy:bool):
	#-------------------------------------------------------------------------------
	_popup.scale = Vector2.ONE /camera.zoom
	_popup.label.text = _s
	_popup.z_index = 10
	#-------------------------------------------------------------------------------
	var _x_pos: float
	#-------------------------------------------------------------------------------
	if(_is_enemy):
		_x_pos = -15
	#-------------------------------------------------------------------------------
	else:
		_x_pos = 15
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, -10), 0.12)
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, 0), 0.12)
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, -5), 0.12)
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, 0), 0.12)
	_tween.tween_interval(0.7)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_popup.queue_free()
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
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
	world_2d.add_child(_label)
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
func get_instance_filename(_node: Node) -> String:
	return _node.scene_file_path.get_file().trim_suffix('.tscn')
#-------------------------------------------------------------------------------
func Destroy_Childrens(_node:Node):
	var children = _node.get_children()
	#-------------------------------------------------------------------------------
	for _child in children:
		_child.queue_free()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func HP_Damage(_target:Party_Member_Node, _int:int):
	#-------------------------------------------------------------------------------
	if(_target.party_member_serializable.hp > 0):
		_target.party_member_serializable.hp -= _int
		#-------------------------------------------------------------------------------
		Flying_PopUp(_target, "-"+str(_int)+" HP")
		#-------------------------------------------------------------------------------
		if(_target.party_member_serializable.hp > 0):
			Set_HP_Label(_target)
			Animation_StateMachine(_target.animation_tree, "Base_StateMachine/", "Hurt 2")
			singleton.audioStreamPlayer_enemy_damage.play()
		#-------------------------------------------------------------------------------
		else:
			User_Got_KnockDown(_target)
			Animation_StateMachine(_target.animation_tree, "Base_StateMachine/", "Death")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func User_Got_KnockDown(_user:Party_Member_Node):
	#-------------------------------------------------------------------------------
	Flying_PopUp(_user, "+"+tr("name_"+get_resource_filename(down_statuseffect_resource)))
	_user.party_member_serializable.hp = 0
	Set_HP_Label(_user)
	singleton.audioStreamPlayer_enemy_colapse.play()
	#-------------------------------------------------------------------------------
	var _status_effect_serializable_array: Array[StatusEffect_Serializable] = _user.party_member_serializable_in_battle.status_effect_serializable_array
	#-------------------------------------------------------------------------------
	for _i in range(_status_effect_serializable_array.size()-1, -1, -1):
		_status_effect_serializable_array.remove_at(_i)
	#-------------------------------------------------------------------------------
	Set_Status_Effect_Label(_user)
	Set_TP_Label(tp)
#-------------------------------------------------------------------------------
func HP_Heal_Porcentual(_target:Party_Member_Node, _scale:float):
	#-------------------------------------------------------------------------------
	if(_target.party_member_serializable.hp <= 0):
		_target.party_member_serializable.hp = 0
		Flying_PopUp(_target, "-"+tr("name_"+get_resource_filename(down_statuseffect_resource)))
	#-------------------------------------------------------------------------------
	var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(_target.party_member_serializable, "max_hp")
	var _gain_hp: int  = int(float(_max_hp)*_scale)
	_target.party_member_serializable.hp += _gain_hp
	#-------------------------------------------------------------------------------
	if(_target.party_member_serializable.hp < _max_hp):
		Flying_PopUp(_target, "+"+str(_max_hp)+" HP")
	#-------------------------------------------------------------------------------
	else:
		_target.party_member_serializable.hp = _max_hp
		Flying_PopUp(_target, "Max HP")
	#-------------------------------------------------------------------------------
	singleton.audioStreamPlayer_recovery.play()
	Set_HP_Label(_target)
	Set_Status_Effect_Label(_target)
#-------------------------------------------------------------------------------
func Set_HP_Label(_user:Party_Member_Node):
	var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(_user.party_member_serializable, "max_hp")
	_user.party_member_ui.label_hp.text = str(_user.party_member_serializable.hp)+"/"+str(_max_hp)+" HP"
	_user.party_member_ui.bar_hp.max_value = _max_hp
	_user.party_member_ui.bar_hp.value = _user.party_member_serializable.hp
#-------------------------------------------------------------------------------
func Set_SP_Label(_user:Party_Member_Node):
	var _max_sp: int = Get_Party_Member_Calculated_Base_Stat(_user.party_member_serializable, "max_sp")
	_user.party_member_ui.label_sp.text = str(_user.party_member_serializable.sp)+"/"+str(_max_sp)+" SP"
	_user.party_member_ui.bar_sp.max_value = _max_sp
	_user.party_member_ui.bar_sp.value = _user.party_member_serializable.sp
#-------------------------------------------------------------------------------
func Set_TP_Label(_tp: int):
	var _max_tp: int = Get_Max_TP()
	_tp = clampi(_tp, 0, _max_tp)
	#-------------------------------------------------------------------------------
	tp_label.text = str(_tp)
	max_tp_label.text = str(_max_tp)
	#-------------------------------------------------------------------------------
	tp_bar_progressbar_present.max_value = _max_tp
	tp_bar_progressbar_present.value = _tp
	#-------------------------------------------------------------------------------
	var _new_tp_bar_size: float = tp_bar_original_size * float(_max_tp) / 100
	tp_bar_progressbar_present.size.y = _new_tp_bar_size
#-------------------------------------------------------------------------------
func Set_TP_Label_from_the_future():
	var _tp: int = tp
	var _max_tp: int = Get_Max_TP()
	_tp = clampi(_tp, 0, _max_tp)
	#-------------------------------------------------------------------------------
	for _i in current_player_turn:
		_tp -= friend_party[_i].item_serializable.item_resource.tp_cost
	#-------------------------------------------------------------------------------
	Set_TP_Label(_tp)
#-------------------------------------------------------------------------------
func Animation_StateMachine(_animation_tree:AnimationTree, _state_machine:String, _anim:String):
	var _playback: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/"+_state_machine+"playback")
	_playback.call_deferred("travel", _anim)
#-------------------------------------------------------------------------------
func Animation_Transition(_animation_tree:AnimationTree, _state_machine:String, _anim:String):
	_animation_tree["parameters/"+_state_machine+"transition_request"] = _anim
#-------------------------------------------------------------------------------
func Animation_OneShot(_animation_tree:AnimationTree, _one_shot:String, _fire:AnimationNodeOneShot.OneShotRequest):
	_animation_tree["parameters/"+_one_shot+"/request"] = _fire
#-------------------------------------------------------------------------------
func Get_CircleSprite_Scale(_scale: float) -> Vector2:
	_scale *= 0.75/95.0
	var _v2: Vector2 = Vector2(_scale, _scale)
	return _v2
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
	_s += "Joystick: " + str(input_dir)+"\n"
	_s += "Joystick Normal: " + str(input_dir_normal)+"\n"
	_s += "Current Turn ID: " + str(current_player_turn)+"\n"
	_s += "Grab Focus: " + str(get_viewport().gui_get_focus_owner())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Tweens: "+str(tween_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Player: " + str(friend_party.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Enemy: " + str(enemy_party.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Enemy Bullets Enabled: " + str(enemyBullets_Enabled_Array.size())+"\n"
	_s += "Enemy Bullets Disabled: " + str(enemyBullets_Disabled_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
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
func PauseMenu_Open():
	pause_menu_panel.show()
	pause_menu.show()
	#-------------------------------------------------------------------------------
	SetMoney_Label()
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		var _party_button: Party_Button = Create_PartyMember_Button(friend_party[_i])
		#_party_button.custom_minimum_size.y = 180.0
		pause_menu_party_button_array.append(_party_button)
		pause_menu_party_button_content.add_child(_party_button)
		_button_array.append(_party_button.button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(_button_array)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_button_array[0])
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	PauseOn()
#-------------------------------------------------------------------------------
func SetMoney_Label():
	var _s: String = "  "+Get_Money_Label(inventory_serializable.money_serializable.stored)+"  "
	pause_menu_money_label.text = _s
	money_menu_label.text = _s
#-------------------------------------------------------------------------------
func Get_Money_Label(_value:int) -> String:
	return "$"+str(_value)
#-------------------------------------------------------------------------------
func PauseOn():
	#-------------------------------------------------------------------------------
	get_tree().set_deferred("paused", true)
#-------------------------------------------------------------------------------
func PauseMenu_Close():
	pause_menu_panel.hide()
	pause_menu.hide()
	#-------------------------------------------------------------------------------
	Destroy_Party_Button_Array(pause_menu_party_button_array)
	#-------------------------------------------------------------------------------
	PauseOff()
#-------------------------------------------------------------------------------
func PauseOff():
	get_tree().set_deferred("paused", false)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU
#-------------------------------------------------------------------------------
func PauseMenu_Set():
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(pause_menu_button_array)
	#-------------------------------------------------------------------------------
	singleton.Set_Button(pause_menu_button_array[0],func():singleton.Common_Selected() , func():PauseMenu_SkillButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[1],func():singleton.Common_Selected() , func():PauseMenu_ItemButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[2],func():singleton.Common_Selected() , func():PauseMenu_EquipButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[3],func():singleton.Common_Selected() , func():PauseMenu_StatusButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[4],func():singleton.Common_Selected() , func():PauseMenu_OptionButton_Submit(), func():PauseMenu_AnyButton_Cancel())
	singleton.Set_Button(pause_menu_button_array[5],func():singleton.Common_Selected() , func():PauseMenu_QuitButton_Submit(), func():PauseMenu_AnyButton_Cancel())
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_Submit():
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		singleton.Set_Button(_b, func():singleton.Common_Selected() , func():PauseMenu_SkillButton_PartyButton_Submit(_i), func():PauseMenu_SkillButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_party_button_array[0].button)
	singleton.Common_Submited()
	pause_menu_button_array[0].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_ItemButton_Submit():
	pause_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(item_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(item_menu_description)
	#-------------------------------------------------------------------------------
	var _all_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_all_scrollContainer, item_menu_all_button)
		Enable_Menu_And_Move_to_Button(item_menu_key_scrollContainer, item_menu_key_button_array, item_menu_key_button)
		item_menu_title.text = tr("item_menu_key_items_label")
	#-------------------------------------------------------------------------------
	var _all_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_all_scrollContainer, item_menu_all_button)
		Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
		item_menu_title.text = tr("item_menu_consumable_items_label")
	#-------------------------------------------------------------------------------
	var _consumable_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button)
		Enable_Menu_And_Move_to_Button(item_menu_all_scrollContainer, item_menu_all_button_array, item_menu_all_button)
		item_menu_title.text = tr("item_menu_all_items_label")
	#-------------------------------------------------------------------------------
	var _consumable_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button)
		Enable_Menu_And_Move_to_Button(item_menu_equip_scrollContainer, item_menu_equip_button_array, item_menu_equip_button)
		item_menu_title.text = tr("item_menu_equip_items_label")
	#-------------------------------------------------------------------------------
	var _equip_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_equip_scrollContainer, item_menu_equip_button)
		Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
		item_menu_title.text = tr("item_menu_consumable_items_label")
	#-------------------------------------------------------------------------------
	var _equip_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_equip_scrollContainer, item_menu_equip_button)
		Enable_Menu_And_Move_to_Button(item_menu_key_scrollContainer, item_menu_key_button_array, item_menu_key_button)
		item_menu_title.text = tr("item_menu_key_items_label")
	#-------------------------------------------------------------------------------
	var _key_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_key_scrollContainer, item_menu_key_button)
		Enable_Menu_And_Move_to_Button(item_menu_equip_scrollContainer, item_menu_equip_button_array, item_menu_equip_button)
		item_menu_title.text = tr("item_menu_equip_items_label")
	#-------------------------------------------------------------------------------
	var _key_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_key_scrollContainer, item_menu_key_button)
		Enable_Menu_And_Move_to_Button(item_menu_all_scrollContainer, item_menu_all_button_array, item_menu_all_button)
		item_menu_title.text = tr("item_menu_all_items_label")
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():Item_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():PauseMenu_ItemButton_ItemMenu_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(item_menu_all_button, _selected_0, _submit_0, _cancel_0, _w, _s, _all_a, _all_d)
	singleton.Set_Button_WSAD(item_menu_consumable_button, _selected_0, _submit_0, _cancel_0, _w, _s, _consumable_a, _consumable_d)
	singleton.Set_Button_WSAD(item_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _equip_a, _equip_d)
	singleton.Set_Button_WSAD(item_menu_key_button, _selected_0, _submit_0, _cancel_0, _w, _s, _key_a, _key_d)
	#-------------------------------------------------------------------------------
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.consumable_item_array.size():
		var _hold: int = _inventory_serializable.consumable_item_array[_i].hold
		var _cooldown: int = _inventory_serializable.consumable_item_array[_i].cooldown
		#-------------------------------------------------------------------------------
		var _consumableitem_button: Button = Create_ConsumableItem_Button(_inventory_serializable.consumable_item_array[_i], _hold, _cooldown)
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():ItemMenu_Consumable_ItemButton_Selected(_inventory_serializable.consumable_item_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_consumableitem_button, _selected_1, _submit_1, _cancel_0, _w, _s, _consumable_a, _consumable_d)
		item_menu_consumable_content.add_child(_consumableitem_button)
		item_menu_consumable_button_array.append(_consumableitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_ConsumableItem_Button(_inventory_serializable.consumable_item_array[_i], _hold, _cooldown)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected_1, _submit_1, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.equip_item_array.size():
		var _equipitem_button: Button = Create_EquipItem_Button(_inventory_serializable.equip_item_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():ItemMenu_Equipment_ItemButton_Selected(_inventory_serializable.equip_item_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_equipitem_button, _selected_1, _submit_1, _cancel_0, _w, _s, _equip_a, _equip_d)
		item_menu_equip_content.add_child(_equipitem_button)
		item_menu_equip_button_array.append(_equipitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_EquipItem_Button(_inventory_serializable.equip_item_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected_1, _submit_1, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	var _new_key_item_array: Array[Key_Item_Serializable] = Get_Key_Item_Serializable_Array(_inventory_serializable)
	#-------------------------------------------------------------------------------
	for _i in _new_key_item_array.size():
		var _keyitem_button: Button = Create_KeyItem_Button(_new_key_item_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():ItemMenu_KeyItem_ItemButton_Selected(_new_key_item_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_keyitem_button, _selected_1, _submit_1, _cancel_0, _w, _s, _key_a, _key_d)
		item_menu_key_content.add_child(_keyitem_button)
		item_menu_key_button_array.append(_keyitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_KeyItem_Button(_new_key_item_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected_1, _submit_1, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_all_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	Item_Menu_Hide_All_ScrollContainer()
	Item_Menu_Show_and_Enable_All_Button()
	Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
	item_menu_title.text = tr("item_menu_consumable_items_label")
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_Submit():
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		singleton.Set_Button(_b, func():singleton.Common_Selected() , func():PauseMenu_EquipButton_PartyButton_Submit(_i), func():PauseMenu_EquipButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_party_button_array[0].button)
	singleton.Common_Submited()
	pause_menu_button_array[2].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_Submit():
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		var _b: Button = pause_menu_party_button_array[_i].button
		singleton.Set_Button(_b, func():singleton.Common_Selected() , func():PauseMenu_StatusButton_PartyButton_Submit(_i), func():PauseMenu_StatusButton_PartyButton_Cancel())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_party_button_array[0].button)
	singleton.Common_Submited()
	pause_menu_button_array[3].disabled = true
#-------------------------------------------------------------------------------
func PauseMenu_OptionButton_Submit():
	singleton.optionMenu.show()
	singleton.Set_Button(singleton.optionMenu.back, func():singleton.Common_Selected(), func():OptionMenu_BackButton_Subited(), func():OptionMenu_BackButton_Canceled())
	pause_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(singleton.optionMenu.back)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func PauseMenu_QuitButton_Submit():
	go_to_title_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(go_to_title_menu_button_array[0], singleton.Common_Selected, func():Go_To_Title_Menu_Yes_Button_Submit(), func():Go_To_Title_Menu_Any_Button_Cancel())
	singleton.Set_Button(go_to_title_menu_button_array[1], singleton.Common_Selected, func():Go_To_Title_Menu_No_Button_Submit(), func():Go_To_Title_Menu_Any_Button_Cancel())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(go_to_title_menu_button_array[1])
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Go_To_Title_Menu_Yes_Button_Submit():
	PauseOff()
	get_tree().change_scene_to_file("res://Nodes/Scenes/title_scene.tscn")
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Go_To_Title_Menu_No_Button_Submit():
	go_to_title_menu.hide()
	singleton.Move_to_Button(pause_menu_button_array[5])
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Go_To_Title_Menu_Any_Button_Cancel():
	go_to_title_menu.hide()
	singleton.Move_to_Button(pause_menu_button_array[5])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func PauseMenu_AnyButton_Cancel():
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	await get_tree().physics_frame
	PauseMenu_Close()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CREATE BUTTON
#-------------------------------------------------------------------------------
func Create_PartyMember_Button(_party_member:Party_Member_Node) -> Party_Button:
	var _party_button: Party_Button = party_button_prefab.instantiate() as Party_Button
	#-------------------------------------------------------------------------------
	PartyMember_Button_Set_HP_and_SP(_party_button, _party_member)
	#-------------------------------------------------------------------------------
	_party_button.texture.texture = _party_member.party_member_serializable.party_member_resource.face_sprite
	#-------------------------------------------------------------------------------
	PartyMember_Button_Set_Idiome(_party_button, _party_member)
	#-------------------------------------------------------------------------------
	return _party_button
#-------------------------------------------------------------------------------
func PartyMember_Button_Set_HP_and_SP(_party_button:Party_Button, _party_member:Party_Member_Node):
	var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(_party_member.party_member_serializable, "max_hp")
	_party_button.label_hp.text = str(_max_hp)+"/"+str(_max_hp)+" HP"
	_party_button.bar_hp.max_value = _max_hp
	_party_button.bar_hp.value = _max_hp
	#-------------------------------------------------------------------------------
	var _max_sp: int = Get_Party_Member_Calculated_Base_Stat(_party_member.party_member_serializable, "max_sp")
	_party_button.label_sp.text = str(_max_sp)+"/"+str(_max_sp)+" SP"
	_party_button.bar_sp.max_value = _max_sp
	_party_button.bar_sp.value = _max_sp
#-------------------------------------------------------------------------------
func PartyMember_Button_Set_Idiome(_party_button:Party_Button, _party_member:Party_Member_Node):
	var _id: String = get_instance_filename(_party_member)
	#-------------------------------------------------------------------------------
	var _s: String = ""
	_s += tr("name_"+_id)
	_s += "\n"
	_s += tr("title_"+_id)
	#-------------------------------------------------------------------------------
	_party_button.title.text = _s
#-------------------------------------------------------------------------------
func Create_Skill_Button(_item_serializable: Item_Serializable) -> Button:
	#-------------------------------------------------------------------------------
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_item_serializable.item_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
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
		var _max_hold: int = _item_serializable.item_resource.max_hold
		#-------------------------------------------------------------------------------
		if(_max_hold > 0):
			var _hold: int = _item_serializable.hold
			_label2.text += "["+str(_hold)+"/"+str(_max_hold)+"]  "
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		_label2.text = "("+str(_item_serializable.cooldown)+" CD)  "
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_ConsumableItem_Button(_item_serializable: Item_Serializable, _hold:int, _cooldown:int) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_item_serializable.item_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: RichTextLabel = RichTextLabel.new()
	_label2.bbcode_enabled = true
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = ""
	#-------------------------------------------------------------------------------
	if(_cooldown <= 0 or _item_serializable.item_resource.max_cooldown <= 0):
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
		var _max_hold: int = _item_serializable.item_resource.max_hold
		#-------------------------------------------------------------------------------
		if(_max_hold > 0):
			var _s: String = "["+str(_hold)+"/"+str(_max_hold)+"]  "
			#-------------------------------------------------------------------------------
			if(_hold < _item_serializable.hold):
				_label2.text += "[color="+hex_color_yellow+"]"+_s+"[/color]"
			#-------------------------------------------------------------------------------
			else:
				_label2.text += _s
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _s: String = "("+str(_cooldown)+" CD)  "
		#-------------------------------------------------------------------------------
		if(_cooldown > _item_serializable.cooldown):
			_label2.text = "[color="+hex_color_yellow+"]"+_s+"[/color]"
		#-------------------------------------------------------------------------------
		else:
			_label2.text = _s
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_ConsumableItem_InMarket_Button(_item_serializable: Item_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_item_serializable.item_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: RichTextLabel = RichTextLabel.new()
	_label2.bbcode_enabled = true
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = ""
	_label2.text += Get_Money_Label(_item_serializable.price)+"  "
	#_label2.text += "["+str(_item_serializable.stored)+"]  "
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_EquipItem_Button(_equip_serializable: Equip_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_equip_serializable.equip_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = "["+str(_equip_serializable.stored)+"]  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_EquipItem_InMarket_Button(_equip_serializable: Equip_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_equip_serializable.equip_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = ""
	_label2.text += "["+str(_equip_serializable.stored)+"]  "
	_label2.text += Get_Money_Label(_equip_serializable.price)+"  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_EquipEmpty_Button() -> Button:
	var _empty_button: Button = Button.new()
	_empty_button.theme = ui_theme
	_empty_button.text = "  ["+tr("user_menu_equip_slot_empty_button")+"]  "
	_empty_button.add_theme_font_size_override("font_size", 24)
	_empty_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	#-------------------------------------------------------------------------------
	return _empty_button
#-------------------------------------------------------------------------------
func Create_EquipSlot_Button(_equip_serializable: Equip_Serializable) -> Button:
	var _button:Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	#-------------------------------------------------------------------------------
	if(_equip_serializable.equip_resource == null):
		_button.text = "  ["+tr("user_menu_equip_slot_empty_button")+"]  "
	#-------------------------------------------------------------------------------
	else:
		_button.text = tr("name_"+get_resource_filename(_equip_serializable.equip_resource))
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_EquipSlot_Label(_equip_array: Array[Equip_Serializable]):
	#-------------------------------------------------------------------------------
	if(_equip_array.size() >0):
		user_menu_equip_button_label.text = ""
		#-------------------------------------------------------------------------------
		for _i in _equip_array.size():
			#-------------------------------------------------------------------------------
			match(_equip_array[_i].myEQUIP_TYPE):
				Equip_Resource.EQUIP_TYPE.WEAPON:
					user_menu_equip_button_label.text += tr("weapon_label")+": "
				#-------------------------------------------------------------------------------
				Equip_Resource.EQUIP_TYPE.HEAD:
					user_menu_equip_button_label.text += tr("head_label")+": "
				#-------------------------------------------------------------------------------
				Equip_Resource.EQUIP_TYPE.BODY:
					user_menu_equip_button_label.text += tr("body_label")+": "
				#-------------------------------------------------------------------------------
				Equip_Resource.EQUIP_TYPE.RING:
					user_menu_equip_button_label.text += tr("ring_label")+": "
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			if(_i < _equip_array.size()-1):
				user_menu_equip_button_label.text += "\n"
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		user_menu_equip_button_label.show()
	#-------------------------------------------------------------------------------
	else:
		user_menu_equip_button_label.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Create_KeyItem_Button(_keyitem_serializable: Key_Item_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_keyitem_serializable.key_item_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = "["+str(_keyitem_serializable.stored)+"]  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_KeyItem_InMarket_Button(_keyitem_serializable: Key_Item_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_keyitem_serializable.key_item_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = ""
	_label2.text += "["+str(_keyitem_serializable.stored)+"]  "
	_label2.text += Get_Money_Label(_keyitem_serializable.price)+"  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_Stats_Button_Array(_party_member_serializable:Party_Member_Serializable, _cancel:Callable, _w:Callable, _s:Callable, _a:Callable, _d:Callable):
	#-------------------------------------------------------------------------------
	for _i in _party_member_serializable.base_stats_dictionarty.size():
		var _key: String = _party_member_serializable.base_stats_dictionarty.keys()[_i]		#NOTA: Utilizar diccionarios privados, y no exportados, mantienen el orden original de sus elementos.
		var _value: int = Get_Party_Member_Calculated_Base_Stat(_party_member_serializable, _key)
		#-------------------------------------------------------------------------------
		Create_Stats_Button_2(_key, _value, _cancel, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Party_Member_Calculated_Base_Stat(_party_member_serializable:Party_Member_Serializable,_key: StringName) -> int:
	var _value: int = _party_member_serializable.party_member_resource.base_stats_dictionarty.get(_key, 0)
	#-------------------------------------------------------------------------------
	for _j in _party_member_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_party_member_serializable.equip_serializable_array[_j].equip_resource != null):
			_value += _party_member_serializable.equip_serializable_array[_j].equip_resource.base_stats_dictionarty.get(_key, 0)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _j in _party_member_serializable.status_effect_serializable_array.size():
		_value += _party_member_serializable.status_effect_serializable_array[_j].statuseffect_resource.base_stats_dictionarty.get(_key, 0)
	#-------------------------------------------------------------------------------
	return _value
#-------------------------------------------------------------------------------
func Create_Stats_Button_2(_id:String, _value:int, _cancel:Callable, _w:Callable, _s:Callable, _a:Callable, _d:Callable):
	var _stats_button: Button = Create_Stats_Button(_id, _value)
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():StatusMenu_StatsButton_Selected(_id)
	var _submit: Callable = func():singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(_stats_button, _selected, _submit, _cancel, _w, _s, _a, _d)
	user_menu_stats_content.add_child(_stats_button)
	user_menu_stats_button_array.append(_stats_button)
#-------------------------------------------------------------------------------
func Create_Stats_Button(_stat_name: String, _stat_value: int) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	var _stat_value_text: String = str(_stat_value)+"  "
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_stat_"+_stat_name)+":  "
	_button.text += Add_String_Space(_stat_value_text.length()+2)	#NOTA: Esto es para que los 2 textos no se solapen si son muy largos.
	#-------------------------------------------------------------------------------
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.add_theme_font_size_override("font_size", 24)
	_label2.text = _stat_value_text
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Add_String_Space(_max_int:int) -> String:
	var _s: String = ""
	#-------------------------------------------------------------------------------
	for _i in _max_int:
		_s += " "
	#-------------------------------------------------------------------------------
	return _s
#-------------------------------------------------------------------------------
func Create_StatusEffect_Button(_statuseffect_serializable: StatusEffect_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.theme = ui_theme
	_button.text = "  "+tr("name_"+get_resource_filename(_statuseffect_serializable.statuseffect_resource))+"  "
	_button.add_theme_font_size_override("font_size", 24)
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#-------------------------------------------------------------------------------
	if(_statuseffect_serializable.statuseffect_resource.is_infinite):
		#∞, ꝏ, Ꝏ
		_label2.text = "[Ꝏ]  "
	#-------------------------------------------------------------------------------
	else:
		_label2.text = "["+str(_statuseffect_serializable.stored)+"/"+str(_statuseffect_serializable.statuseffect_resource.max_hold)+"]  "
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ITEM DESCRIPTION FUNCTIONS
#-------------------------------------------------------------------------------
func Set_Skill_Information(_item_serializable:Item_Serializable):
	var _tp_cost: int = _item_serializable.item_resource.tp_cost
	var _tp_cost_text: String
	#----------------------------------------------------------------------------
	if(_tp_cost > 0):
		_tp_cost_text = "("+str(_tp_cost)+" TP)"
	#----------------------------------------------------------------------------
	else:
		_tp_cost_text = "-"
	#----------------------------------------------------------------------------
	var _cooldown: int = _item_serializable.item_resource.max_cooldown
	var _cooldown_text: String
	#----------------------------------------------------------------------------
	if(_cooldown > 0):
		_cooldown_text = "("+str(_item_serializable.item_resource.max_cooldown)+" CD)"
	#----------------------------------------------------------------------------
	else:
		_cooldown_text = "-"
	#----------------------------------------------------------------------------
	var _hold_text: String
	var _max_hold: int = _item_serializable.item_resource.max_hold
	#----------------------------------------------------------------------------
	if(_max_hold > 0):
		_hold_text = "["+str(_item_serializable.hold)+"/"+str(_max_hold)+"]"
	#----------------------------------------------------------------------------
	else:
		_hold_text = "-"
	#----------------------------------------------------------------------------
	user_menu_description.text = tr("description_"+get_resource_filename(_item_serializable.item_resource))
	user_menu_description.get_v_scroll_bar().value = 0
	#----------------------------------------------------------------------------
	user_menu_cost_label.text = "* "+tr("item_menu_cost_label")+":"
	user_menu_tp_cost_num_label.text = _tp_cost_text
	user_menu_cooldown_num_label.text = _cooldown_text
	#----------------------------------------------------------------------------
	user_menu_held_label.text = "* "+tr("item_menu_hold_label")+":"
	user_menu_hold_num_label.text = _hold_text
	user_menu_storage_num_label.text = ""
#-------------------------------------------------------------------------------
func Set_ConsumableItem_Information(_item_serializable:Item_Serializable):
	var _hold_text: String
	var _max_hold: int = _item_serializable.item_resource.max_hold
	#-------------------------------------------------------------------------------
	if(_max_hold > 0):
		var _hold: int = _item_serializable.hold
		_hold_text = "["+str(_hold)+"/"+str(_max_hold)+"]"
	#-------------------------------------------------------------------------------
	else:
		_hold_text = "-"
	#-------------------------------------------------------------------------------
	var _stored_text: String
	var _stored: int = _item_serializable.stored
	_stored_text = "["+str(_stored)+"]"
	#-------------------------------------------------------------------------------
	var _tp_cost_text: String
	var _tp_cost: int = _item_serializable.item_resource.tp_cost
	#-------------------------------------------------------------------------------
	if(_tp_cost>0):
		_tp_cost_text = "("+str(_tp_cost)+" TP)"
	#-------------------------------------------------------------------------------
	else:
		_tp_cost_text = "-"
	#-------------------------------------------------------------------------------
	var _cooldown_text: String
	var _cooldown: int = _item_serializable.item_resource.max_cooldown
	#-------------------------------------------------------------------------------
	if(_cooldown>0):
		_cooldown_text = "("+str(_cooldown)+" CD)"
	#-------------------------------------------------------------------------------
	else:
		_cooldown_text = "-"
	#-------------------------------------------------------------------------------
	item_menu_description.text = tr("description_"+get_resource_filename(_item_serializable.item_resource))
	item_menu_description.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	item_menu_cost_label.text = "* "+tr("item_menu_cost_label")+":"
	item_menu_tp_cost_num_label.text = _tp_cost_text
	item_menu_cooldown_num_label.text = _cooldown_text
	#-------------------------------------------------------------------------------
	item_menu_hold_label.text = "* "+tr("item_menu_hold_label")+":"
	item_menu_hold_num_label.text = _hold_text
	item_menu_storage_num_label.text = _stored_text
#-------------------------------------------------------------------------------
func Set_EquipItem_Information(_equip_serializable:Equip_Serializable):
	item_menu_description.text = Set_EquipItem_Information_Common(_equip_serializable.equip_resource)
	item_menu_description.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	item_menu_cost_label.text = ""
	item_menu_tp_cost_num_label.text = ""
	item_menu_cooldown_num_label.text = ""
	#-------------------------------------------------------------------------------
	item_menu_hold_label.text = "* "+tr("item_menu_hold_label")+":"
	item_menu_hold_num_label.text = ""
	item_menu_storage_num_label.text = "["+str(_equip_serializable.stored)+"]"
#-------------------------------------------------------------------------------
func Set_EquipItem_Information_Common(_equip_resource:Equip_Resource) ->String:
	var _s:String = ""
	_s += tr("description_"+get_resource_filename(_equip_resource))
	#-------------------------------------------------------------------------------
	var _not_sorted_base_stats_dictionarty: Dictionary[StringName, int] = friend_party[0].party_member_serializable.base_stats_dictionarty	#NOTA: Necesito hacer esto porque los @export dictionary se reordenan alfabeticamente, mientras que los privados mantienen el orden original.
	#-------------------------------------------------------------------------------
	for _i in _not_sorted_base_stats_dictionarty.size():
		var _key: String = _not_sorted_base_stats_dictionarty.keys()[_i]		#NOTA: Utilizar diccionarios privados, y no exportados, mantienen el orden original de sus elementos.
		var _value: int = _equip_resource.base_stats_dictionarty.get(_key, 0)
		#-------------------------------------------------------------------------------
		if(_value > 0):
			_s += "\n"
			_s += "* +"+str(_value)+" "+tr("name_stat_"+_key)+"."
		#-------------------------------------------------------------------------------
		elif(_value < 0):
			_s += "\n"
			_s += "* "+str(_value)+" "+tr("name_stat_"+_key)+"."
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _equip_resource.skill_resource_array.size():
		_s += "\n"
		_s += "* Add Skill: "+tr("name_"+get_resource_filename(_equip_resource.skill_resource_array[_i]))+"."
	#-------------------------------------------------------------------------------
	return _s
#-------------------------------------------------------------------------------
func Set_KeyItem_Information(_keyitem_serializable:Key_Item_Serializable):
	item_menu_description.text = tr("description_"+get_resource_filename(_keyitem_serializable.key_item_resource))
	item_menu_description.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	item_menu_cost_label.text = ""
	item_menu_tp_cost_num_label.text = ""
	item_menu_cooldown_num_label.text = ""
	#-------------------------------------------------------------------------------
	item_menu_hold_label.text = "* "+tr("item_menu_hold_label")+":"
	item_menu_hold_num_label.text = ""
	item_menu_storage_num_label.text = "["+str(_keyitem_serializable.stored)+"]"
#-------------------------------------------------------------------------------
func User_Menu_No_Description():
	user_menu_description.text = ""
	user_menu_description.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	user_menu_cost_label.text = ""
	user_menu_tp_cost_num_label.text = ""
	user_menu_cooldown_num_label.text = ""
	#-------------------------------------------------------------------------------
	user_menu_held_label.text = ""
	user_menu_hold_num_label.text = ""
	user_menu_storage_num_label.text = ""
	#-------------------------------------------------------------------------------
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func Item_Menu_No_Description():
	item_menu_description.text = ""
	item_menu_description.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	item_menu_cost_label.text = ""
	item_menu_tp_cost_num_label.text = ""
	item_menu_cooldown_num_label.text = ""
	#-------------------------------------------------------------------------------
	item_menu_hold_label.text = ""
	item_menu_hold_num_label.text = ""
	item_menu_storage_num_label.text = ""
	#-------------------------------------------------------------------------------
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func TeleportMenu_No_Description():
	singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	teleport_menu_rect.texture = null
	teleport_menu_description.text = ""
	teleport_menu_description.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU - SKILLS
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	user_menu.show()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(user_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(user_menu_description)
	#-------------------------------------------------------------------------------
	var _a: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _d: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():User_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():PauseMenu_StatusMenu_Exit_Common(_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(user_menu_skill_button, _selected_0, _submit_0, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	var _user: Party_Member_Node = friend_party[_index]
	_user.party_member_serializable.Set_Skills()
	var _skill_serializable_array: Array[Item_Serializable] = _user.party_member_serializable.Get_Skills()
	#-------------------------------------------------------------------------------
	for _i in _skill_serializable_array.size():
		var _skill_button: Button = Create_Skill_Button(_skill_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():SkillMenu_SkillButton_Selected(_skill_serializable_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_skill_button, _selected_1, _submit_1, _cancel_0, _w, _s, _a, _d)
		user_menu_skill_content.add_child(_skill_button)
		user_menu_skill_button_array.append(_skill_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_skill_button_array)
	#-------------------------------------------------------------------------------
	User_Menu_Hide_All_Button()
	User_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button(user_menu_skill_scrollContainer, user_menu_skill_button_array, user_menu_skill_button)
	user_menu_title.text = tr("user_menu_skill_label")
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func PauseMenu_SkillButton_PartyButton_Cancel():
	pause_menu_button_array[0].disabled = false
	singleton.Move_to_Button(pause_menu_button_array[0])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU - ITEMS
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
	Destroy_Button_Array(item_menu_all_button_array)
	Destroy_Button_Array(item_menu_consumable_button_array)
	Destroy_Button_Array(item_menu_equip_button_array)
	Destroy_Button_Array(item_menu_key_button_array)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU - EQUIP
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	user_menu.show()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(user_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(user_menu_description)
	#-------------------------------------------------------------------------------
	var _a: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _d: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():User_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():PauseMenu_StatusMenu_Exit_Common(_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(user_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	var _user: Party_Member_Node = friend_party[_index]
	var _equip_serializable_array: Array[Equip_Serializable] = _user.party_member_serializable.equip_serializable_array
	#-------------------------------------------------------------------------------
	for _i in _equip_serializable_array.size():
		var _equipslot_button:Button = Create_EquipSlot_Button(_equip_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():EquipSlotMenu_EquipButton_Selected(_user, _equip_serializable_array, _i)
		var _submit_1: Callable = func(): PauseMenu_EquipButton_PartyButton_EquipSlot_Submit(_user, _i)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_equipslot_button, _selected_1, _submit_1, _cancel_0, _w, _s, _a, _d)
		user_menu_equip_button_array.append(_equipslot_button)
		user_menu_equip_content.add_child(_equipslot_button)
	#-------------------------------------------------------------------------------
	Create_EquipSlot_Label(_equip_serializable_array)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	User_Menu_Hide_All_Button()
	User_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button(user_menu_equip_scrollContainer, user_menu_equip_button_array, user_menu_equip_button)
	user_menu_title.text = tr("user_menu_equip_label")
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_Submit(_user:Party_Member_Node, _index_slot:int):
	user_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(item_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(item_menu_description)
	#-------------------------------------------------------------------------------
	var _a: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _d: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():Item_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(item_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	var _empty_button: Button = Create_EquipEmpty_Button()
	#-------------------------------------------------------------------------------
	var _selected_empty: Callable = func():Item_Menu_No_Description()
	var _submit_empty: Callable = func():PauseMenu_EquipButton_PartyButton_EmptyEquipSlot_EquipMenu_Submit(_user, _index_slot)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(_empty_button, _selected_empty, _submit_empty, _cancel_0, _w, _s, _a, _d)
	item_menu_equip_content.add_child(_empty_button)
	item_menu_equip_button_array.append(_empty_button)
	#-------------------------------------------------------------------------------
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.equip_item_array.size():
		var _equipitem_button: Button = Create_EquipItem_Button(_inventory_serializable.equip_item_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():ItemMenu_Equipment_ItemButton_Selected(_inventory_serializable.equip_item_array[_i])
		var _submit_1: Callable = func():PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Submit(_user, _inventory_serializable.equip_item_array[_i], _index_slot)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_equipitem_button, _selected_1, _submit_1, _cancel_0, _w, _s, _a, _d)
		item_menu_equip_content.add_child(_equipitem_button)
		item_menu_equip_button_array.append(_equipitem_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	Item_Menu_Hide_All_Buttons()
	Item_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button(item_menu_equip_scrollContainer, item_menu_equip_button_array, item_menu_equip_button)
	item_menu_title.text = tr("item_menu_equip_items_label")
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Submit(_user: Party_Member_Node, _equip_serializable:Equip_Serializable, _index_slot:int):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	if(_user.party_member_serializable.equip_serializable_array[_index_slot].equip_resource != _equip_serializable.equip_resource):
		Remove_Equip_Serializable_to_Array(_inventory_serializable.equip_item_array, _equip_serializable)
		#-------------------------------------------------------------------------------
		_user.party_member_serializable.equip_serializable_array[_index_slot].equip_resource = _equip_serializable.equip_resource
		_user.party_member_serializable.equip_serializable_array[_index_slot].stored = 1
		Set_Skills_in_Equip_Serializable_when_Equip_Resource_is_Equiped(_equip_serializable)
		#-------------------------------------------------------------------------------
		user_menu_equip_button_array[_index_slot].text = tr("name_"+get_resource_filename(_equip_serializable.equip_resource))
	#-------------------------------------------------------------------------------
	PauseMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	user_menu.show()
	singleton.Move_to_Button(user_menu_equip_button_array[_index_slot])
	singleton.Play_SFX_Equip()
#-------------------------------------------------------------------------------
func Set_Skills_in_Equip_Serializable_when_Equip_Resource_is_Equiped(_equip_serializable:Equip_Serializable):
	var _equip_resource: Equip_Resource = _equip_serializable.equip_resource
	#-------------------------------------------------------------------------------
	_equip_serializable.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in _equip_resource.skill_resource_array.size():
		var _skill_serializable: Item_Serializable = Item_Serializable.new()
		#-------------------------------------------------------------------------------
		_skill_serializable.item_resource = _equip_resource.skill_resource_array[_i]
		_skill_serializable.cooldown = 0
		_skill_serializable.hold = _equip_resource.skill_resource_array[_i].max_hold
		#-------------------------------------------------------------------------------
		_equip_serializable.skill_serializable_array.append(_skill_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EmptyEquipSlot_EquipMenu_Submit(_user: Party_Member_Node, _index_slot:int):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	if(_user.party_member_serializable.equip_serializable_array[_index_slot].equip_resource != null):
		Add_Equip_Serializable_to_Array(_inventory_serializable.equip_item_array, _user.party_member_serializable.equip_serializable_array[_index_slot].equip_resource, 1)
		#-------------------------------------------------------------------------------
		_user.party_member_serializable.equip_serializable_array[_index_slot].equip_resource = null
		_user.party_member_serializable.equip_serializable_array[_index_slot].stored = 0
		#-------------------------------------------------------------------------------
		user_menu_equip_button_array[_index_slot].text = "  ["+tr("user_menu_equip_slot_empty_button")+"]  "
	#-------------------------------------------------------------------------------
	PauseMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	user_menu.show()
	singleton.Move_to_Button(user_menu_equip_button_array[_index_slot])
	singleton.Play_SFX_Equip()
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_EquipSlot_EquipMenu_Cancel(_index_slot:int):
	PauseMenu_ItemMenu_Exit_Common()
	#-------------------------------------------------------------------------------
	user_menu.show()
	singleton.Move_to_Button(user_menu_equip_button_array[_index_slot])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func PauseMenu_EquipButton_PartyButton_Cancel():
	pause_menu_button_array[2].disabled = false
	singleton.Move_to_Button(pause_menu_button_array[2])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func Remove_Equip_Serializable_to_Array(_equip_array:Array[Equip_Serializable], _equip_serializable: Equip_Serializable):
	_equip_serializable.stored -= 1
	#-------------------------------------------------------------------------------
	if(_equip_serializable.stored <= 0):
		_equip_array.erase(_equip_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU - STATUS
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_PartyButton_Submit(_index:int):
	pause_menu.hide()
	user_menu.show()
	#-------------------------------------------------------------------------------
	var _user: Party_Member_Node = friend_party[_index]
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(user_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(user_menu_description)
	#-------------------------------------------------------------------------------
	var _info_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_info_container, user_menu_info_button)
		Enable_Menu_And_Move_to_Button(user_menu_skill_scrollContainer, user_menu_skill_button_array, user_menu_skill_button)
		user_menu_title.text = tr("user_menu_skill_label")
	#-------------------------------------------------------------------------------
	var _info_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_info_container, user_menu_info_button)
		Enable_Menu_And_Move_to_Button(user_menu_stats_scrollContainer, user_menu_stats_button_array, user_menu_stats_button)
		user_menu_title.text = tr("user_menu_stats_label")
	#-------------------------------------------------------------------------------
	var _stats_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_stats_scrollContainer, user_menu_stats_button)
		Enable_Menu_And_Move_to_Button_0(user_menu_info_container, user_menu_info_button)
		user_menu_title.text = tr("user_menu_info_label")
	#-------------------------------------------------------------------------------
	var _stats_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_stats_scrollContainer, user_menu_stats_button)
		Enable_Menu_And_Move_to_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button_array, user_menu_statuseffect_button)
		user_menu_title.text = tr("user_menu_status_effect_label")
	#-------------------------------------------------------------------------------
	var _statuseffect_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button)
		Enable_Menu_And_Move_to_Button(user_menu_stats_scrollContainer, user_menu_stats_button_array, user_menu_stats_button)
		user_menu_title.text = tr("user_menu_stats_label")
	#-------------------------------------------------------------------------------
	var _statuseffect_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button)
		Enable_Menu_And_Move_to_Button(user_menu_equip_scrollContainer, user_menu_equip_button_array, user_menu_equip_button)
		user_menu_title.text = tr("user_menu_equip_label")
	#-------------------------------------------------------------------------------
	var _equip_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_equip_scrollContainer, user_menu_equip_button)
		Enable_Menu_And_Move_to_Button(user_menu_statuseffect_scrollContainer, user_menu_statuseffect_button_array, user_menu_statuseffect_button)
		user_menu_title.text = tr("user_menu_status_effect_label")
	#-------------------------------------------------------------------------------
	var _equip_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_equip_scrollContainer, user_menu_equip_button)
		Enable_Menu_And_Move_to_Button(user_menu_skill_scrollContainer, user_menu_skill_button_array, user_menu_skill_button)
		user_menu_title.text = tr("user_menu_skill_label")
	#-------------------------------------------------------------------------------
	var _skill_a: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_skill_scrollContainer, user_menu_skill_button)
		Enable_Menu_And_Move_to_Button(user_menu_equip_scrollContainer, user_menu_equip_button_array, user_menu_equip_button)
		user_menu_title.text = tr("user_menu_equip_label")
	#-------------------------------------------------------------------------------
	var _skill_d: Callable = func():
		Hide_Control_and_Enable_Button(user_menu_skill_scrollContainer, user_menu_skill_button)
		Enable_Menu_And_Move_to_Button_0(user_menu_info_container, user_menu_info_button)
		user_menu_title.text = tr("user_menu_info_label")
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():User_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():PauseMenu_StatusMenu_Exit_Common(_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(user_menu_info_button, func():User_Menu_Info_Button_Selected(_user), _submit_0, _cancel_0, _w, _s, _info_a, _info_d)
	singleton.Set_Button_WSAD(user_menu_stats_button, _selected_0, _submit_0, _cancel_0, _w, _s, _stats_a, _stats_d)
	singleton.Set_Button_WSAD(user_menu_statuseffect_button, _selected_0, _submit_0, _cancel_0, _w, _s, _statuseffect_a, _statuseffect_d)
	singleton.Set_Button_WSAD(user_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _equip_a, _equip_d)
	singleton.Set_Button_WSAD(user_menu_skill_button, _selected_0, _submit_0, _cancel_0, _w, _s, _skill_a, _skill_d)
	#-------------------------------------------------------------------------------
	Create_Stats_Button_Array(_user.party_member_serializable, _cancel_0, _w, _s, _stats_a, _stats_d)
	#-------------------------------------------------------------------------------
	for _i in _user.party_member_serializable.status_effect_serializable_array.size():
		var _statuseffect_button: Button = Create_StatusEffect_Button(friend_party[_index].status_effect_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():StatusMenu_StatusEffectButton_Selected(friend_party[_index].status_effect_serializable_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_statuseffect_button, _selected_1, _submit_1, _cancel_0, _w, _s, _statuseffect_a, _statuseffect_d)
		user_menu_statuseffect_content.add_child(_statuseffect_button)
		user_menu_statuseffect_button_array.append(_statuseffect_button)
	#-------------------------------------------------------------------------------
	for _i in _user.party_member_serializable.equip_serializable_array.size():
		var _equipslot_button:Button = Create_EquipSlot_Button(_user.party_member_serializable.equip_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():EquipSlotMenu_EquipButton_Selected(_user, _user.party_member_serializable.equip_serializable_array, _i)
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_equipslot_button, _selected_1, _submit_1, _cancel_0, _w, _s, _equip_a, _equip_d)
		user_menu_equip_button_array.append(_equipslot_button)
		user_menu_equip_content.add_child(_equipslot_button)
	#-------------------------------------------------------------------------------
	Create_EquipSlot_Label(_user.party_member_serializable.equip_serializable_array)
	#-------------------------------------------------------------------------------
	_user.party_member_serializable.Set_Skills()
	var _skill_serializable_array: Array[Item_Serializable] = _user.party_member_serializable.Get_Skills()
	#-------------------------------------------------------------------------------
	for _i in _skill_serializable_array.size():
		var _skill_button:Button = Create_Skill_Button(_skill_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():SkillMenu_SkillButton_Selected(_skill_serializable_array[_i])
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_skill_button, _selected_1, _submit_1, _cancel_0, _w, _s, _skill_a, _skill_d)
		user_menu_skill_button_array.append(_skill_button)
		user_menu_skill_content.add_child(_skill_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_stats_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_statuseffect_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_equip_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(user_menu_skill_button_array)
	#-------------------------------------------------------------------------------
	User_Menu_Show_and_Enable_All_Button()
	User_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button_0(user_menu_info_container, user_menu_info_button)
	user_menu_title.text = tr("user_menu_info_label")
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func PauseMenu_StatusMenu_Exit_Common(_index:int):
	user_menu.hide()
	#-------------------------------------------------------------------------------
	Destroy_Button_Array(user_menu_stats_button_array)
	Destroy_Button_Array(user_menu_statuseffect_button_array)
	Destroy_Button_Array(user_menu_equip_button_array)
	Destroy_Button_Array(user_menu_skill_button_array)
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		PartyMember_Button_Set_HP_and_SP(pause_menu_party_button_array[_i], friend_party[_i])
	#-------------------------------------------------------------------------------
	pause_menu.show()
	singleton.Move_to_Button(pause_menu_party_button_array[_index].button)
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func PauseMenu_StatusButton_PartyButton_Cancel():
	pause_menu_button_array[3].disabled = false
	singleton.Move_to_Button(pause_menu_button_array[3])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func User_Menu_Info_Button_Selected(_user:Party_Member_Node):
	user_menu_info_image.texture = _user.party_member_serializable.party_member_resource.body_sprite
	#-------------------------------------------------------------------------------
	user_menu_description.text = tr("description_"+get_instance_filename(_user))
	user_menu_description.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	user_menu_cost_label.text = ""
	user_menu_tp_cost_num_label.text = ""
	user_menu_cooldown_num_label.text = ""
	#-------------------------------------------------------------------------------
	user_menu_held_label.text = ""
	user_menu_hold_num_label.text = ""
	user_menu_storage_num_label.text = ""
	#-------------------------------------------------------------------------------
	user_menu_info_party_button.button.disabled = true
	PartyMember_Button_Set_HP_and_SP(user_menu_info_party_button, _user)
	user_menu_info_party_button.texture.texture = _user.party_member_serializable.party_member_resource.face_sprite
	PartyMember_Button_Set_Idiome(user_menu_info_party_button, _user)
	#-------------------------------------------------------------------------------
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU - OPTIONS
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Subited() -> void:
	OptionMenu_BackButton_Common()
	singleton.Move_to_Button(pause_menu_button_array[4])
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Canceled() -> void:
	OptionMenu_BackButton_Common()
	singleton.Move_to_Button(pause_menu_button_array[4])
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Common() -> void:
	singleton.optionMenu.Save_OptionSaveData_Json()
	singleton.optionMenu.hide()
	Set_Idiome()
	pause_menu.show()
#-------------------------------------------------------------------------------
func Set_Idiome():
	#-------------------------------------------------------------------------------
	pause_menu_title_label.text = tr("pause_menu_title_label")
	pause_menu_party_label.text = tr("pause_menu_party_members_label")
	#-------------------------------------------------------------------------------
	for _i in pause_menu_button_array.size():
		pause_menu_button_array[_i].text = "  "+tr("pause_menu_button_"+str(_i))+"  "
	#-------------------------------------------------------------------------------
	SetMoney_Label()
	#-------------------------------------------------------------------------------
	item_menu_all_button.text = "  "+tr("item_menu_all_items_label")+"  "
	item_menu_consumable_button.text = "  "+tr("item_menu_consumable_items_label")+"  "
	item_menu_equip_button.text = "  "+tr("item_menu_equip_items_label")+"  "
	item_menu_key_button.text = "  "+tr("item_menu_key_items_label")+"  "
	#-------------------------------------------------------------------------------
	item_menu_description_title.text = tr("item_menu_description_label")
	#-------------------------------------------------------------------------------
	user_menu_info_button.text = "  "+tr("user_menu_info_label")+"  "
	user_menu_stats_button.text = "  "+tr("user_menu_stats_label")+"  "
	user_menu_statuseffect_button.text = "  "+tr("user_menu_status_effect_label")+"  "
	user_menu_equip_button.text = "  "+tr("user_menu_equip_label")+"  "
	user_menu_skill_button.text = "  "+tr("user_menu_skill_label")+"  "
	#-------------------------------------------------------------------------------
	user_menu_description_title.text = tr("item_menu_description_label")
	#-------------------------------------------------------------------------------
	for _i in pause_menu_party_button_array.size():
		PartyMember_Button_Set_Idiome(pause_menu_party_button_array[_i], friend_party[_i])
	#-------------------------------------------------------------------------------
	for _i in battle_menu_button.size():
		battle_menu_button[_i].text = "  "+tr("battle_menu_button_"+str(_i))+"  "
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SAVE MENU
#-------------------------------------------------------------------------------
func SaveMenu_Open(_s:String, _dialogue:String):	# Used by "SaveSpot_Script".
	Dialogue_Open()
	singleton.Common_Submited()
	await Dialogue(_dialogue)
	Dialogue_Close()
	#-------------------------------------------------------------------------------
	pause_menu_panel.show()
	savespot_menu.show()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(savespot_menu_button_array[0], func():singleton.Common_Selected(), func():SaveMenu_SaveButton_Submit(_s), func():SaveMenu_Close())
	singleton.Set_Button(savespot_menu_button_array[1], func():singleton.Common_Selected(), func():SaveMenu_TeleportButton_Submit(), func():SaveMenu_Close())
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(savespot_menu_button_array[0])
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	PauseOn()
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
	Save_All_Data(_s)
	singleton.Play_SFX_Save()
#-------------------------------------------------------------------------------
func SaveMenu_TeleportButton_Submit():
	savespot_menu.hide()
	teleport_menu.show()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(teleport_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(teleport_menu_description)
	#-------------------------------------------------------------------------------
	var _a: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _d: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():TeleportMenu_No_Description()
	var _submit_0: Callable = func():pass
	#-------------------------------------------------------------------------------
	var _cancel_0: Callable = func():
		Destroy_Button_Array(teleport_menu_bonfire_button_array)
		savespot_menu.show()
		teleport_menu.hide()
		singleton.Move_to_Button(savespot_menu_button_array[1])
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(teleport_menu_zone_button_array[0], _selected_0, _submit_0, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	var _array: Array = singleton.currentSaveData_Json.get("teleport_options", [])
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		_button.theme = ui_theme
		_button.text = "  "+tr("name_"+_array[_i].get("room", ""))+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		teleport_menu_bonfire_content.add_child(_button)
		teleport_menu_bonfire_button_array.append(_button)
		#-------------------------------------------------------------------------------
		var _selected_1: Callable = func():TeleportMenu_TeleportButton_Select(_array[_i])
		var _submit_1: Callable = func():TeleportMenu_TeleportButton_Submit(_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_button, _selected_1, _submit_1, _cancel_0, _w, _s, _a, _d)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(teleport_menu_bonfire_button_array)
	#-------------------------------------------------------------------------------
	if(teleport_menu_bonfire_button_array.size() > 0):
		var _index = Find_Bonfire_Id_by_String(_array)
		#-------------------------------------------------------------------------------
		teleport_menu_zone_button_array[0].disabled = true
		singleton.Move_to_Button(teleport_menu_bonfire_button_array[_index])
		singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	else:
		teleport_menu_zone_button_array[0].disabled = false
		singleton.Move_to_Button(teleport_menu_zone_button_array[0])
		singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	#teleport_menu_bonfire_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func Find_Bonfire_Id_by_String(_array: Array) -> int:
	var _index = 0
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		if(_array[_i].get("room", "") == room_test.room_id):
			_index = _i
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _index
#-------------------------------------------------------------------------------
func Add_New_SaveSpot_for_Teleporting_Options(_savespot: String) -> Dictionary:		# Used by "SaveSpot_Script".
	var _array: Array = singleton.currentSaveData_Json.get("teleport_options", [])
	#-------------------------------------------------------------------------------
	for _i in _array.size():
		#-------------------------------------------------------------------------------
		if(_array[_i].get("room", "") == room_test.room_id):
			var _dictionaty: Dictionary = _array[_i] as Dictionary
			_dictionaty["savespot"] = _savespot
			#-------------------------------------------------------------------------------
			sort_by_name_ascending(_array)
			#-------------------------------------------------------------------------------
			singleton.currentSaveData_Json["teleport_options"] = _array
			return _dictionaty
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _dictionaty_new: Dictionary = {}
	_dictionaty_new["room"] = room_test.room_id
	_dictionaty_new["savespot"] = _savespot
	_array.append(_dictionaty_new)
	#-------------------------------------------------------------------------------
	sort_by_name_ascending(_array)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json["teleport_options"] = _array
	return _dictionaty_new
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TELEPORT MENU
#-------------------------------------------------------------------------------
func TeleportMenu_TeleportButton_Select(_dictionary:Dictionary):
	var _room_name: String = _dictionary.get("room", "")
	#-------------------------------------------------------------------------------
	teleport_menu_rect.show()
	teleport_menu_rect.texture = load("res://Assets/room_previews/"+_room_name+".jpg")
	teleport_menu_description.text = tr("description_"+_room_name)
	teleport_menu_description.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func TeleportMenu_TeleportButton_Submit(_dictionary:Dictionary):
	var _room_name: String = _dictionary.get("room", "")
	#-------------------------------------------------------------------------------
	var _new_room: Room_Script = load(Get_Room_Path(_room_name)).instantiate() as Room_Script
	_new_room.room_id = _room_name
	#-------------------------------------------------------------------------------
	var _savespot_script_array: Array[Node] = _new_room.find_children(_dictionary["savespot"], "SaveSpot_Script")
	#-------------------------------------------------------------------------------
	if(_savespot_script_array.size() > 0):
		var _savespot_script: SaveSpot_Script = _savespot_script_array[0] as SaveSpot_Script
		#-------------------------------------------------------------------------------
		Animation_StateMachine(friend_party[0].animation_tree, "", "Idle")
		friend_party[0].is_Moving = false
		Face_Left(friend_party[0], false)
		player_characterbody2d.global_position = _savespot_script.offset.global_position
		#-------------------------------------------------------------------------------
		for _i in range(1, friend_party.size()):
			Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
			friend_party[_i].is_Moving = false
			Face_Left(friend_party[_i], false)
			friend_party[_i].global_position = _savespot_script.offset.global_position
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	world_2d.call_deferred("add_child", _new_room)
	#-------------------------------------------------------------------------------
	room_test.queue_free()							#Importante: Cuidado con el Orden
	room_test = _new_room							#Importante: Cuidado con el Orden
	_new_room.Set_Room()						#Importante: Cuidado con el Orden
	camera.global_position = Camera_Set_Target_Position()	#Importante: Cuidado con el Orden
	#-------------------------------------------------------------------------------
	teleport_menu.hide()
	singleton.Play_BGM(singleton.stage1)
	pause_menu_panel.hide()
	PauseOff()
	Destroy_Button_Array(teleport_menu_bonfire_button_array)
	singleton.Play_SFX_Teleport()
#-------------------------------------------------------------------------------
func Teleport_From_1_Room_to_Another(_room_name:String, _warp_name:String):
	var _new_room: Room_Script = load(Get_Room_Path(_room_name)).instantiate() as Room_Script
	_new_room.room_id = _room_name
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
		friend_party[_i].is_Moving = false
		var _warp_array: Array[Node] = _new_room.find_children(_warp_name, "Warp_Script")
		var _warp_script: Warp_Script = _warp_array[0] as Warp_Script
		#-------------------------------------------------------------------------------
		if(_i > 0):
			friend_party[_i].global_position = _warp_script.offset.global_position
		#-------------------------------------------------------------------------------
		else:
			player_characterbody2d.global_position = _warp_script.offset.global_position
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	world_2d.call_deferred("add_child", _new_room)
	#-------------------------------------------------------------------------------
	room_test.queue_free()							#Importante: Cuidado con el Orden
	room_test = _new_room							#Importante: Cuidado con el Orden
	_new_room.Set_Room()						#Importante: Cuidado con el Orden
	camera.global_position = Camera_Set_Target_Position()	#Importante: Cuidado con el Orden
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SAVE FUNCTIONS
#-------------------------------------------------------------------------------
func Save_All_Data(_s:String):
	Save_Keys_Dictionary()
	#-------------------------------------------------------------------------------
	Save_ConsumableItems()
	Save_Equip()
	Save_KeyItems()
	#-------------------------------------------------------------------------------
	Save_Friends()
	#-------------------------------------------------------------------------------
	Save_Room_and_SaveSpot(_s)
	#-------------------------------------------------------------------------------
	singleton.SaveCurrent_SaveData_Json()
#-------------------------------------------------------------------------------
func Save_Room_and_SaveSpot(_s:String):
	var _dictionaty: Dictionary = {}
	_dictionaty["room"] = room_test.room_id
	_dictionaty["savespot"] = _s
	singleton.currentSaveData_Json.set("current_savespot", _dictionaty)
#-------------------------------------------------------------------------------
func Save_Keys_Dictionary():
	singleton.currentSaveData_Json.set("key_dictionary", key_dictionary)
#-------------------------------------------------------------------------------
func Save_ConsumableItems():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	var _array: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.consumable_item_array.size():
		var _dictionary: Dictionary = _inventory_serializable.consumable_item_array[_i].SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("item_array", _array)
#-------------------------------------------------------------------------------
func Save_KeyItems():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	var _array: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.key_item_array.size():
		var _dictionary: Dictionary = _inventory_serializable.key_item_array[_i].SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("key_item_array", _array)
	singleton.currentSaveData_Json.set("money", _inventory_serializable.money_serializable.stored)
#-------------------------------------------------------------------------------
func Save_Equip():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	var _array: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.equip_item_array.size():
		var _dictionary: Dictionary = _inventory_serializable.equip_item_array[_i].SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("equip_serializable_array", _array)
#-------------------------------------------------------------------------------
func Save_Friends():
	var _array: Array[Dictionary] = []
	for _i in friend_party.size():
		var _dictionary: Dictionary = friend_party[_i].party_member_serializable.SaveData_Constructor()
		_array.append(_dictionary)
	#-------------------------------------------------------------------------------
	singleton.currentSaveData_Json.set("friend_party", _array)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GET ID FUNCTIONS
#-------------------------------------------------------------------------------
func Get_Item_Script_ID(_node:Node) -> String:
	var _s: String = room_test.room_id+"_"+_node.name
	return _s
#-------------------------------------------------------------------------------
func Get_Room_Path(_room_name:String) -> String:
	return "res://Nodes/Prefabs/Rooms/"+_room_name+".tscn"
#-------------------------------------------------------------------------------
func Get_MerchantId_and_ItemId_and_Hold(_name:String, _resource:Resource) -> String:
	var _id: String = room_test.room_id+"_"+_name+"_"+get_resource_filename(_resource)+"_hold"
	return _id
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region LOAD FUNCTIONS
#-------------------------------------------------------------------------------
func Load_All_Data():
	var _path: String = singleton.GetCurrent_SaveDataPath_Json()
	#-------------------------------------------------------------------------------
	if(ResourceLoader.exists(_path)):
		Load_Keys_Dictionary()
		#-------------------------------------------------------------------------------
		Load_ConsumableItems()
		Load_Equip()
		Load_KeyItems()
		#-------------------------------------------------------------------------------
		Load_Friends()
		#-------------------------------------------------------------------------------
		Load_Room_and_SaveSpot()
	#-------------------------------------------------------------------------------
	else:
		room_test.room_id = room_test.name
		#-------------------------------------------------------------------------------
		for _i in friend_party.size():
			friend_party[_i].party_member_serializable.Set_Empty_EquipSlots_Types()
		#-------------------------------------------------------------------------------
		#Save_All_Data("player_starting_position")
		#-------------------------------------------------------------------------------
		#singleton.SaveCurrent_SaveData_Json()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_Room_and_SaveSpot():
	var _dictionaty: Dictionary = singleton.currentSaveData_Json.get("current_savespot", {})
	var _room_name: String = _dictionaty.get("room", "")
	var _room_savespot_name: String = _dictionaty.get("savespot", "")
	#-------------------------------------------------------------------------------
	var _new_room: Room_Script = load(Get_Room_Path(_room_name)).instantiate() as Room_Script
	world_2d.call_deferred("add_child", _new_room)
	room_test.queue_free()
	room_test = _new_room
	#-------------------------------------------------------------------------------
	room_test.room_id = _room_name
	var _savespot_script_array: Array[Node] = _new_room.find_children(_room_savespot_name, "SaveSpot_Script")
	#-------------------------------------------------------------------------------
	if(_savespot_script_array.size() > 0):
		var _savespot_script: SaveSpot_Script = _savespot_script_array[0] as SaveSpot_Script
		#-------------------------------------------------------------------------------
		Animation_StateMachine(friend_party[0].animation_tree, "", "Idle")
		friend_party[0].is_Moving = false
		Face_Left(friend_party[0], false)
		player_characterbody2d.global_position = _savespot_script.offset.global_position
		#-------------------------------------------------------------------------------
		for _i in range(1, friend_party.size()):
			Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
			friend_party[_i].is_Moving = false
			Face_Left(friend_party[_i], false)
			friend_party[_i].global_position = _savespot_script.offset.global_position
		#-------------------------------------------------------------------------------
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
func Load_ConsumableItems():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	_inventory_serializable.consumable_item_array.clear()
	#-------------------------------------------------------------------------------
	var _item_data: Array = singleton.currentSaveData_Json.get("item_array", [])
	#-------------------------------------------------------------------------------
	for _i in _item_data.size():
		var _item_serializable: Item_Serializable = Item_Serializable.new()
		_item_serializable.LoadData_Constructor(_item_data[_i])
		_inventory_serializable.consumable_item_array.append(_item_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_KeyItems():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	_inventory_serializable.key_item_array.clear()
	#-------------------------------------------------------------------------------
	var _keyitem_data: Array = singleton.currentSaveData_Json.get("key_item_array", [])
	#-------------------------------------------------------------------------------
	for _i in _keyitem_data.size():
		var _keyitem_serializable: Key_Item_Serializable = Key_Item_Serializable.new()
		_keyitem_serializable.LoadData_Constructor(_keyitem_data[_i])
		_inventory_serializable.key_item_array.append(_keyitem_serializable)
	#-------------------------------------------------------------------------------
	_inventory_serializable.money_serializable.stored = singleton.currentSaveData_Json.get("money", 0)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_Equip():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	_inventory_serializable.equip_item_array.clear()
	#-------------------------------------------------------------------------------
	var _equip_data: Array = singleton.currentSaveData_Json.get("equip_serializable_array", [])
	#-------------------------------------------------------------------------------
	for _i in _equip_data.size():
		var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
		_equip_serializable.LoadData_Constructor(_equip_data[_i])
		_inventory_serializable.equip_item_array.append(_equip_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Load_Friends():
	var _friend_data: Array = singleton.currentSaveData_Json.get("friend_party", [])
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		friend_party[_i].party_member_serializable.LoadData_Constructor(_friend_data[_i])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MARKET MENU
#-------------------------------------------------------------------------------
func Open_Market(_merchant_name:String, _consumableitem_array:Array[Item_Serializable], _equipitem_array:Array[Equip_Serializable], _keyitem_array:Array[Key_Item_Serializable]):
	item_menu.show()
	PauseOn()
	pause_menu_panel.show()
	#-------------------------------------------------------------------------------
	money_menu.show()
	SetMoney_Label()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(item_menu_description)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(item_menu_description)
	#-------------------------------------------------------------------------------
	var _all_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_all_scrollContainer, item_menu_all_button)
		Enable_Menu_And_Move_to_Button(item_menu_key_scrollContainer, item_menu_key_button_array, item_menu_key_button)
		item_menu_title.text = tr("item_menu_key_items_label")
	#-------------------------------------------------------------------------------
	var _all_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_all_scrollContainer, item_menu_all_button)
		Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
		item_menu_title.text = tr("item_menu_consumable_items_label")
	#-------------------------------------------------------------------------------
	var _consumable_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button)
		Enable_Menu_And_Move_to_Button(item_menu_all_scrollContainer, item_menu_all_button_array, item_menu_all_button)
		item_menu_title.text = tr("item_menu_all_items_label")
	#-------------------------------------------------------------------------------
	var _consumable_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button)
		Enable_Menu_And_Move_to_Button(item_menu_equip_scrollContainer, item_menu_equip_button_array, item_menu_equip_button)
		item_menu_title.text = tr("item_menu_equip_items_label")
	#-------------------------------------------------------------------------------
	var _equip_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_equip_scrollContainer, item_menu_equip_button)
		Enable_Menu_And_Move_to_Button(item_menu_consumable_scrollContainer, item_menu_consumable_button_array, item_menu_consumable_button)
		item_menu_title.text = tr("item_menu_consumable_items_label")
	#-------------------------------------------------------------------------------
	var _equip_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_equip_scrollContainer, item_menu_equip_button)
		Enable_Menu_And_Move_to_Button(item_menu_key_scrollContainer, item_menu_key_button_array, item_menu_key_button)
		item_menu_title.text = tr("item_menu_key_items_label")
	#-------------------------------------------------------------------------------
	var _key_a: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_key_scrollContainer, item_menu_key_button)
		Enable_Menu_And_Move_to_Button(item_menu_equip_scrollContainer, item_menu_equip_button_array, item_menu_equip_button)
		item_menu_title.text = tr("item_menu_equip_items_label")
	#-------------------------------------------------------------------------------
	var _key_d: Callable = func():
		Hide_Control_and_Enable_Button(item_menu_key_scrollContainer, item_menu_key_button)
		Enable_Menu_And_Move_to_Button(item_menu_all_scrollContainer, item_menu_all_button_array, item_menu_all_button)
		item_menu_title.text = tr("item_menu_all_items_label")
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():Item_Menu_No_Description()
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():Close_Market()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WSAD(item_menu_all_button, _selected_0, _submit_0, _cancel_0, _w, _s, _all_a, _all_d)
	singleton.Set_Button_WSAD(item_menu_consumable_button, _selected_0, _submit_0, _cancel_0, _w, _s, _consumable_a, _consumable_d)
	singleton.Set_Button_WSAD(item_menu_equip_button, _selected_0, _submit_0, _cancel_0, _w, _s, _equip_a, _equip_d)
	singleton.Set_Button_WSAD(item_menu_key_button, _selected_0, _submit_0, _cancel_0, _w, _s, _key_a, _key_d)
	#-------------------------------------------------------------------------------
	for _i in _consumableitem_array.size():
		var _hold: int = _consumableitem_array[_i].stored
		var _cooldown: int = _consumableitem_array[_i].cooldown
		#-------------------------------------------------------------------------------
		var _consumableitem_button: Button = Create_ConsumableItem_InMarket_Button(_consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		var _selected: Callable = func():BuyMenu_ItemConsumable_Selected(_consumableitem_array[_i])
		var _submit_consumable_item: Callable = func():BuyMenu_ItemConsumable_Submit(_consumableitem_button, _merchant_name, _consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_consumableitem_button, _selected, _submit_consumable_item, _cancel_0, _w, _s, _consumable_a, _consumable_d)
		item_menu_consumable_content.add_child(_consumableitem_button)
		item_menu_consumable_button_array.append(_consumableitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_ConsumableItem_InMarket_Button(_consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		var _submit_all_item: Callable = func():BuyMenu_ItemConsumable_Submit(_allitem_button, _merchant_name, _consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected, _submit_all_item, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _equipitem_array.size():
		var _equipitem_button: Button = Create_EquipItem_InMarket_Button(_equipitem_array[_i])
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_EquipItem_InMarket_Button(_equipitem_array[_i])
		#-------------------------------------------------------------------------------
		var _selected: Callable = func():BuyMenu_EquipItem_Selected(_equipitem_array[_i])
		var _submit_equip_item: Callable = func():BuyMenu_EquipItem_Submit(_equipitem_button, _merchant_name, _equipitem_array[_i], _equipitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_equipitem_button, _selected, _submit_equip_item, _cancel_0, _w, _s, _equip_a, _equip_d)
		item_menu_equip_content.add_child(_equipitem_button)
		item_menu_equip_button_array.append(_equipitem_button)
		#-------------------------------------------------------------------------------
		var _submit_all_item: Callable = func():BuyMenu_EquipItem_Submit(_allitem_button, _merchant_name, _equipitem_array[_i], _equipitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected, _submit_all_item, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	for _i in _keyitem_array.size():
		var _keyitem_button: Button = Create_KeyItem_InMarket_Button(_keyitem_array[_i])
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_KeyItem_InMarket_Button(_keyitem_array[_i])
		#-------------------------------------------------------------------------------
		var _selected: Callable = func():BuyMenu_KeyItem_Selected(_keyitem_array[_i])
		var _submit_keyitem: Callable = func():BuyMenu_KeyItem_Submit(_keyitem_button, _merchant_name, _keyitem_array[_i], _keyitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_keyitem_button, _selected, _submit_keyitem, _cancel_0, _w, _s, _key_a, _key_d)
		item_menu_key_content.add_child(_keyitem_button)
		item_menu_key_button_array.append(_keyitem_button)
		#-------------------------------------------------------------------------------
		var _submit_allitem: Callable = func():BuyMenu_KeyItem_Submit(_allitem_button, _merchant_name, _keyitem_array[_i], _keyitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD(_allitem_button, _selected, _submit_allitem, _cancel_0, _w, _s, _all_a, _all_d)
		item_menu_all_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_all_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	Item_Menu_Show_and_Enable_All_Button()
	Item_Menu_Hide_All_ScrollContainer()
	Enable_Menu_And_Move_to_Button(item_menu_all_scrollContainer, item_menu_all_button_array, item_menu_all_button)
	item_menu_title.text = tr("item_menu_all_items_label")
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	await dialogue_signal
#-------------------------------------------------------------------------------
func Close_Market():
	item_menu.hide()
	dialogue_signal.emit()
	pause_menu_panel.hide()
	money_menu.hide()
	#-------------------------------------------------------------------------------
	Destroy_Button_Array(item_menu_all_button_array)
	Destroy_Button_Array(item_menu_consumable_button_array)
	Destroy_Button_Array(item_menu_equip_button_array)
	Destroy_Button_Array(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	await get_tree().physics_frame
	PauseOff()
#-------------------------------------------------------------------------------
func BuyMenu_ItemConsumable_Selected(_item_serializable: Item_Serializable):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.consumable_item_array.size():
		#-------------------------------------------------------------------------------
		if(_inventory_serializable.consumable_item_array[_i].item_resource == _item_serializable.item_resource):
			ItemMenu_Consumable_ItemButton_Selected(_inventory_serializable.consumable_item_array[_i])
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _item_serializable_new: Item_Serializable = _item_serializable.Constructor()
	_item_serializable_new.hold = 0
	_item_serializable_new.stored = 0
	ItemMenu_Consumable_ItemButton_Selected(_item_serializable_new)
	return
#-------------------------------------------------------------------------------
func BuyMenu_ItemConsumable_Submit(_button:Button, _merchant_name: String, _item_serializable: Item_Serializable):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _price: int = _item_serializable.price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_price <= _inventory_serializable.money_serializable.stored):
			_item_serializable.hold -= how_many_would_you_buy
			_inventory_serializable.money_serializable.stored -= _price
			#-------------------------------------------------------------------------------
			var _id: String = Get_MerchantId_and_ItemId_and_Hold(_merchant_name, _item_serializable.item_resource)
			key_dictionary[_id] = _item_serializable.stored
			#-------------------------------------------------------------------------------
			var _inventory_item_serializable: Item_Serializable = Add_ConsumableItem_to_Inventory(_item_serializable, how_many_would_you_buy)
			Set_ConsumableItem_Information(_inventory_item_serializable)
			#-------------------------------------------------------------------------------
			Set_Max_Items_You_Can_Buy(99, _item_serializable.price, _price)
			SetMoney_Label()
			Print_How_Many_Do_You_Buy(_item_serializable.price, false, 99)
			#-------------------------------------------------------------------------------
			singleton.Play_SFX_Shop()
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _up: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_item_serializable.price, 10, false, 99)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_item_serializable.price, 10, false, 99)
	#-------------------------------------------------------------------------------
	var _left: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_item_serializable.price, 1, false, 99)
	#-------------------------------------------------------------------------------
	var _right: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_item_serializable.price, 1, false, 99)
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = tr("name_"+get_resource_filename(_item_serializable.item_resource))
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_item_serializable.price, false, 99)
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func BuyMenu_EquipItem_Selected(_equip_serializable: Equip_Serializable):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.equip_item_array.size():
		#----------------------------------------------------------------
		if(_inventory_serializable.equip_item_array[_i].equip_resource == _equip_serializable.equip_resource):
			ItemMenu_Equipment_ItemButton_Selected(_inventory_serializable.equip_item_array[_i])
			return
		#----------------------------------------------------------------
	#----------------------------------------------------------------
	var _equip_serializable_new: Equip_Serializable = _equip_serializable.Constructor()
	_equip_serializable_new.stored = 0
	ItemMenu_Equipment_ItemButton_Selected(_equip_serializable_new)
	return
#-------------------------------------------------------------------------------
func BuyMenu_EquipItem_Submit(_button:Button, _merchant_name: String, _equip_serializable: Equip_Serializable, _equipitem_button:Button, _allitem_button:Button):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _price: int = _equip_serializable.price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_price <= _inventory_serializable.money_serializable.stored and how_many_would_you_buy <= _equip_serializable.stored):
			_equip_serializable.stored -= how_many_would_you_buy
			_inventory_serializable.money_serializable.stored -= _price
			#-------------------------------------------------------------------------------
			var _id: String = Get_MerchantId_and_ItemId_and_Hold(_merchant_name, _equip_serializable.equip_resource)
			key_dictionary[_id] = _equip_serializable.stored
			#-------------------------------------------------------------------------------
			Change_EquipItem_Hold_Label(_equip_serializable, _equipitem_button)
			Change_EquipItem_Hold_Label(_equip_serializable, _allitem_button)
			#-------------------------------------------------------------------------------
			var _inventory_equip_serializable: Equip_Serializable = Add_EquipItem_to_Inventory(_equip_serializable, how_many_would_you_buy)
			Set_EquipItem_Information(_inventory_equip_serializable)
			#-------------------------------------------------------------------------------
			Set_Max_Items_You_Can_Buy(_equip_serializable.stored, _equip_serializable.price, _price)
			SetMoney_Label()
			Print_How_Many_Do_You_Buy(_equip_serializable.price, true, _equip_serializable.stored)
			#-------------------------------------------------------------------------------
			singleton.Play_SFX_Shop()
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _up: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_equip_serializable.price, 10, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_equip_serializable.price, 10, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	var _left: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_equip_serializable.price, 1, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	var _right: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_equip_serializable.price, 1, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = tr("name_"+get_resource_filename(_equip_serializable.equip_resource))
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_equip_serializable.price, true, _equip_serializable.stored, )
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func BuyMenu_KeyItem_Selected(_keyitem_serializable: Key_Item_Serializable):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#----------------------------------------------------------------
	for _i in _inventory_serializable.key_item_array.size():
		#----------------------------------------------------------------
		if(_inventory_serializable.key_item_array[_i].key_item_resource == _keyitem_serializable.key_item_resource):
			ItemMenu_KeyItem_ItemButton_Selected(_inventory_serializable.key_item_array[_i])
			return
		#----------------------------------------------------------------
	#----------------------------------------------------------------
	var _keyitem_serializable_new: Key_Item_Serializable = _keyitem_serializable.Constructor()
	_keyitem_serializable_new.stored = 0
	ItemMenu_KeyItem_ItemButton_Selected(_keyitem_serializable_new)
	return
#-------------------------------------------------------------------------------
func BuyMenu_KeyItem_Submit(_button:Button, _merchant_name: String, _keyitem_serializable: Key_Item_Serializable, _keyitem_button:Button, _allitem_button:Button):
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _price: int = _keyitem_serializable.price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_price <= _inventory_serializable.money_serializable.stored and how_many_would_you_buy <= _keyitem_serializable.stored):
			_keyitem_serializable.stored -= how_many_would_you_buy
			_inventory_serializable.money_serializable.stored -= _price
			#-------------------------------------------------------------------------------
			var _id: String = Get_MerchantId_and_ItemId_and_Hold(_merchant_name, _keyitem_serializable.key_item_resource)
			key_dictionary[_id] = _keyitem_serializable.stored
			#-------------------------------------------------------------------------------
			Change_KeyItem_Hold_Label(_keyitem_serializable, _keyitem_button)
			Change_KeyItem_Hold_Label(_keyitem_serializable, _allitem_button)
			#-------------------------------------------------------------------------------
			var _inventory_keyitem_serializable: Key_Item_Serializable = Add_KeyItem_to_Inventory(_keyitem_serializable, how_many_would_you_buy)
			Set_KeyItem_Information(_inventory_keyitem_serializable)
			#-------------------------------------------------------------------------------
			Set_Max_Items_You_Can_Buy(_keyitem_serializable.stored, _keyitem_serializable.price, _price)
			SetMoney_Label()
			Print_How_Many_Do_You_Buy(_keyitem_serializable.price, true, _keyitem_serializable.stored)
			#-------------------------------------------------------------------------------
			singleton.Play_SFX_Shop()
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _up: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_keyitem_serializable.price, 10, true, _keyitem_serializable.stored)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_keyitem_serializable.price, 10, true, _keyitem_serializable.stored)
	#-------------------------------------------------------------------------------
	var _left: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_keyitem_serializable.price, 1, true, _keyitem_serializable.stored)
	#-------------------------------------------------------------------------------
	var _right: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_keyitem_serializable.price, 1, true, _keyitem_serializable.stored)
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = tr("name_"+get_resource_filename(_keyitem_serializable.key_item_resource))
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_keyitem_serializable.price, true, _keyitem_serializable.stored)
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func Increase_How_Many_Do_Want_to_Buy(_original_price:int, _int:int, _has_limited_stored:bool, _stored:int):
	var _old_value: int = how_many_would_you_buy
	how_many_would_you_buy += _int
	#-------------------------------------------------------------------------------
	var _price: int = _original_price * how_many_would_you_buy
	#-------------------------------------------------------------------------------
	Set_Max_Items_You_Can_Buy(_stored, _original_price, _price)
	Print_How_Many_Do_You_Buy(_original_price, _has_limited_stored, _stored)
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy > _old_value):
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Decrease_How_Many_Do_Want_to_Buy(_original_price:int, _int:int, _has_limited_stored:bool, _stored:int):
	var _old_value: int = how_many_would_you_buy
	how_many_would_you_buy -= _int
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy < 1):
		how_many_would_you_buy = 1
	#-------------------------------------------------------------------------------
	Print_How_Many_Do_You_Buy(_original_price, _has_limited_stored, _stored)
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy < _old_value):
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Change_EquipItem_Hold_Label(_equip_serializable: Equip_Serializable, _button:Button):
	var _label: Label = _button.get_child(0) as Label
	_label.text = ""
	_label.text += "["+str(_equip_serializable.stored)+"]  "
	_label.text += Get_Money_Label(_equip_serializable.price)+"  "
#-------------------------------------------------------------------------------
func Set_Max_Items_You_Can_Buy(_stored:int, _original_price:int, _whole_cost:int):
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy > _stored):
		how_many_would_you_buy = _stored
	#-------------------------------------------------------------------------------
	while(inventory_serializable.money_serializable.stored < _whole_cost):
		how_many_would_you_buy -= 1
		_whole_cost = _original_price * how_many_would_you_buy
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy < 1):
		how_many_would_you_buy = 1
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Change_KeyItem_Hold_Label(_keyitem_serializable: Key_Item_Serializable, _button:Button):
	var _label: Label = _button.get_child(0) as Label
	_label.text = ""
	_label.text += "["+str(_keyitem_serializable.stored)+"]  "
	_label.text += Get_Money_Label(_keyitem_serializable.price)+"  "
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region RESTORED SKILLS & ITEMS FUNCTIONS
#-------------------------------------------------------------------------------
func Fill_the_ConsumableItems_Stored_from_Hold():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.consumable_item_array.size():
		#-------------------------------------------------------------------------------
		if(_inventory_serializable.consumable_item_array[_i].hold > _inventory_serializable.consumable_item_array[_i].item_resource.max_hold):
			var _extra: int = _inventory_serializable.consumable_item_array[_i].hold - _inventory_serializable.consumable_item_array[_i].item_resource.max_hold
			_inventory_serializable.consumable_item_array[_i].hold = _inventory_serializable.consumable_item_array[_i].item_resource.max_hold
			_inventory_serializable.consumable_item_array[_i].stored += _extra
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Fill_the_ConsumableItems_Hold_from_Stored_and_Remove_Cooldown():
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.consumable_item_array.size():
		#-------------------------------------------------------------------------------
		_inventory_serializable.consumable_item_array[_i].cooldown = 0
		#-------------------------------------------------------------------------------
		if(_inventory_serializable.consumable_item_array[_i].hold < _inventory_serializable.consumable_item_array[_i].item_resource.max_hold):
			var _lo_que_falta: int = _inventory_serializable.consumable_item_array[_i].item_resource.max_hold - _inventory_serializable.consumable_item_array[_i].hold 
			_inventory_serializable.consumable_item_array[_i].stored -= _lo_que_falta
			#-------------------------------------------------------------------------------
			if(_inventory_serializable.consumable_item_array[_i].stored < 0):
				_lo_que_falta += _inventory_serializable.consumable_item_array[_i].stored
				_inventory_serializable.consumable_item_array[_i].stored = 0
			#-------------------------------------------------------------------------------
			_inventory_serializable.consumable_item_array[_i].hold += _lo_que_falta
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func ReFill_All_Skills():
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		#-------------------------------------------------------------------------------
		for _j in friend_party[_i].party_member_serializable.skill_serializable_array.size():
			friend_party[_i].party_member_serializable.skill_serializable_array[_j].hold = friend_party[_i].party_member_serializable.skill_serializable_array[_j].item_resource.max_hold
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Add_ConsumableItem_to_Inventory(_item_serializable: Item_Serializable, _hold:int) -> Item_Serializable:
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	for _i in _inventory_serializable.consumable_item_array.size():
		#-------------------------------------------------------------------------------
		if(_inventory_serializable.consumable_item_array[_i].item_resource == _item_serializable.item_resource):
			#-------------------------------------------------------------------------------
			if(_item_serializable.item_resource.max_hold > 0):
				_inventory_serializable.consumable_item_array[_i].hold += _hold
				#-------------------------------------------------------------------------------
				if(_inventory_serializable.consumable_item_array[_i].hold > _item_serializable.item_resource.max_hold):
					var _extra: int = _inventory_serializable.consumable_item_array[_i].hold - _item_serializable.item_resource.max_hold
					_inventory_serializable.consumable_item_array[_i].hold = _item_serializable.item_resource.max_hold
					_inventory_serializable.consumable_item_array[_i].stored += _extra
					return _inventory_serializable.consumable_item_array[_i]
				#-------------------------------------------------------------------------------
				else:
					return _inventory_serializable.consumable_item_array[_i]
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				_inventory_serializable.consumable_item_array[_i].stored += _hold
				return _inventory_serializable.consumable_item_array[_i]
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _new_item: Item_Serializable = _item_serializable.Constructor()
	_new_item.item_resource = _item_serializable.item_resource
	#-------------------------------------------------------------------------------
	if(_item_serializable.item_resource.max_hold > 0):
		_new_item.hold = _hold
		#-------------------------------------------------------------------------------
		if(_new_item.hold > _item_serializable.item_resource.max_hold):
			var _extra: int = _new_item.hold - _item_serializable.item_resource.max_hold
			_new_item.hold = _item_serializable.item_resource.max_hold
			_new_item.stored += _extra
			_inventory_serializable.consumable_item_array.append(_new_item)
			return _new_item
		#-------------------------------------------------------------------------------
		else:
			_inventory_serializable.consumable_item_array.append(_new_item)
			return _new_item
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		_new_item.stored = _hold
		_inventory_serializable.consumable_item_array.append(_new_item)
		return _new_item
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Add_EquipItem_to_Inventory(_equip_serializable: Equip_Serializable, _hold:int) -> Equip_Serializable:
	return Add_Equip_Serializable_to_Array(inventory_serializable.equip_item_array, _equip_serializable.equip_resource, _hold)
#-------------------------------------------------------------------------------
func Add_Equip_Serializable_to_Array(_equip_array:Array[Equip_Serializable], _equip_resource:Equip_Resource, _hold: int) -> Equip_Serializable:
	#-------------------------------------------------------------------------------
	for _i in _equip_array.size():
		#-------------------------------------------------------------------------------
		if(_equip_array[_i].equip_resource == _equip_resource):
			_equip_array[_i].stored += _hold
			return _equip_array[_i]
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
	_equip_serializable.equip_resource = _equip_resource
	_equip_serializable.stored = _hold
	_equip_array.append(_equip_serializable)
	return _equip_serializable
#-------------------------------------------------------------------------------
func Add_KeyItem_to_Inventory(_keyitem_serializable: Key_Item_Serializable, _hold:int) -> Key_Item_Serializable:
	var _inventory_serializable: Inventory_Serializable = inventory_serializable
	#-------------------------------------------------------------------------------
	if(_keyitem_serializable.key_item_resource == _inventory_serializable.money_serializable.key_item_resource):
		_inventory_serializable.money_serializable.stored += _hold
		return _inventory_serializable.money_serializable
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		for _i in _inventory_serializable.key_item_array.size():
			#-------------------------------------------------------------------------------
			if(_inventory_serializable.key_item_array[_i].key_item_resource == _keyitem_serializable.key_item_resource):
				_inventory_serializable.key_item_array[_i].stored += _hold
				return _inventory_serializable.key_item_array[_i]
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		var _new_keyitem: Key_Item_Serializable = _keyitem_serializable.Constructor()
		_new_keyitem.key_item_resource = _keyitem_serializable.key_item_resource
		_new_keyitem.stored = _hold
		_inventory_serializable.key_item_array.append(_new_keyitem)
		return _new_keyitem
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CONFIRM BUY MENU
#-------------------------------------------------------------------------------
func Confirm_Buy_Menu_Submit(_submit:Callable, _button:Button, _up:Callable, _down:Callable, _left:Callable, _right:Callable):
	confirm_buy_menu.show()
	_button.disabled = true
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		confirm_buy_menu.hide()
		_button.disabled = false
		singleton.Move_to_Button(_button)
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_Up_Down_Left_Right(confirm_buy_menu_button, func():pass, _submit, _cancel, _up, _down, _left, _right)
	singleton.Move_to_Button(confirm_buy_menu_button)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Print_How_Many_Do_You_Buy(_price:int, _has_limited_stored:bool, _stored:int):
	#-------------------------------------------------------------------------------
	if(_has_limited_stored):
		confirm_buy_menu_button.text = "  ["+str(how_many_would_you_buy)+"/"+str(_stored)+"]  "
	#-------------------------------------------------------------------------------
	else:
		confirm_buy_menu_button.text = "  ["+str(how_many_would_you_buy)+"]  "
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_price.text = Get_Money_Label(_price * how_many_would_you_buy)+"  "
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region DIALOGUE MENU
#-------------------------------------------------------------------------------
func Dialogue_Open():
	is_in_dialogue = true
	#-------------------------------------------------------------------------------
	for _i in friend_party.size():
		Animation_StateMachine(friend_party[_i].animation_tree, "", "Idle")
		friend_party[_i].is_Moving = false
	#-------------------------------------------------------------------------------
	Set_DialogueMenu_NextButton()
	singleton.Move_to_Button(dialogue_menu_button_next)
#-------------------------------------------------------------------------------
func Dialogue(_dialogue:String):
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	Set_DialogueMenu_NextButton()
	dialogue_menu_button_next.show()
	dialogue_menu_button_next.disabled = false
	#-------------------------------------------------------------------------------
	dialogue_menu_speaker1.hide()
	dialogue_menu_speaker1_name.hide()
	#-------------------------------------------------------------------------------
	dialogue_menu_speaking_label.text = tr(_dialogue)
	dialogue_menu_speaking_label.get_v_scroll_bar().value = 0
	await dialogue_signal
#-------------------------------------------------------------------------------
func Dialogue_with_Speaker(_texture:Texture2D, _nombre:String, _dialogue:String):
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	Set_DialogueMenu_NextButton()
	dialogue_menu_button_next.show()
	dialogue_menu_button_next.disabled = false
	#-------------------------------------------------------------------------------
	dialogue_menu_speaker1.show()
	dialogue_menu_speaker1_image.texture = _texture
	#-------------------------------------------------------------------------------
	dialogue_menu_speaker1_name.text = "[color=" +hex_color_yellow+"]"+"[lb]"+tr(_nombre)+"[rb]"+"[/color]"
	dialogue_menu_speaker1_name.show()
	#-------------------------------------------------------------------------------
	dialogue_menu_speaking_label.text = tr(_dialogue)
	dialogue_menu_speaking_label.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
	await dialogue_signal
#-------------------------------------------------------------------------------
func Dialogue_Close():
	is_in_dialogue = false
	dialogue_menu.hide()
	dialogue_menu_button_next.release_focus()
#-------------------------------------------------------------------------------
func Set_DialogueMenu_NextButton():
	#-------------------------------------------------------------------------------
	var _selected: Callable = func(): singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	var _submit: Callable = func():
		dialogue_signal.emit()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _up: Callable = func():
		singleton.Scroll_Richtext_Up(dialogue_menu_speaking_label)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		singleton.Scroll_Richtext_Down(dialogue_menu_speaking_label)
	#-------------------------------------------------------------------------------
	var _left: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _right: Callable = func(): pass
	#-------------------------------------------------------------------------------
	singleton.Set_Button_Up_Down_Left_Right(dialogue_menu_button_next, _selected, _submit, _cancel, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func Wait_for_Player():
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE == BATTLE_STATE.STILL_FIGHTING):
		await dialogue_signal
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MISCELANIOUS
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
#endregion
#-------------------------------------------------------------------------------
#region FUNCTIONS THAT SIMULATE TAB MENUES
#-------------------------------------------------------------------------------
func Item_Menu_Show_and_Enable_All_Button():
	item_menu_all_button.show()
	item_menu_consumable_button.show()
	item_menu_equip_button.show()
	item_menu_key_button.show()
	#-------------------------------------------------------------------------------
	item_menu_all_button.disabled = false
	item_menu_consumable_button.disabled = false
	item_menu_equip_button.disabled = false
	item_menu_key_button.disabled = false
#-------------------------------------------------------------------------------
func Item_Menu_Hide_All_ScrollContainer():
	item_menu_all_scrollContainer.hide()
	item_menu_consumable_scrollContainer.hide()
	item_menu_equip_scrollContainer.hide()
	item_menu_key_scrollContainer.hide()
#-------------------------------------------------------------------------------
func Item_Menu_Hide_All_Buttons():
	item_menu_all_button.hide()
	item_menu_consumable_button.hide()
	item_menu_equip_button.hide()
	item_menu_key_button.hide()
#-------------------------------------------------------------------------------
func User_Menu_Hide_All_Button():
	user_menu_info_button.hide()
	user_menu_stats_button.hide()
	user_menu_statuseffect_button.hide()
	user_menu_equip_button.hide()
	user_menu_skill_button.hide()
#-------------------------------------------------------------------------------
func User_Menu_Hide_All_ScrollContainer():
	user_menu_info_container.hide()
	user_menu_stats_scrollContainer.hide()
	user_menu_statuseffect_scrollContainer.hide()
	user_menu_equip_scrollContainer.hide()
	user_menu_skill_scrollContainer.hide()
#-------------------------------------------------------------------------------
func User_Menu_Show_and_Enable_All_Button():
	user_menu_info_button.show()
	user_menu_stats_button.show()
	user_menu_statuseffect_button.show()
	user_menu_equip_button.show()
	user_menu_skill_button.show()
	#-------------------------------------------------------------------------------
	user_menu_info_button.disabled = false
	user_menu_stats_button.disabled = false
	user_menu_statuseffect_button.disabled = false
	user_menu_equip_button.disabled = false
	user_menu_skill_button.disabled = false
#-------------------------------------------------------------------------------
func Hide_Control_and_Enable_Button(_control:Control, _button:Button):
	_control.hide()
	_button.disabled = false
#-------------------------------------------------------------------------------
func Enable_Menu_And_Move_to_Button(_scrollContainer:ScrollContainer, _button_array:Array[Button], _button:Button):
	_scrollContainer.show()
	_button.show()
	#-------------------------------------------------------------------------------
	if(_button_array.size() > 0):
		_button.disabled = true
		singleton.Move_to_Button(_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		_button.disabled = false
		singleton.Move_to_Button(_button)
	#-------------------------------------------------------------------------------
	_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func Enable_Menu_And_Move_to_Button_0(_container:Control, _button:Button):
	_container.show()
	_button.disabled = false
	_button.show()
	singleton.Move_to_Button(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PARTY FUNCTIONS
#-------------------------------------------------------------------------------
func Get_Alive_Party_Array(_party_array:Array[Party_Member_Node]) -> Array[Party_Member_Node]:
	var _alive_party_array: Array[Party_Member_Node]
	#-------------------------------------------------------------------------------
	for _i in _party_array.size():
		#-------------------------------------------------------------------------------
		if(_party_array[_i].party_member_serializable.hp > 0):
			_alive_party_array.append(_party_array[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _alive_party_array
#-------------------------------------------------------------------------------
func Get_Dead_Party_Array(_party_array:Array[Party_Member_Node]) -> Array[Party_Member_Node]:
	var _dead_party_array: Array[Party_Member_Node]
	#-------------------------------------------------------------------------------
	for _i in _party_array.size():
		#-------------------------------------------------------------------------------
		if(_party_array[_i].party_member_serializable.hp <= 0):
			_dead_party_array.append(_party_array[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _dead_party_array
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func Has_Status_Effect_Guard(_user:Party_Member_Node) -> bool:
	return Has_Status_Effect(_user, "status_heal_0")
#-------------------------------------------------------------------------------
func Has_Status_Effect(_user:Party_Member_Node, _status_effect_name:StringName) -> bool:
	var _status_effect_serializable_array: Array[StatusEffect_Serializable] = _user.party_member_serializable_in_battle.status_effect_serializable_array
	#-------------------------------------------------------------------------------
	for _i in _status_effect_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(get_resource_filename(_status_effect_serializable_array[_i].statuseffect_resource) == _status_effect_name):
			return true
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return false
#-------------------------------------------------------------------------------
func Set_Status_Effect_Label(_user:Party_Member_Node):
	var _int: int = _user.party_member_serializable_in_battle.status_effect_serializable_array.size()
	#-------------------------------------------------------------------------------
	if(_user.party_member_serializable.hp <= 0):
		_int += 1
	#-------------------------------------------------------------------------------
	_user.party_member_ui.label_status_effect.text = tr("user_menu_status_effect_label")+": "+str(_int)
#-------------------------------------------------------------------------------
var popip_time_alived: float = 1.18		#NOTA: es lo que duran los "Flying_PopUp_Actions"(1.18s)
#var popip_time_alived: float = 0.68	#NOTA: es lo que duran los "Flying_PopUp_Actions"(1.18s) - lo que dura el "Move_to_Position"(0.5s).
#-------------------------------------------------------------------------------
func Status_Effect_Action_When_Turn_Start():
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
	#-------------------------------------------------------------------------------
	if(_friend_party_alive.size() <= 0 or _enemy_party_alive.size() <= 0):
		return
	#-------------------------------------------------------------------------------
	var _does_anyone_has_this_status_effect: bool = false
	#-------------------------------------------------------------------------------
	for _i in _friend_party_alive.size():
		var _status_effect_serializable_array: Array[StatusEffect_Serializable] = _friend_party_alive[_i].party_member_serializable_in_battle.status_effect_serializable_array
		#-------------------------------------------------------------------------------
		for _j in _status_effect_serializable_array.size():
			#-------------------------------------------------------------------------------
			if(get_resource_filename(_status_effect_serializable_array[_j].statuseffect_resource) == "status_damage_1"):
				var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(_friend_party_alive[_i].party_member_serializable, "max_hp")
				var _damage = int(float(_max_hp)*0.1)
				HP_Damage(_friend_party_alive[_i], _damage)
				Play_AttackAnimation(_friend_party_alive[_i], "anim_poison")
				_does_anyone_has_this_status_effect = true
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _enemy_party_alive.size():
		var _status_effect_serializable_array: Array[StatusEffect_Serializable] = _enemy_party_alive[_i].party_member_serializable_in_battle.status_effect_serializable_array
		#-------------------------------------------------------------------------------
		for _j in _status_effect_serializable_array.size():
			#-------------------------------------------------------------------------------
			if(get_resource_filename(_status_effect_serializable_array[_j].statuseffect_resource) == "status_damage_1"):
				var _max_hp: int = Get_Party_Member_Calculated_Base_Stat(_enemy_party_alive[_i].party_member_serializable, "max_hp")
				var _damage = int(float(_max_hp)*0.1)
				HP_Damage(_enemy_party_alive[_i], _damage)
				Play_AttackAnimation(_enemy_party_alive[_i], "anim_poison")
				_does_anyone_has_this_status_effect = true
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(_does_anyone_has_this_status_effect):
		await Seconds(popip_time_alived)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Status_Effect_Action_When_Turn_Start_and_Status_Effect_is_Removed():
	var _was_status_effect_removed_this_turn: bool = false
	#-------------------------------------------------------------------------------
	var _friend_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(friend_party)
	var _enemy_party_alive: Array[Party_Member_Node] = Get_Alive_Party_Array(enemy_party)
	#-------------------------------------------------------------------------------
	if(_friend_party_alive.size() <= 0 or _enemy_party_alive.size() <= 0):
		return
	#-------------------------------------------------------------------------------
	for _i in _friend_party_alive.size():
		#-------------------------------------------------------------------------------
		var _skill_serializable_array: Array[Item_Serializable] = _friend_party_alive[_i].party_member_serializable_in_battle.skill_serializable_array
		#-------------------------------------------------------------------------------
		for _j in _skill_serializable_array.size():
			#-------------------------------------------------------------------------------
			if(_skill_serializable_array[_j].hold < 0):
				_skill_serializable_array[_j].hold = 0
			#-------------------------------------------------------------------------------
			_skill_serializable_array[_j].cooldown -= 1
			#-------------------------------------------------------------------------------
			if(_skill_serializable_array[_j].cooldown < 0):
				_skill_serializable_array[_j].cooldown = 0
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		var _statuseffect_serializable_array: Array[StatusEffect_Serializable] = _friend_party_alive[_i].party_member_serializable_in_battle.status_effect_serializable_array
		#-------------------------------------------------------------------------------
		for _j in range(_statuseffect_serializable_array.size()-1, -1, -1):
			#-------------------------------------------------------------------------------
			if(!_statuseffect_serializable_array[_j].statuseffect_resource.is_infinite):
				_statuseffect_serializable_array[_j].stored -= 1
				#-------------------------------------------------------------------------------
				if(_statuseffect_serializable_array[_j].stored <= 0):
					Flying_PopUp(_friend_party_alive[_i], "-"+tr("name_"+get_resource_filename(_statuseffect_serializable_array[_j].statuseffect_resource)))
					_statuseffect_serializable_array.remove_at(_j)
					_was_status_effect_removed_this_turn = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------		
		#-------------------------------------------------------------------------------
		Set_Status_Effect_Label(_friend_party_alive[_i])
		#-------------------------------------------------------------------------------
		Animation_StateMachine(_friend_party_alive[_i].animation_tree, "", "Idle")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _enemy_party_alive.size():
		#-------------------------------------------------------------------------------
		var _statuseffect_serializable_array: Array[StatusEffect_Serializable] = _enemy_party_alive[_i].party_member_serializable_in_battle.status_effect_serializable_array
		#-------------------------------------------------------------------------------
		for _j in range(_statuseffect_serializable_array.size()-1, -1, -1):
			#-------------------------------------------------------------------------------
			if(!_statuseffect_serializable_array[_j].statuseffect_resource.is_infinite):
				_statuseffect_serializable_array[_j].stored -= 1
				#-------------------------------------------------------------------------------
				if(_statuseffect_serializable_array[_j].stored <= 0):
					Flying_PopUp(_enemy_party_alive[_i], "-"+tr("name_"+get_resource_filename(_statuseffect_serializable_array[_j].statuseffect_resource)))
					_statuseffect_serializable_array.remove_at(_j)
					_was_status_effect_removed_this_turn = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Set_Status_Effect_Label(_enemy_party_alive[_i])
		#-------------------------------------------------------------------------------
		Animation_StateMachine(_enemy_party_alive[_i].animation_tree, "Base_StateMachine/", "Idle")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	Set_TP_Label(tp)
	#-------------------------------------------------------------------------------
	if(_was_status_effect_removed_this_turn):
		await Seconds(popip_time_alived)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Key_Item_Serializable_Array(_inventory_serializable:Inventory_Serializable) -> Array[Key_Item_Serializable]:
	var _new_key_item_array: Array[Key_Item_Serializable]
	#-------------------------------------------------------------------------------
	if(_inventory_serializable.money_serializable.stored > 0):
		_new_key_item_array.append(_inventory_serializable.money_serializable)
	#-------------------------------------------------------------------------------
	_new_key_item_array.append_array(_inventory_serializable.key_item_array)
	return _new_key_item_array
#-------------------------------------------------------------------------------
func Get_Status_Effect_Serializable_Array(_user:Party_Member_Node) -> Array[StatusEffect_Serializable]:
	var _new_status_effect_serializable_array: Array[StatusEffect_Serializable]
	#-------------------------------------------------------------------------------
	if(_user.party_member_serializable.hp <= 0):
		var _down_statuseffect_serializable: StatusEffect_Serializable = StatusEffect_Serializable.new()
		_down_statuseffect_serializable.statuseffect_resource = down_statuseffect_resource
		_new_status_effect_serializable_array.append(_down_statuseffect_serializable)
	#-------------------------------------------------------------------------------
	var _status_effect_serializable_array: Array[StatusEffect_Serializable] = _user.party_member_serializable_in_battle.status_effect_serializable_array
	_new_status_effect_serializable_array.append_array(_status_effect_serializable_array)
	#-------------------------------------------------------------------------------
	return _new_status_effect_serializable_array
