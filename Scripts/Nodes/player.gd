extends Node2D
class_name Party_Member
#-------------------------------------------------------------------------------
@export var id: StringName
@export var texture2d: Texture2D
var hp: int
@export var max_hp: int = 15
var sp: int
@export var max_sp: int = 20
#-------------------------------------------------------------------------------
@export_multiline  var lore: String
@export_multiline  var description: String
#-------------------------------------------------------------------------------
var is_in_guard: bool
var damage_label_array: Array[Label] = []
#-------------------------------------------------------------------------------
@export var skill_array: Array[Item_Serializable]
var skill_array_in_battle: Array[Item_Serializable]
#-------------------------------------------------------------------------------
@export var equip_array: Array[Equip_Serializable] = [null, null, null, null, null, null, null, null]
var equip_array_in_battle: Array[Equip_Serializable]
#-------------------------------------------------------------------------------
@export var statuseffect_array: Array[StatusEffect_Serializable]
var statuseffect_array_in_battle: Array[StatusEffect_Serializable]
#-------------------------------------------------------------------------------
var can_enter_fight: bool
var is_Facing_Left: bool = false
var is_Moving: bool = false
#-------------------------------------------------------------------------------
var user_party: Array[Party_Member]
var target: Party_Member
var target_party: Array[Party_Member]
#-------------------------------------------------------------------------------
var item_serializable: Item_Serializable
#-------------------------------------------------------------------------------
@export var pivot: Marker2D
@export var sprite: Sprite2D
#-------------------------------------------------------------------------------
@export var animation_tree: AnimationTree
var playback : AnimationNodeStateMachinePlayback
#-------------------------------------------------------------------------------
var party_member_ui: Party_Member_UI
#-------------------------------------------------------------------------------
func Constructor() -> Party_Member:
	var _party_member: Party_Member = Party_Member.new()
	#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _party_member
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	var _skill_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in skill_array.size():
		var _skill_dictionary: Dictionary = skill_array[_i].SaveData_Constructor()
		_skill_data.append(_skill_dictionary)
	#-------------------------------------------------------------------------------
	_dictionary["skill_array"] = _skill_data
	#-------------------------------------------------------------------------------
	var _equip_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		if(equip_array[_i] == null):
			_equip_data.append({})
		else:
			var _equip_dictionary: Dictionary = equip_array[_i].SaveData_Constructor()
			_equip_data.append(_equip_dictionary)
	#-------------------------------------------------------------------------------
	_dictionary["equip_array"] = _equip_data
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	skill_array.clear()
	#-------------------------------------------------------------------------------
	var _skill_array:Array = _dictionaty["skill_array"]
	#-------------------------------------------------------------------------------
	for _i in _skill_array.size():
		var _skill: Item_Serializable = Item_Serializable.new()
		_skill.LoadData_Constructor(_skill_array[_i])
		skill_array.append(_skill)
	#-------------------------------------------------------------------------------
	equip_array.clear()
	#-------------------------------------------------------------------------------
	var _equip_array:Array = _dictionaty["equip_array"]
	#-------------------------------------------------------------------------------
	for _i in _equip_array.size():
		if(_equip_array[_i] == {}):
			equip_array.append(null)
		else:
			var _equip: Equip_Serializable = Equip_Serializable.new()
			_equip.LoadData_Constructor(_equip_array[_i])
			equip_array.append(_equip)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
