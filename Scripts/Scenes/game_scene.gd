extends Node
class_name Game_Scene
#-------------------------------------------------------------------------------
enum GAME_STATE{IN_WORLD, IN_MENU, IN_BATTLE}
#-------------------------------------------------------------------------------
#region VARIABLES
@export var player: Array[Party_Member]
@export var enemy: Array[Party_Member]
var camera_offset_y: float = 125
@export var black_panel: Panel
@export var battle_black_panel: Panel
@export var pauseLabel: Label
var isSlowMotion: bool = false
#-------------------------------------------------------------------------------
var can_enter_fight: bool = true
var player_last_position: Vector2
var enemy_last_position: Vector2
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
var grazeBox_radius: float = 30.0
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
		player[_i].party_member_ui.hide()
		player[_i].party_member_ui.button.hide()
		PlayAnimation(player[_i].playback, "Idle")
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].playback = enemy[_i].animation_tree.get("parameters/playback")
		enemy[_i].party_member_ui.hide()
		enemy[_i].party_member_ui.button.hide()
		enemy[_i].party_member_ui.label_sp.hide()
		PlayAnimation(enemy[_i].playback, "Idle")
	#-------------------------------------------------------------------------------
	win_label.hide()
	retry_menu.hide()
	battle_menu.hide()
	battle_box.hide()
	battle_menu_rect.hide()
	timer_label.hide()
	battle_black_panel.hide()
	camera.position = player[0].position + Vector2(0, -camera_offset_y)
	var _width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var _height: float = ProjectSettings.get_setting("display/window/size/viewport_height")
	viewport_size = Vector2(_width, _height)
	viewport_center = viewport_size/2.0
	#-------------------------------------------------------------------------------
	PauseOff()
	NormalMotion()
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
				Camera_Follow()
				Check_for_Enemy()
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
	camera.position = lerp(camera.position, player[0].position + Vector2(0, -camera_offset_y), 0.1)
#-------------------------------------------------------------------------------
func Check_for_Enemy():
	#-------------------------------------------------------------------------------
	if(player[0].position.distance_to(enemy[0].position) < 60 and can_enter_fight):
		EnterBattle()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func EnterBattle():
	myGAME_STATE = GAME_STATE.IN_MENU
	#-------------------------------------------------------------------------------
	for _i in player.size():
		player[_i].collider.disabled = true
		PlayAnimation(player[_i].playback, "Idle")
		player[_i].z_index = 1
		player[_i].global_position = player[0].global_position
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		enemy[_i].collider.disabled = true
		PlayAnimation(enemy[_i].playback, "Idle")
		enemy[_i].z_index = 1
		enemy[_i].sprite.flip_h = false
		enemy[_i].scale.x = -1.0
		#enemy[_i].global_position = enemy[0].global_position
	#-------------------------------------------------------------------------------
	Face_Left(false)
	#-------------------------------------------------------------------------------
	player_last_position = player[0].global_position
	enemy_last_position = enemy[0].global_position
	#-------------------------------------------------------------------------------
	var _center: Vector2 = camera.position
	#-------------------------------------------------------------------------------
	battle_black_panel.global_position = _center-battle_black_panel.size/2.0
	battle_black_panel.show()
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_interval(0.5)
	_tween.tween_interval(0.5)
	#-------------------------------------------------------------------------------
	var _top_limit: float = 0.4
	var _botton_limit: float = 0.8
	#-------------------------------------------------------------------------------
	for _i in player.size():
		var _y_pos: float = -viewport_size.y*_top_limit + viewport_size.y*_botton_limit* (float(_i+1)/(player.size()))
		var _x_pos: float = -400
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		player[_i].party_member_ui.global_position = viewport_center + Vector2(_x_pos, _y_pos)
		player[_i].party_member_ui.offset.position.x = -100
		_tween.parallel().tween_property(player[_i], "position", _position, 0.5)
	#-------------------------------------------------------------------------------
	for _i in enemy.size():
		var _y_pos: float = -viewport_size.y*_top_limit + viewport_size.y*_botton_limit* (float(_i+1)/(enemy.size()))
		var _x_pos: float = 400
		var _position: Vector2 =  _center + Vector2(_x_pos, _y_pos)
		enemy[_i].party_member_ui.global_position = viewport_center + Vector2(_x_pos, _y_pos)
		enemy[_i].party_member_ui.offset.position.x = 100
		_tween.parallel().tween_property(enemy[_i], "position", _position, 0.5)
	#-------------------------------------------------------------------------------
	battle_menu.position = player[0].party_member_ui.position + Vector2(60, -85)
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
		#-------------------------------------------------------------------------------
		for _i in player.size():
			player[_i].hp = player[_i].max_hp
			Set_HP_Label(player[_i].party_member_ui.label_hp, player[_i].hp, player[_i].max_hp)
			player[_i].sp = 0
			Set_SP_Label(player[_i].party_member_ui.label_sp, player[_i].sp, player[_i].max_sp)
			player[_i].party_member_ui.show()
			player[_i].party_member_ui.button.hide()
		#-------------------------------------------------------------------------------
		for _i in enemy.size():
			enemy[_i].hp = enemy[_i].max_hp
			Set_HP_Label(enemy[_i].party_member_ui.label_hp, enemy[_i].hp, enemy[_i].max_hp)
			enemy[_i].sp = 0
			Set_SP_Label(enemy[_i].party_member_ui.label_sp, enemy[_i].sp, enemy[_i].max_sp)
			enemy[_i].party_member_ui.show()
			enemy[_i].party_member_ui.button.hide()
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Face_Left(_b:bool):
	player[0].sprite.flip_h = _b
	is_Facing_Left = _b
#endregion
#-------------------------------------------------------------------------------
#region IN_MENU FUNCTIONS
func BattleMenu_AttackButton_Submit():
	battle_menu.hide()
	enemy[0].party_member_ui.button.show()
	Move_to_Button(enemy[0].party_member_ui.button)
	SetButton(enemy[0].party_member_ui.button, func():CommonSelected(), func():TargetMenu_EnemyButton_Submit(), func():TargetMenu_EnemyButton_Cancel())
#-------------------------------------------------------------------------------
func BattleMenu_DefenseButton_Submit():
	battle_menu.hide()
	player[0].party_member_ui.button.show()
	Move_to_Button(player[0].party_member_ui.button)
	SetButton(player[0].party_member_ui.button, func():CommonSelected(), func():TargetMenu_PlayerButton_Submit(), func():TargetMenu_PlayerButton_Cancel())
#-------------------------------------------------------------------------------
func BattleMenu_AnyButton_Cancel():
	battle_menu.hide()
	win_label.text = "Escape?"
	win_label.show()
	retry_menu.show()
	Move_to_Button(retry_menu_button[0])
	SetButton(retry_menu_button[0], func():CommonSelected(), func():RetryMenu_RetryButton_Submit(), func():RetryMenu_AnyButton_Cancel())
	SetButton(retry_menu_button[1], func():CommonSelected(), func():RetryMenu_EscapeButton_Submit(), func():RetryMenu_AnyButton_Cancel())
	SetButton(retry_menu_button[2], func():CommonSelected(), func():RetryMenu_ReturnToSavePointButton_Submit(), func():RetryMenu_AnyButton_Cancel())
#-------------------------------------------------------------------------------
func TargetMenu_EnemyButton_Submit():
	enemy[0].party_member_ui.button.hide()
	player[0].is_in_guard = false
	var _tween: Tween = create_tween()
	_tween.tween_interval(0.5)
	#-------------------------------------------------------------------------------
	for _i in player.size():
		#-------------------------------------------------------------------------------
		_tween.tween_callback(func():
			PlayAnimation(player[_i].playback, "Shot")
			enemy[0].hp -= 5
			#-------------------------------------------------------------------------------
			if(enemy[0].hp > 0):
				PlayAnimation(enemy[0].playback, "Hurt 2")
			#-------------------------------------------------------------------------------
			else:
				PlayAnimation(enemy[0].playback, "Death")
			#-------------------------------------------------------------------------------
			Set_HP_Label(enemy[0].party_member_ui.label_hp, enemy[0].hp, enemy[0].max_hp)
		)
		#-------------------------------------------------------------------------------
		_tween.tween_interval(0.3)
	#-------------------------------------------------------------------------------
	_tween.tween_interval(1.0)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		#-------------------------------------------------------------------------------
		for _i in player.size():
			PlayAnimation(player[_i].playback, "Idle")
		#-------------------------------------------------------------------------------
		if(enemy[0].hp > 0):
			PlayAnimation(enemy[0].playback, "Idle")
			Start_BulletHell()
		#-------------------------------------------------------------------------------
		else:
			#-------------------------------------------------------------------------------
			for _i in player.size():
				player[_i].party_member_ui.hide()
				player[_i].party_member_ui.button.hide()
			#-------------------------------------------------------------------------------
			for _i in enemy.size():
				enemy[_i].party_member_ui.hide()
				enemy[_i].party_member_ui.button.hide()
			#-------------------------------------------------------------------------------
			retry_menu.hide()
			win_label.text = "You Win"
			win_label.show()
			#-------------------------------------------------------------------------------
			can_enter_fight = false
			#-------------------------------------------------------------------------------
			var _tween3: Tween = create_tween()
			_tween3.tween_interval(1.0)
			_tween3.tween_property(player[0], "global_position", player_last_position, 0.5)
			_tween3.parallel().tween_property(enemy[0], "global_position", enemy_last_position, 0.5)
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
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func TargetMenu_EnemyButton_Cancel():
	battle_menu.show()
	enemy[0].party_member_ui.button.hide()
	Move_to_Button(battle_menu_button[0])
#-------------------------------------------------------------------------------
func TargetMenu_PlayerButton_Submit():
	player[0].party_member_ui.button.hide()
	player[0].is_in_guard = true
	PlayAnimation(player[0].playback, "Crouch")
	Start_BulletHell()
#-------------------------------------------------------------------------------
func TargetMenu_PlayerButton_Cancel():
	battle_menu.show()
	player[0].party_member_ui.button.hide()
	Move_to_Button(battle_menu_button[1])
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
		PlayAnimation(player[0].playback, "Idle")
		#-------------------------------------------------------------------------------
		player[0].hp = player[0].max_hp
		Set_HP_Label(player[0].party_member_ui.label_hp, player[0].hp, player[0].max_hp)
		player[0].party_member_ui.show()
		#-------------------------------------------------------------------------------
		player[0].sp = 0
		Set_SP_Label(player[0].party_member_ui.label_sp, player[0].sp, player[0].max_sp)
		#-------------------------------------------------------------------------------
		enemy[0].hp = enemy[0].max_hp
		Set_HP_Label(enemy[0].party_member_ui.label_hp, enemy[0].hp, enemy[0].max_hp)
		enemy[0].party_member_ui.show()
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
	_tween3.tween_property(player[0], "global_position", player_last_position, 0.5)
	_tween3.parallel().tween_property(enemy[0], "global_position", enemy_last_position, 0.5)
	#-------------------------------------------------------------------------------
	_tween3.tween_callback(func():
		myGAME_STATE = GAME_STATE.IN_WORLD
		player[0].collider.disabled = false
	)
	#-------------------------------------------------------------------------------
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
	var _tween: Tween = CreateTween_ArrayAppend(main_tween_Array)
	Stage1_Fire2(_tween, enemy[0], 1)
	#-------------------------------------------------------------------------------
	await TimeOut_Tween(7)
	battle_menu.show()
	battle_box.hide()
	myGAME_STATE = GAME_STATE.IN_MENU
	Move_to_Button(battle_menu_button[0])
	PlayAnimation(player[0].playback, "Idle")
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
func StopEverithing():
	timer_label.text = ""
	timer_label.hide()
	#-------------------------------------------------------------------------------
	KillTween_Array(main_tween_Array)
	#-------------------------------------------------------------------------------
	for _i in range(enemyBullets_Enabled_Array.size()-1, -1, -1):
		Destroy_EnemyBullet(enemyBullets_Enabled_Array[_i])
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
func Stage1_Fire2(_tween:Tween, _node2D: Node2D, _mirror:float):
	var _max1: float = 10 
	var _max2: float = 50
	var _vel: float = 4 
	var _timer: float = 0.2 
	#-------------------------------------------------------------------------------
	var _ang: float = 0
	var _dir: float = 90
	#-------------------------------------------------------------------------------
	var _bullet: Bullet = Create_EnemyBullet_A(camera.position.x+viewport_center.x*0.5, camera.position.y-viewport_center.y*0.5, 1, 90, "bullet2", false)
	#-------------------------------------------------------------------------------
	for _j in _max2:
		#-------------------------------------------------------------------------------
		_tween.tween_callback(func():
			var _dir2: float = 0
			#-------------------------------------------------------------------------------
			for _i in _max1:
				var _x:float = _bullet.global_position.x
				var _y:float = _bullet.global_position.y
				var _bullet2: Bullet = Create_EnemyBullet_A(_x, _y, _vel, _dir+_dir2+_ang, "bullet2", false)
				_dir2 += 360/_max1
			#-------------------------------------------------------------------------------
		)
		#-------------------------------------------------------------------------------
		_ang += 5.0*_mirror
		#-------------------------------------------------------------------------------
		_tween.tween_interval(_timer)
	#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region HITBOX FUNCTIONS
func Hitbox_Damage():
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
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Player_Shooted():
	#-------------------------------------------------------------------------------
	if(player[0].is_in_guard):
		player[0].hp -= 5
	#-------------------------------------------------------------------------------
	else:
		player[0].hp -= 10
	#-------------------------------------------------------------------------------
	if(player[0].hp > 0):
		#-------------------------------------------------------------------------------
		if(player[0].is_in_guard):
			PlayAnimation(player[0].playback, "Crouch_Hurt")
		#-------------------------------------------------------------------------------
		else:
			PlayAnimation(player[0].playback, "Hurt")
		#-------------------------------------------------------------------------------
		Set_HP_Label(player[0].party_member_ui.label_hp, player[0].hp, player[0].max_hp)
	#-------------------------------------------------------------------------------
	else:
		player[0].hp = 0
		Set_HP_Label(player[0].party_member_ui.label_hp, player[0].hp, player[0].max_hp)
		#-------------------------------------------------------------------------------
		var _tween:Tween = create_tween()
		#-------------------------------------------------------------------------------
		_tween.tween_callback(func():
			PlayAnimation(player[0].playback, "Death")
			myGAME_STATE = GAME_STATE.IN_MENU
			StopEverithing()
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
#-------------------------------------------------------------------------------
func Bullet_Grazed():
	player[0].sp += 1
	Set_SP_Label(player[0].party_member_ui.label_sp, player[0].sp, player[0].max_sp)
#endregion
#-------------------------------------------------------------------------------
#region COMMON FUNCTIONS
func Set_HP_Label(_label:Label, _hp:int, _max_hp:int):
	_label.text = "  "+str(_hp)+" / "+str(_max_hp)+" HP  "
#-------------------------------------------------------------------------------
func Set_SP_Label(_label:Label, _hp:int, _max_hp:int):
	_label.text = "  "+str(_hp)+" / "+str(_max_hp)+" SP  "
#-------------------------------------------------------------------------------
func PlayAnimation(_playback:AnimationNodeStateMachinePlayback, _s: String):
	#playback.travel(_s)
	_playback.call_deferred("travel", _s)
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
	_s += "-------------------------------------------------------\n"
	_s += str(Engine.get_frames_per_second()) + " fps.\n"
	_s += "Tweens: "+str(tween_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Enemy Bullets Enabled: " + str(enemyBullets_Enabled_Array.size())+"\n"
	_s += "Enemy Bullets Disabled: " + str(enemyBullets_Disabled_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
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
