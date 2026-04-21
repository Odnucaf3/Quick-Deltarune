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
var skill_array: Array[Item_Serializable]
var skill_array_in_battle: Array[Item_Serializable]
#-------------------------------------------------------------------------------
var equip_array: Array[Equip_Serializable]
var equip_array_in_battle: Array[Equip_Serializable]
#-------------------------------------------------------------------------------
var statuseffect_array: Array[StatusEffect_Serializable]
var statuseffect_array_in_battle: Array[StatusEffect_Serializable]
var is_in_guard: bool
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
func Constructor() -> Party_Member_Serializable:
	var _party_member: Party_Member_Serializable = Party_Member_Serializable.new()
	#-------------------------------------------------------------------------------
	return _party_member
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	var _equip_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in equip_array.size():
		var _equip_dictionary: Dictionary = equip_array[_i].SaveData_Constructor()
		_equip_data.append(_equip_dictionary)
	#-------------------------------------------------------------------------------
	_dictionary["equip_array"] = _equip_data
	#-------------------------------------------------------------------------------
	var _statuseffect_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in statuseffect_array.size():
		var _statuseffect_dictionary: Dictionary = statuseffect_array[_i].SaveData_Constructor()
		_statuseffect_data.append(_statuseffect_dictionary)
	#-------------------------------------------------------------------------------
	_dictionary["statuseffect_array"] = _statuseffect_data
	#-------------------------------------------------------------------------------
	var _skill_data: Array[Dictionary] = []
	#-------------------------------------------------------------------------------
	for _i in skill_array.size():
		var _skill_dictionary: Dictionary = skill_array[_i].SaveData_Constructor()
		_skill_data.append(_skill_dictionary)
	#-------------------------------------------------------------------------------
	_dictionary["skill_array"] = _skill_data
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	equip_array.clear()
	#-------------------------------------------------------------------------------
	var _equip_array:Array = _dictionaty.get("equip_array", [])
	#-------------------------------------------------------------------------------
	for _i in _equip_array.size():
		var _equip: Equip_Serializable = Equip_Serializable.new()
		_equip.LoadData_Constructor(_equip_array[_i])
		equip_array.append(_equip)
	#-------------------------------------------------------------------------------
	statuseffect_array.clear()
	#-------------------------------------------------------------------------------
	var _statuseffect_array:Array = _dictionaty.get("statuseffect_array", [])
	#-------------------------------------------------------------------------------
	for _i in _statuseffect_array.size():
		var _statuseffect: StatusEffect_Serializable = StatusEffect_Serializable.new()
		_statuseffect.LoadData_Constructor(_statuseffect_array[_i])
		statuseffect_array.append(_statuseffect)
	#-------------------------------------------------------------------------------
	skill_array.clear()
	#-------------------------------------------------------------------------------
	var _skill_array:Array = _dictionaty.get("skill_array", [])
	#-------------------------------------------------------------------------------
	for _i in _skill_array.size():
		var _skill: Item_Serializable = Item_Serializable.new()
		_skill.LoadData_Constructor(_skill_array[_i])
		skill_array.append(_skill)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_All_PartyMember_Stats_and_Skills():
	skill_array.clear()
	#-------------------------------------------------------------------------------
	for _i in party_member_resource.skill_resource_array.size():
		var _item_serializable: Item_Serializable = Item_Serializable.new()
		#-------------------------------------------------------------------------------
		_item_serializable.item_resource = party_member_resource.skill_resource_array[_i]
		#-------------------------------------------------------------------------------
		skill_array.append(_item_serializable)
	#-------------------------------------------------------------------------------
	equip_array.clear()
	#-------------------------------------------------------------------------------
	for _i in party_member_resource.equip_type_array.size():
		var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
		#-------------------------------------------------------------------------------
		_equip_serializable.myEQUIP_TYPE = party_member_resource.equip_type_array[_i]
		#-------------------------------------------------------------------------------
		equip_array.append(_equip_serializable)
	#-------------------------------------------------------------------------------
	#Set_Start_Old()
#-------------------------------------------------------------------------------
func Set_Start_Old():
	for _i in base_stats_dictionarty.size():
		var _key: String = base_stats_dictionarty.keys()[_i]
		base_stats_dictionarty.set(_key, party_member_resource.base_stats_dictionarty.get(_key, 0))
		#-------------------------------------------------------------------------------
		for _j in equip_array.size():
			if(equip_array[_j].equip_resource != null):
				base_stats_dictionarty.set(_key, base_stats_dictionarty.get(_key, 0) + equip_array[_j].equip_resource.base_stats_dictionarty.get(_key, 0))
		#-------------------------------------------------------------------------------
		for _j in statuseffect_array.size():
			base_stats_dictionarty.set(_key, base_stats_dictionarty.get(_key, 0) + statuseffect_array[_j].statuseffect_resource.base_stats_dictionarty.get(_key, 0))
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
