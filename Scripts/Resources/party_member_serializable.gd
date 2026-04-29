extends Resource
class_name Party_Member_Serializable
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
@export var party_member_resource: Party_Member_Resource
#-------------------------------------------------------------------------------
@export var level: int = 1
@export var experience: int = 0
#-------------------------------------------------------------------------------
var hp: int
var sp: int
#-------------------------------------------------------------------------------
var skill_serializable_array: Array[Item_Serializable]
#-------------------------------------------------------------------------------
var equip_serializable_array: Array[Equip_Serializable]
#-------------------------------------------------------------------------------
var status_effect_serializable_array: Array[StatusEffect_Serializable]
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CONSTRUCTOR FUNCTIONS
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
func Constructor() -> Party_Member_Serializable:
	var _party_member: Party_Member_Serializable = Party_Member_Serializable.new()
	#-------------------------------------------------------------------------------
	_party_member.party_member_resource = party_member_resource
	#-------------------------------------------------------------------------------
	_party_member.level = level
	_party_member.experience = experience
	_party_member.hp = hp
	_party_member.sp = sp
	#-------------------------------------------------------------------------------
	_party_member.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in skill_serializable_array.size():
		_party_member.skill_serializable_array.append(skill_serializable_array[_i].Constructor())
	#-------------------------------------------------------------------------------
	_party_member.equip_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in equip_serializable_array.size():
		_party_member.equip_serializable_array.append(equip_serializable_array[_i].Constructor())
	#-------------------------------------------------------------------------------
	for _i in status_effect_serializable_array.size():
		_party_member.status_effect_serializable_array.append(status_effect_serializable_array[_i].Constructor())
	#-------------------------------------------------------------------------------
	return _party_member
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SAVE-DATA FUNCTIONS
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	var _equip_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in equip_serializable_array.size():
		var _equip_dictionary: Dictionary = equip_serializable_array[_i].SaveData_Constructor()
		_equip_data.append(_equip_dictionary)
	#-------------------------------------------------------------------------------
	_dictionary["equip_serializable_array"] = _equip_data
	#-------------------------------------------------------------------------------
	var _statuseffect_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in status_effect_serializable_array.size():
		var _statuseffect_dictionary: Dictionary = status_effect_serializable_array[_i].SaveData_Constructor()
		_statuseffect_data.append(_statuseffect_dictionary)
	#-------------------------------------------------------------------------------
	_dictionary["status_effect_serializable_array"] = _statuseffect_data
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	equip_serializable_array.clear()
	#-------------------------------------------------------------------------------
	var _equip_array:Array = _dictionaty.get("equip_serializable_array", [])
	#-------------------------------------------------------------------------------
	for _i in _equip_array.size():
		var _equip: Equip_Serializable = Equip_Serializable.new()
		_equip.LoadData_Constructor(_equip_array[_i])
		equip_serializable_array.append(_equip)
	#-------------------------------------------------------------------------------
	status_effect_serializable_array.clear()
	#-------------------------------------------------------------------------------
	var _statuseffect_array:Array = _dictionaty.get("status_effect_serializable_array", [])
	#-------------------------------------------------------------------------------
	for _i in _statuseffect_array.size():
		var _statuseffect: StatusEffect_Serializable = StatusEffect_Serializable.new()
		_statuseffect.LoadData_Constructor(_statuseffect_array[_i])
		status_effect_serializable_array.append(_statuseffect)
	#-------------------------------------------------------------------------------
	skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
