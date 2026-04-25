extends Resource
class_name Party_Member_Serializable
#-------------------------------------------------------------------------------
@export var party_member_resource: Party_Member_Resource
#-------------------------------------------------------------------------------
@export var level: int = 1
@export var experience: int = 0
#-------------------------------------------------------------------------------
var hp: int
var sp: int
#-------------------------------------------------------------------------------
var base_stats_dictionarty: Dictionary[StringName, int] = {		#NOTA: Este diccionario está hecho para tener los elementos con este orden.
	"max_hp": 0,												#NOTA: También puedo borrar las stats que piense que no vaya a usar.
	#"max_sp": 0,
	"physical_attack": 0,
	"physical_defense": 0,
	"magical_attack": 0,
	"magical_defense": 0,
	#"agility": 0,
	"luck": 0,
}
#-------------------------------------------------------------------------------
var skill_serializable_array: Array[Item_Serializable]
#-------------------------------------------------------------------------------
var equip_serializable_array: Array[Equip_Serializable]
#-------------------------------------------------------------------------------
var status_effect_serializable_array: Array[StatusEffect_Serializable]
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
	_party_member.base_stats_dictionarty.clear()
	#-------------------------------------------------------------------------------
	for _i in base_stats_dictionarty.size():
		var _key: StringName = base_stats_dictionarty.keys()[_i]
		var _value: int = base_stats_dictionarty.values()[_i]
		_party_member.base_stats_dictionarty[_key] = _value
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
	#var _skill_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	#for _i in skill_serializable_array.size():
	#	var _skill_dictionary: Dictionary = skill_serializable_array[_i].SaveData_Constructor()
	#	_skill_data.append(_skill_dictionary)
	#-------------------------------------------------------------------------------
	#_dictionary["skill_serializable_array"] = _skill_data
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
	#var _skill_array:Array = _dictionaty.get("skill_serializable_array", [])
	#-------------------------------------------------------------------------------
	#for _i in _skill_array.size():
	#	var _skill: Item_Serializable = Item_Serializable.new()
	#	_skill.LoadData_Constructor(_skill_array[_i])
	#	skill_serializable_array.append(_skill)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Skills():
	skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in party_member_resource.skill_resource_array.size():
		var _skill_serializable: Item_Serializable = Set_Skill_Starting_Values(party_member_resource.skill_resource_array[_i])
		skill_serializable_array.append(_skill_serializable)
	#-------------------------------------------------------------------------------
	for _i in equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(equip_serializable_array[_i].equip_resource != null):
			equip_serializable_array[_i].skill_serializable_array.clear()
			#-------------------------------------------------------------------------------
			for _j in equip_serializable_array[_i].equip_resource.skill_resource_array.size():
				var _skill_serializable_1: Item_Serializable = Set_Skill_Starting_Values(equip_serializable_array[_i].equip_resource.skill_resource_array[_j])
				equip_serializable_array[_i].skill_serializable_array.append(_skill_serializable_1)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in status_effect_serializable_array.size():
		status_effect_serializable_array[_i].skill_serializable_array.clear()
		#-------------------------------------------------------------------------------
		for _j in status_effect_serializable_array[_i].statuseffect_resource.skill_resource_array.size():
			var _skill_serializable_1: Item_Serializable = Set_Skill_Starting_Values(status_effect_serializable_array[_i].statuseffect_resource.skill_resource_array[_j])
			status_effect_serializable_array[_i].skill_serializable_array.append(_skill_serializable_1)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	#Set_Start_Old()
#-------------------------------------------------------------------------------
func Get_Skills() -> Array[Item_Serializable]:
	var _skill_array: Array[Item_Serializable]
	_skill_array.append_array(skill_serializable_array)
	#-------------------------------------------------------------------------------
	for _i in equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(equip_serializable_array[_i].equip_resource != null):
			_skill_array.append_array(equip_serializable_array[_i].skill_serializable_array)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in status_effect_serializable_array.size():
		_skill_array.append_array(status_effect_serializable_array[_i].skill_serializable_array)
	#-------------------------------------------------------------------------------
	return _skill_array
#-------------------------------------------------------------------------------
func Set_Skill_Starting_Values(_skill_resource: Item_Resource) -> Item_Serializable:
	var _skill_serializable: Item_Serializable = Item_Serializable.new()
	#-------------------------------------------------------------------------------
	_skill_serializable.item_resource = _skill_resource
	_skill_serializable.cooldown = 0
	_skill_serializable.hold = _skill_serializable.item_resource.max_hold
	#-------------------------------------------------------------------------------
	return _skill_serializable
#-------------------------------------------------------------------------------
func Set_Empty_EquipSlots_Types():
	equip_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in party_member_resource.equip_type_array.size():
		var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
		#-------------------------------------------------------------------------------
		_equip_serializable.myEQUIP_TYPE = party_member_resource.equip_type_array[_i]
		#-------------------------------------------------------------------------------
		equip_serializable_array.append(_equip_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Start_Old():	#Esto es viejo, no sirve
	for _i in base_stats_dictionarty.size():
		var _key: String = base_stats_dictionarty.keys()[_i]
		base_stats_dictionarty.set(_key, party_member_resource.base_stats_dictionarty.get(_key, 0))
		#-------------------------------------------------------------------------------
		for _j in equip_serializable_array.size():
			if(equip_serializable_array[_j].equip_resource != null):
				base_stats_dictionarty.set(_key, base_stats_dictionarty.get(_key, 0) + equip_serializable_array[_j].equip_resource.base_stats_dictionarty.get(_key, 0))
		#-------------------------------------------------------------------------------
		for _j in status_effect_serializable_array.size():
			base_stats_dictionarty.set(_key, base_stats_dictionarty.get(_key, 0) + status_effect_serializable_array[_j].statuseffect_resource.base_stats_dictionarty.get(_key, 0))
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
