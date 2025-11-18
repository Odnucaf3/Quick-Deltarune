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
@export var dialogue_menu: Control
@export var dialogue_menu_label: Label
#-------------------------------------------------------------------------------
@export var ally_ui_prefab: PackedScene
@export var enemy_ui_prefab: PackedScene
#-------------------------------------------------------------------------------
@export var player: Array[Party_Member]
var player_alive: Array[Party_Member]
var player_death: Array[Party_Member]
#-------------------------------------------------------------------------------
@export var enemy: Array[Party_Member]
var enemy_alive: Array[Party_Member]
var enemy_death: Array[Party_Member]
#-------------------------------------------------------------------------------
@export var item_menu: Control
@export var item_menu_scrollContainer: ScrollContainer
@export var item_menu_content: VBoxContainer
@export var item_menu_title: Label
@export var item_menu_description: Label
@export var item_menu_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export var item_array: Array[Item_Resource]
var item_array_in_battle: Array[Item_Resource]
@export var iten_resource_attack: Item_Resource
@export var iten_resource_defense: Item_Resource
#-------------------------------------------------------------------------------
var camera_offset_y: float = 125
var current_player_turn: int = 0
@export var black_panel: Panel
@export var battle_black_panel: Panel
@export var pauseLabel: Label
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
@export var battle_menu_rect: TextureRect
@export var battle_box: Control
#-------------------------------------------------------------------------------
@export var timer_label: Label
var timer_tween: Tween
var timer: int
var main_tween_Array: Array[Tween]
#-------------------------------------------------------------------------------
var myGAME_STATE: GAME_STATE = GAME_STATE.IN_WORLD
var is_Moving: bool = false
var is_Facing_Left: bool = false
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
var grazeBox_radius: float = 41.0
var hitBox_radius: float = 8.0
var canBeHit: bool = true
var viewport_size: Vector2
var viewport_center: Vector2
#-------------------------------------------------------------------------------
var deltaTimeScale: float = 1.0
#endregion
#-------------------------------------------------------------------------------
#region MONOBEHAVIOUR
func _ready() -> void:
	#-------------------------------------------------------------------------------
	for _i in player.size():
		player[_i].playback = player[_i].animation_tree.get("parameters/playback")
		PlayAnimation(player[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		var _party_member_ui: Party_Member_UI = ally_ui_prefab.instantiate() as Party_Member_UI
		player[_i].party_member_ui = _party_member_ui
		player[_i].party_member_ui.hide()
		player[_i].party_member_ui.button_pivot.hide()
		#player[_i].party_member_ui.label_sp.hide()
		#player[_i].party_member_ui.bar_sp.hide()
		battle_control.add_child(_party_member_ui)
	#-------------------------------------------------------------------------------
	for _i in range(1, player.size()):
		player[_i].collider.disabled = true
	#-------------------------------------------------------------------------------
	win_label.hide()
	retry_menu.hide()
	battle_menu.hide()
	item_menu.hide()
	battle_box.hide()
	battle_menu_rect.hide()
	timer_label.hide()
	battle_black_panel.hide()
	dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	var _width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var _height: float = ProjectSettings.get_setting("display/window/size/viewport_height")
	viewport_size = Vector2(_width, _height)
	viewport_center = viewport_size/2.0
	#-------------------------------------------------------------------------------
	room_test.game_scene = self
	room_test.Set_Room()
	camera.position = Camera_Set_Target_Position()
	#-------------------------------------------------------------------------------
	hitbox.global_scale = Get_CircleSprite_Scale(hitBox_radius) + Vector2(0.01, 0.01)
	grazebox.global_scale = Get_CircleSprite_Scale(grazeBox_radius) + Vector2(0.01, 0.01)
	#-------------------------------------------------------------------------------
	item_menu_button_array.clear()
	Destroy_Childrens(item_menu_content)
	#-------------------------------------------------------------------------------
	var _button_num: float = 4
	item_menu_scrollContainer.size.y = _button_num*42 + (_button_num-1) * 4
	#-------------------------------------------------------------------------------
	Create_EnemyBullets_Disabled(2000)
	PauseOff()
	NormalMotion()
	#-------------------------------------------------------------------------------
	SetParty_Skills()
	SetParty_Items()
#-------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	Debug_Information()
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
				room_test.Check_for_Enemy(self)
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
	Set_Skill(iten_resource_attack)
	Set_Skill(iten_resource_defense)
	#-------------------------------------------------------------------------------
	for _i in player.size():
		#-------------------------------------------------------------------------------
		for _j in player[_i].skill_array.size():
			Set_Skill(player[_i].skill_array[_j])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Skill(_item_resource:Item_Resource):
	_item_resource.id = get_resource_filename(_item_resource)
	_item_resource = _item_resource.Constructor()
	_item_resource.hold = _item_resource.max_hold
#-------------------------------------------------------------------------------
func SetParty_Items():
	#-------------------------------------------------------------------------------
	for _i in item_array.size():
		item_array[_i].id = get_resource_filename(item_array[_i])
		item_array[_i] = item_array[_i].Constructor()
		item_array[_i].hold = item_array[_i].max_hold
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region IN_WORLD FUNCTIONS
func Player_Movement():
	#-------------------------------------------------------------------------------
	var _input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	#-------------------------------------------------------------------------------
	if(is_Moving):
		_input_dir.normalized()
		#-------------------------------------------------------------------------------
		if(is_Running):
			var _new_velocity: Vector2 = _input_dir * 600.0 * deltaTimeScale
			player[0].velocity = _new_velocity
			#-------------------------------------------------------------------------------
			if(!_run_flag):
				PlayAnimation(player[0].playback, "Walk")
				is_Running = false
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			var _new_velocity: Vector2 = _input_dir * 200.0 * deltaTimeScale
			player[0].velocity = _new_velocity
			#-------------------------------------------------------------------------------
			if(_run_flag):
				PlayAnimation(player[0].playback, "Run")
				is_Running = true
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(_input_dir == Vector2.ZERO):
			PlayAnimation(player[0].playback, "Idle")
			is_Moving = false
			return
		#-------------------------------------------------------------------------------
		if(is_Facing_Left):
			if(_input_dir.x > 0):
				Face_Left(false)
				return
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			if(_input_dir.x < 0):
				Face_Left(true)
				return
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _new_velocity: Vector2 = Vector2.ZERO
		player[0].velocity = _new_velocity
		#-------------------------------------------------------------------------------
		if(_input_dir != Vector2.ZERO):
			#-------------------------------------------------------------------------------
			if(_run_flag):
				PlayAnimation(player[0].playback, "Run")
				is_Running = true
			#-------------------------------------------------------------------------------
			else:
				PlayAnimation(player[0].playback, "Walk")
				is_Running = false
			#-------------------------------------------------------------------------------
			is_Moving = true
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	player[0].move_and_slide()
#-------------------------------------------------------------------------------
func Followers_Movement():
	#-------------------------------------------------------------------------------
	for _i in range(1, player.size()):
		var _distance: float = 150
		if(player[_i].global_position.distance_to(player[_i-1].global_position) > _distance):
			var _x: float = player[_i].global_position.x - player[_i-1].global_position.x
			var _y: float = player[_i].global_position.y - player[_i-1].global_position.y
			var _dir: float = atan2(_y, _x)
			var _x2: float = _distance * cos(_dir)
			var _y2: float = _distance * sin(_dir)
			player[_i].global_position = player[_i-1].global_position + Vector2(_x2, _y2)
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
			myPosition += _input_dir * 3.0 * deltaTimeScale * deltaTimeScale
		#-------------------------------------------------------------------------------
		else:
			myPosition += _input_dir * 8.0 * deltaTimeScale * deltaTimeScale
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
	var _new_position: Vector2 = player[0].position + Vector2(0, -camera_offset_y)
	#-------------------------------------------------------------------------------
	_new_position.x = clampf(_new_position.x, room_test.limit_left, room_test.limit_right)
	_new_position.y = clampf(_new_position.y, room_test.limit_top, room_test.limit_botton)
	#-------------------------------------------------------------------------------
	return _new_position
#-------------------------------------------------------------------------------
func Face_Left(_b:bool):
	player[0].sprite.flip_h = _b
	is_Facing_Left = _b
#endregion
#-------------------------------------------------------------------------------
#region SET BATTLEFIELD
#-------------------------------------------------------------------------------
func EnterBattle():
	myGAME_STATE = GAME_STATE.IN_MENU
	#-------------------------------------------------------------------------------
	player_last_position.clear()
	#-------------------------------------------------------------------------------
	for _i in player.size():
		player_last_position.append(player[_i].global_position)
		player[_i].collider.disabled = true
		PlayAnimation(player[_i].playback, "Idle")
		player[_i].z_index = 1
		#player[_i].global_position = player[0].global_position
		player[_i].party_member_ui.button.text = "  " + player[_i].id + "  "
	#-------------------------------------------------------------------------------
	enemy_last_position.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy_last_position.append(enemy[_i].global_position)
		enemy[_i].collider.disabled = true
		PlayAnimation(enemy[_i].playback, "Idle")
		enemy[_i].z_index = 1
		enemy[_i].sprite.flip_h = false
		enemy[_i].scale.x = -1.0
		#enemy[_i].global_position = enemy[0].global_position
		enemy[_i].party_member_ui.button.text = "  " + enemy[_i].id + "  "
	#-------------------------------------------------------------------------------
	Face_Left(false)
	current_player_turn = 0
	#-------------------------------------------------------------------------------
	var _center: Vector2 = camera.position
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
	var _top_limit: float = 0.45
	var _botton_limit: float = 1.15
	#-------------------------------------------------------------------------------
	for _i in player.size():
		var _y_pos: float = -viewport_size.y*_top_limit + viewport_size.y*_botton_limit* (float(_i+1)/(player.size()+1))
		var _x_pos: float = -375
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		player[_i].party_member_ui.global_position = viewport_center + Vector2(_x_pos, _y_pos)
		_tween.parallel().tween_property(player[_i], "position", _position, 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		var _y_pos: float = -viewport_size.y*_top_limit + viewport_size.y*_botton_limit* (float(_i+1)/(enemy.size()+1))
		var _x_pos: float = 375
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		enemy[_i].party_member_ui.global_position = viewport_center + Vector2(_x_pos, _y_pos)
		_tween.parallel().tween_property(enemy[_i], "position", _position, 0.5)
	#-------------------------------------------------------------------------------
	battle_menu.global_position = player[current_player_turn].party_member_ui.button_pivot.global_position
	_tween.tween_interval(0.5)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		battle_menu.show()
		Move_to_Button(battle_menu_button[0])
		#battle_box.show()
		battle_box.position = camera.position - battle_box.size/2.0
		#battle_menu_rect.show()
		SetButton(battle_menu_button[0],func():CommonSelected() , func():BattleMenu_AttackButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		SetButton(battle_menu_button[1],func():CommonSelected() , func():BattleMenu_DefenseButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		SetButton(battle_menu_button[2],func():CommonSelected() , func():BattleMenu_SkillButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		SetButton(battle_menu_button[3],func():CommonSelected() , func():BattleMenu_ItemButton_Submit(), func():BattleMenu_AnyButton_Cancel())
		#-------------------------------------------------------------------------------
		player_alive.clear()
		player_death.clear()
		#-------------------------------------------------------------------------------
		for _i in player.size():
			#-------------------------------------------------------------------------------
			player[_i].skill_array_in_battle.clear()
			for _j in player[_i].skill_array.size():
				player[_i].skill_array_in_battle.append(player[_i].skill_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			player[_i].hp = player[_i].max_hp
			Set_HP_Label(player[_i])
			player[_i].sp = 0
			Set_SP_Label(player[_i])
			player[_i].party_member_ui.show()
			player[_i].party_member_ui.button_pivot.hide()
			player_alive.append(player[_i])
		#-------------------------------------------------------------------------------
		enemy_alive.clear()
		enemy_death.clear()
		#-------------------------------------------------------------------------------
		for _i in enemy.size():
			enemy[_i].hp = enemy[_i].max_hp
			Set_HP_Label(enemy[_i])
			enemy[_i].sp = 0
			Set_SP_Label(enemy[_i])
			enemy[_i].party_member_ui.show()
			enemy[_i].party_member_ui.button_pivot.hide()
			enemy_alive.append(enemy[_i])
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region BATTLE_MENU FUNCTIONS
#-------------------------------------------------------------------------------
func BattleMenu_AttackButton_Submit():
	battle_menu.hide()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		TargetMenu_TargetButton_Cancel()
		battle_menu.show()
		Move_to_Button(battle_menu_button[0])
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(iten_resource_attack, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_DefenseButton_Submit():
	battle_menu.hide()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		TargetMenu_TargetButton_Cancel()
		battle_menu.show()
		Move_to_Button(battle_menu_button[1])
	#-------------------------------------------------------------------------------
	TargetMenu_Enter(iten_resource_defense, _cancel)
#-------------------------------------------------------------------------------
func BattleMenu_SkillButton_Submit():
	battle_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	item_menu_title.text = "Skills"
	#-------------------------------------------------------------------------------
	for _i in player_alive[current_player_turn].skill_array_in_battle.size():
		#-------------------------------------------------------------------------------
		var _item_resource: Item_Resource = player_alive[current_player_turn].skill_array_in_battle[_i]
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		_button.theme = ui_theme
		_button.text = "  "+_item_resource.id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_content.add_child(_button)
		item_menu_button_array.append(_button)
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
			item_menu.show()
			Move_to_Button(item_menu_button_array[_i])
		#-------------------------------------------------------------------------------
		SetButton(_button, func():CommonSelected(), func(): ItemMenu_SkillButton_Submit(_item_resource, _cancel), func():ItemMenu_SkillButton_Cancel())
	#-------------------------------------------------------------------------------
	if(item_menu_button_array.size() > 0):
		Move_to_Button(item_menu_button_array[0])
	#-------------------------------------------------------------------------------
	item_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func BattleMenu_ItemButton_Submit():
	battle_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	item_menu_title.text = "Items"
	#-------------------------------------------------------------------------------
	for _i in item_array_in_battle.size():
		#-------------------------------------------------------------------------------
		var _button: Button = Button.new()
		var _hold: int = item_array_in_battle[_i].hold
		#-------------------------------------------------------------------------------
		for _j in current_player_turn:
			#-------------------------------------------------------------------------------
			if(item_array_in_battle[_i] == (player[_j].item_resource)):
				_hold -= 1
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		_button.theme = ui_theme
		_button.text = "  "+item_array_in_battle[_i].id+"  "
		_button.add_theme_font_size_override("font_size", 24)
		_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_menu_content.add_child(_button)
		item_menu_button_array.append(_button)
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
			Move_to_Button(item_menu_button_array[_i])
		#-------------------------------------------------------------------------------
		if(_hold > 0):
			SetButton(_button, func():CommonSelected(), func():ItemMenu_ItemButton_Submit(item_array_in_battle[_i], _cancel), func():ItemMenu_ItemButton_Cancel())
		#-------------------------------------------------------------------------------
		else:
			SetButton(_button, func():CommonSelected(), func():pass, func():ItemMenu_ItemButton_Cancel())
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(item_menu_button_array.size() > 0):
		Move_to_Button(item_menu_button_array[0])
	#-------------------------------------------------------------------------------
	item_menu_scrollContainer.scroll_vertical = 0
#-------------------------------------------------------------------------------
func BattleMenu_AnyButton_Cancel():
	current_player_turn -= 1
	#-------------------------------------------------------------------------------
	if(current_player_turn < 0):
		current_player_turn = 0
		battle_menu.hide()
		win_label.text = "Escape?"
		win_label.show()
		retry_menu.show()
		Move_to_Button(retry_menu_button[0])
		SetButton(retry_menu_button[0], func():CommonSelected(), func():RetryMenu_RetryButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		SetButton(retry_menu_button[1], func():CommonSelected(), func():RetryMenu_EscapeButton_Submit(), func():RetryMenu_AnyButton_Cancel())
		SetButton(retry_menu_button[2], func():CommonSelected(), func():RetryMenu_ReturnToSavePointButton_Submit(), func():RetryMenu_AnyButton_Cancel())
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		for _i in range(current_player_turn, player_alive.size()):
			PlayAnimation(player_alive[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		for _i in enemy_alive.size():
			PlayAnimation(enemy_alive[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		battle_menu.global_position = player_alive[current_player_turn].party_member_ui.button_pivot.global_position
		Move_to_Button(battle_menu_button[0])
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ITEM/SKILL MENU FUNCTIONS
#-------------------------------------------------------------------------------
func ItemMenu_SkillButton_Submit(_item_resource:Item_Resource, _cancel:Callable):
	if(player[current_player_turn].sp >= _item_resource.sp_cost):
		TargetMenu_Enter(_item_resource, _cancel)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func ItemMenu_SkillButton_Cancel():
	item_menu.hide()
	battle_menu.show()
	Move_to_Button(battle_menu_button[2])
	Destroy_All_Items()
#-------------------------------------------------------------------------------
func ItemMenu_ItemButton_Submit(_item_resource:Item_Resource, _cancel:Callable):
	TargetMenu_Enter(_item_resource, _cancel)
#-------------------------------------------------------------------------------
func ItemMenu_ItemButton_Cancel():
	item_menu.hide()
	battle_menu.show()
	Move_to_Button(battle_menu_button[3])
	#-------------------------------------------------------------------------------
	for _i in item_menu_button_array.size():
		item_menu_button_array[_i].queue_free()
	#-------------------------------------------------------------------------------
	item_menu_button_array.clear()
#-------------------------------------------------------------------------------
func Destroy_All_Items():
	for _i in item_menu_button_array.size():
		item_menu_button_array[_i].queue_free()
	#-------------------------------------------------------------------------------
	item_menu_button_array.clear()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TARGET MENU FUNCTIONS
#-------------------------------------------------------------------------------
func TargetMenu_Enter(_item_resource:Item_Resource, _cancel:Callable):	
	#-------------------------------------------------------------------------------
	match(_item_resource.myTARGET_TYPE):
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ENEMY_1:
			#-------------------------------------------------------------------------------
			if(enemy_alive.size() > 0):
				item_menu.hide()
				#-------------------------------------------------------------------------------
				for _i in enemy_alive.size():
					enemy_alive[_i].party_member_ui.button_pivot.show()
					SetButton(enemy_alive[_i].party_member_ui.button, func():CommonSelected(), func():TargetMenu_TargetButton_Submit(player_alive, enemy_alive[_i], enemy_alive, _item_resource), _cancel)
				#-------------------------------------------------------------------------------
				Move_to_Button(enemy_alive[0].party_member_ui.button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ALLY_1:
			#-------------------------------------------------------------------------------
			if(player_alive.size() > 0):
				item_menu.hide()
				#-------------------------------------------------------------------------------
				for _i in player_alive.size():
					player_alive[_i].party_member_ui.button_pivot.show()
					SetButton(player_alive[_i].party_member_ui.button, func():CommonSelected(), func():TargetMenu_TargetButton_Submit(player_alive, player_alive[_i], player_alive, _item_resource), _cancel)
				#-------------------------------------------------------------------------------
				Move_to_Button(player_alive[0].party_member_ui.button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.ALLY_DEATH:
			#-------------------------------------------------------------------------------
			if(player_death.size() > 0):
				item_menu.hide()
				#-------------------------------------------------------------------------------
				for _i in player_death.size():
					player_death[_i].party_member_ui.button_pivot.show()
					SetButton(player_death[_i].party_member_ui.button, func():CommonSelected(), func():TargetMenu_TargetButton_Submit(player_death, player_death[_i], player_death, _item_resource), _cancel)
				#-------------------------------------------------------------------------------
				Move_to_Button(player_death[0].party_member_ui.button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Item_Resource.TARGET_TYPE.USER:
			item_menu.hide()
			#-------------------------------------------------------------------------------
			player_alive[current_player_turn].party_member_ui.button_pivot.show()
			SetButton(player_alive[current_player_turn].party_member_ui.button, func():CommonSelected(), func():TargetMenu_TargetButton_Submit(player_alive, player_alive[current_player_turn], player_alive, _item_resource), _cancel)
			#-------------------------------------------------------------------------------
			Move_to_Button(player_alive[current_player_turn].party_member_ui.button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Submit(_user_party:Array[Party_Member], _target:Party_Member, _target_party:Array[Party_Member], _item_resource:Item_Resource):
	player_alive[current_player_turn].user_party = _user_party
	player_alive[current_player_turn].target = _target
	player_alive[current_player_turn].target_party = _target_party
	player_alive[current_player_turn].item_resource = _item_resource
	#-------------------------------------------------------------------------------
	PlayAnimation(player_alive[current_player_turn].playback, _item_resource.anim)
	Destroy_All_Items()
	After_Choose_Target_Logic()
#-------------------------------------------------------------------------------
func TargetMenu_TargetButton_Cancel():
	player_alive[current_player_turn].user_party = []
	player_alive[current_player_turn].target = null
	player_alive[current_player_turn].target_party = []
	player_alive[current_player_turn].item_resource = null
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
	if(current_player_turn < player_alive.size()):
		#-------------------------------------------------------------------------------
		battle_menu.global_position = player_alive[current_player_turn].party_member_ui.button_pivot.global_position
		battle_menu.show()
		Move_to_Button(battle_menu_button[0])
	#-------------------------------------------------------------------------------
	else:
		await Party_Actions()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Hide_AllTarget():
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in player.size():
		player[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Seconds(_timer:float):
	await get_tree().create_timer(_timer, true, true).timeout
#-------------------------------------------------------------------------------
func Party_Actions():
	current_player_turn = player_alive.size()
	await Seconds(0.3)
	#-------------------------------------------------------------------------------
	var _player_alive_attacking: Array[Party_Member] = []
	var _player_alive_defending: Array[Party_Member] = []
	var _player_alive_using_skill_or_item: Array[Party_Member] = []
	#-------------------------------------------------------------------------------
	for _i in player_alive.size():
		match(player_alive[_i].item_resource):
			iten_resource_attack:
				_player_alive_attacking.append(player_alive[_i])
			iten_resource_defense:
				_player_alive_defending.append(player_alive[_i])
			_:
				_player_alive_using_skill_or_item.append(player_alive[_i])
		#if(player_alive[_i].item_resource == iten_resource_attack):
		#	_player_alive_attacking.append(player_alive[_i])
		#-------------------------------------------------------------------------------
		#else:
		#	_player_alive_using_skill_or_item.append(player_alive[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await Do_Defence_Minigame(_player_alive_defending)
	#-------------------------------------------------------------------------------
	for _i in _player_alive_using_skill_or_item.size():
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
	player_alive.clear()
	player_death.clear()
	#-------------------------------------------------------------------------------
	for _i in player.size():
		if(player[_i].hp > 0):
			player_alive.append(player[_i])
			if(player[_i].is_in_guard):
				PlayAnimation(player[_i].playback, "Crouch")
			#-------------------------------------------------------------------------------
			else:
				PlayAnimation(player[_i].playback, "Idle")
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			player_death.append(player[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	enemy_alive.clear()
	enemy_death.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		if(enemy[_i].hp > 0):
			enemy_alive.append(enemy[_i])
			PlayAnimation(enemy[_i].playback, "Idle")
		else:
			enemy_death.append(enemy[_i])
	#-------------------------------------------------------------------------------
	if(enemy_alive.size() > 0):
		if(player_alive.size() > 0):
			await Start_BulletHell()
		else:
			You_Lose()
	#-------------------------------------------------------------------------------
	else:
		You_Win()
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
		#-------------------------------------------------------------------------------
		enemy_alive.clear()
		enemy_death.clear()
		#-------------------------------------------------------------------------------
		for _i in enemy.size():
			#-------------------------------------------------------------------------------
			if(enemy[_i].hp > 0):
				enemy_alive.append(enemy[_i])
			#-------------------------------------------------------------------------------
			else:
				enemy_death.append(enemy[_i])
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(enemy_alive.size() > 0):
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
	var _offset: float = 10
	box_limit_up = _offset
	box_limit_down = battle_box.size.y - _offset
	box_limit_left = _offset
	box_limit_right = battle_box.size.x - _offset
	#-------------------------------------------------------------------------------
	screen_limit_up = camera.global_position.y-viewport_center.y
	screen_limit_down = camera.global_position.y+viewport_center.y
	screen_limit_left = camera.global_position.x-viewport_center.x
	screen_limit_right = camera.global_position.x+viewport_center.x
	#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in enemy_alive.size():
		PlayAnimation(enemy_alive[_i].playback, "Aim")
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
	player_alive.clear()
	player_death.clear()
	#-------------------------------------------------------------------------------
	for _i in player.size():
		player[_i].is_in_guard = false
		#-------------------------------------------------------------------------------
		if(player[_i].hp > 0):
			player_alive.append(player[_i])
			PlayAnimation(player[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		else:
			player_death.append(player[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	enemy_alive.clear()
	enemy_death.clear()
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].is_in_guard = false
		#-------------------------------------------------------------------------------
		if(enemy[_i].hp > 0):
			enemy_alive.append(enemy[_i])
			PlayAnimation(enemy[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		else:
			enemy_death.append(enemy[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(enemy_alive.size() > 0):
		if(player_alive.size() > 0):
			battle_menu.show()
			battle_box.hide()
			myGAME_STATE = GAME_STATE.IN_MENU
			Move_to_Button(battle_menu_button[current_player_turn])
			battle_menu.global_position = player_alive[current_player_turn].party_member_ui.button_pivot.global_position
		else:
			You_Lose()
	#-------------------------------------------------------------------------------
	else:
		You_Win()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func You_Win():
	#-------------------------------------------------------------------------------
	for _i in player.size():
		player[_i].party_member_ui.hide()
		player[_i].party_member_ui.button_pivot.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].party_member_ui.hide()
		enemy[_i].party_member_ui.button_pivot.hide()
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
	for _i in player.size():
		_tween3.parallel().tween_property(player[_i], "global_position", player_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		_tween3.parallel().tween_property(enemy[_i], "global_position", enemy_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	_tween3.tween_callback(func():
		win_label.hide()
		myGAME_STATE = GAME_STATE.IN_WORLD
		#-------------------------------------------------------------------------------
		for _i in player.size():
			player[_i].collider.disabled = false
			player[_i].z_index = 0
		#-------------------------------------------------------------------------------
		for _i in enemy.size():
			enemy[_i].collider.disabled = false
			enemy[_i].z_index = 0
		#-------------------------------------------------------------------------------
		battle_black_panel.hide()
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region RETRY MENU FUNCTIONS
#-------------------------------------------------------------------------------
func RetryMenu_RetryButton_Submit():
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
		battle_menu.global_position = player[0].party_member_ui.button_pivot.global_position
		#-------------------------------------------------------------------------------
		item_array_in_battle.clear()
		for _i in item_array.size():
			item_array_in_battle.append(item_array[_i].Constructor())
		#-------------------------------------------------------------------------------
		player_alive.clear()
		player_death.clear()
		#-------------------------------------------------------------------------------
		for _i in player.size():
			#-------------------------------------------------------------------------------
			player[_i].skill_array_in_battle.clear()
			for _j in player[_i].skill_array.size():
				player[_i].skill_array_in_battle.append(player[_i].skill_array[_j].Constructor())
			#-------------------------------------------------------------------------------
			PlayAnimation(player[_i].playback, "Idle")
			#-------------------------------------------------------------------------------
			player[_i].hp = player[_i].max_hp
			Set_HP_Label(player[_i])
			#-------------------------------------------------------------------------------
			player[_i].sp = 0
			Set_SP_Label(player[_i])
			#-------------------------------------------------------------------------------
			player[_i].item_resource = null
			#-------------------------------------------------------------------------------
			player[_i].party_member_ui.show()
			player_alive.append(player[_i])
		#-------------------------------------------------------------------------------
		enemy_alive.clear()
		enemy_death.clear()
		#-------------------------------------------------------------------------------
		for _i in enemy.size():
			PlayAnimation(enemy[_i].playback, "Idle")
			#-------------------------------------------------------------------------------
			enemy[_i].hp = enemy[_i].max_hp
			Set_HP_Label(enemy[_i])
			#-------------------------------------------------------------------------------
			enemy[_i].party_member_ui.show()
			enemy_alive.append(enemy[_i])
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
	You_Escape()
#-------------------------------------------------------------------------------
func RetryMenu_ReturnToSavePointButton_Submit():
	get_tree().reload_current_scene()
#-------------------------------------------------------------------------------
func RetryMenu_AnyButton_Cancel():
	battle_menu.show()
	win_label.hide()
	retry_menu.hide()
	Move_to_Button(battle_menu_button[0])
#-------------------------------------------------------------------------------
func You_Escape():
	#-------------------------------------------------------------------------------
	for _i in player.size():
		player[_i].party_member_ui.hide()
		PlayAnimation(player[_i].playback, "Idle")
		player[_i].z_index = 0
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].party_member_ui.hide()
		enemy[_i].z_index = 0
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
	for _i in player.size():
		_tween3.parallel().tween_property(player[_i], "global_position", player_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		_tween3.parallel().tween_property(enemy[_i], "global_position", enemy_last_position[_i], 0.5)
	#-------------------------------------------------------------------------------
	_tween3.tween_callback(func():
		myGAME_STATE = GAME_STATE.IN_WORLD
		player[0].collider.disabled = false
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
	_bullet.scale = Vector2(7, 7)
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
	#return enemy.size() - enemy_alive.size()
	return 3.0 - enemy_alive.size()
#-------------------------------------------------------------------------------
func Stage1_Fire2(_tween:Tween):
	var _difficulty: float = Set_Difficulty()
	var _mirror = 1
	#-------------------------------------------------------------------------------
	for _j in 2:
		#-------------------------------------------------------------------------------
		for _i in enemy_alive.size():
			_tween.tween_callback(func():
				PlayAnimation(enemy_alive[_i].playback, "Shot")
				Stage1_Fire2_Bullet1(enemy_alive[_i], _mirror)
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
	var _x: float = camera.position.x+viewport_center.x*0.5 * _mirror
	var _y: float = camera.position.y-viewport_center.y*0.5
	var _vel: float = 2
	var _dir: float = 90
	#-------------------------------------------------------------------------------
	var _vel2: float = 4
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
	if(player_alive.size() > 0):
		var _target: Party_Member = player_alive.pick_random()
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
		var _global_position: Vector2 = _target.global_position
		_global_position.y += randf_range(-75, 25)
		#-------------------------------------------------------------------------------
		if(_target.hp > 0):
			Flying_Label(_global_position, "-"+str(_int)+" HP")
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
			Flying_Label(_global_position, "Down")
			Set_HP_Label(_target)
			PlayAnimation(_target.playback, "Death")
			#-------------------------------------------------------------------------------
			player_alive.erase(_target)
			#-------------------------------------------------------------------------------
			if(player_alive.size() <= 0):
				StopEverithing_and_Timer()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	else:
		StopEverithing_and_Timer()
	#-------------------------------------------------------------------------------
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
		SetButton(retry_menu_button[0], func():CommonSelected(), func():RetryMenu_RetryButton_Submit(), func():pass)
		SetButton(retry_menu_button[1], func():CommonSelected(), func():RetryMenu_EscapeButton_Submit(), func():pass)
		SetButton(retry_menu_button[2], func():CommonSelected(), func():RetryMenu_ReturnToSavePointButton_Submit(), func():pass)
		Move_to_Button(retry_menu_button[0])
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Bullet_Grazed():
	var _target_party: Array[Party_Member] = []
	#-------------------------------------------------------------------------------
	for _i in player_alive.size():
		#-------------------------------------------------------------------------------
		if(player_alive[_i].sp < player_alive[_i].max_sp):
			_target_party.append(player_alive[_i])
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
	var _global_position: Vector2 = _user.target.global_position + Vector2(-75, -150)
	var _dir: float = Get_Dir_XY(Vector2(100,100))
	var _sprite2d: Bullet = Create_PlayerBullet(_global_position, _dir)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		PlayAnimation(_user.playback, "Shot")
		HP_Damage(_user.target, 5)
	)
	#-------------------------------------------------------------------------------
	_tween.tween_property(_sprite2d, "global_position", _global_position + Vector2(100,100), 0.15)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_sprite2d.queue_free()
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Defense(_user:Party_Member):
	_user.is_in_guard = true
	Flying_Label(_user.global_position, "+Guard")
#-------------------------------------------------------------------------------
func Skill_0_0(_user:Party_Member):
	var _global_position: Vector2 = _user.target.global_position + Vector2(-100, -150)
	var _dir: float = Get_Dir_XY(Vector2(50,100))
	var _bullet: Bullet = Create_PlayerBullet(_global_position, _dir)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	var _dx: float = 50
	var _dy: float = 50
	for _i in 4:
		_tween.tween_callback(func():
			PlayAnimation(_user.playback, "Shot")
			HP_Damage(_user.target, 5)
			_bullet.rotation = Get_Dir_XY(Vector2(50, _dy))
		)
		#-------------------------------------------------------------------------------
		_tween.tween_property(_bullet, "global_position", _bullet.global_position + Vector2(_dx,50+_dy), 0.1)
		_dx += 50
		_dy *=-1
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_bullet.queue_free()
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Skill_0_1(_user:Party_Member):
	var _global_position: Vector2 = _user.target.global_position + Vector2(-500, -100)
	var _sprite2d: Bullet = Create_PlayerBullet(_global_position, 0)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		PlayAnimation(_user.playback, "Shot")
		HP_Damage(_user.target, 15)
	)
	#-------------------------------------------------------------------------------
	_tween.tween_property(_sprite2d, "global_position", _global_position + Vector2(700,0), 0.3)
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
func Flying_Label(_pos:Vector2, _s:String):
	var _label: Label = Label.new()
	_label.add_theme_font_size_override("font_size", 24)
	_label.add_theme_constant_override("outline_size", 5)
	_label.text = _s
	_pos.y -= 75
	_label.global_position = _pos
	_label.z_index = 2
	world2d.add_child(_label)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_property(_label, "global_position", _pos + Vector2(25, -75), 0.2)
	_tween.tween_property(_label, "global_position", _pos + Vector2(50, 0), 0.2)
	_tween.tween_property(_label, "global_position", _pos + Vector2(65, -15), 0.1)
	_tween.tween_property(_label, "global_position", _pos + Vector2(80, 0), 0.1)
	_tween.tween_interval(0.7)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_label.queue_free()
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SP_Gain_VisualEffect(_pos:Vector2):
	var _label: Label = Label.new()
	_label.add_theme_font_size_override("font_size", 18)
	_label.add_theme_constant_override("outline_size", 4)
	_label.text = "+1 SP"
	_pos.y -= 10
	_pos.x = randf_range(_pos.x-25, _pos.x+25)
	_label.global_position = _pos
	_label.z_index = 2
	world2d.add_child(_label)
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_property(_label, "global_position", _pos + Vector2(0, -100), 1.0)
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
		var _global_position: Vector2 = _target.global_position
		_global_position.y += randf_range(-75, 25)
		#-------------------------------------------------------------------------------
		if(_target.hp > 0):
			PlayAnimation(_target.playback, "Hurt 2")
			Flying_Label(_global_position, "-"+str(_int)+" HP")
		#-------------------------------------------------------------------------------
		else:
			_target.hp = 0
			PlayAnimation(_target.playback, "Death")
			Flying_Label(_global_position, "Down")
		#-------------------------------------------------------------------------------
		Set_HP_Label(_target)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func HP_Heal_Porcentual(_target:Party_Member, _float:float):
	var _int: int = int(float(_target.max_hp)*_float)
	_target.hp += _int
	#-------------------------------------------------------------------------------
	var _global_position: Vector2 = _target.global_position
	_global_position.y += randf_range(-75, 25)
	#-------------------------------------------------------------------------------
	if(_target.hp < _target.max_hp):
		Flying_Label(_global_position, "+"+str(_int)+" HP")
	#-------------------------------------------------------------------------------
	else:
		_target.hp = _target.max_hp
		Flying_Label(_global_position, "Max HP")
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
#endregion
#-------------------------------------------------------------------------------
#region COMMON BUTTON FUNCTIONS
func SetButton(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
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
func CommonSelected():
	pass
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
	_s += "-------------------------------------------------------\n"
	_s += str(Engine.get_frames_per_second()) + " fps.\n"
	_s += "Tweens: "+str(tween_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Player: " + str(player.size())+"\n"
	_s += "Player Alive: " + str(player_alive.size())+"\n"
	_s += "Player Death: " + str(player_death.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Enemy: " + str(enemy.size())+"\n"
	_s += "Enemy Alive: " + str(enemy_alive.size())+"\n"
	_s += "Enemy Death: " + str(enemy_death.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Enemy Bullets Enabled: " + str(enemyBullets_Enabled_Array.size())+"\n"
	_s += "Enemy Bullets Disabled: " + str(enemyBullets_Disabled_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	if(item_array.size() > 0):
		_s += "Potion Item: " + str(item_array[0].hold)+"\n"
	if(item_array_in_battle.size() > 0):
		_s += "Potion Item in Battle: " + str(item_array_in_battle[0].hold)+"\n"
	if(player[2].skill_array.size() > 0):
		_s += "Potion Skill: " + str(player[2].skill_array[0].hold)+"\n"
	if(player[2].skill_array_in_battle.size() > 0):
		_s += "Potion Skill in Battle: " + str(player[2].skill_array_in_battle[0].hold)+"\n"
	debug_label.text = _s
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
		if(get_tree().paused):
			PauseOff()
		#-------------------------------------------------------------------------------
		else:
			pauseLabel.show()
			get_tree().set_deferred("paused", true)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func PauseOff():
	pauseLabel.hide()
	get_tree().set_deferred("paused", false)
#endregion
#-------------------------------------------------------------------------------
