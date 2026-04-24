extends Resource
class_name StatusEffect_Serializable
#-------------------------------------------------------------------------------
@export var statuseffect_resource: StatusEffect_Resource
@export var stored: int = 0
#-------------------------------------------------------------------------------
var skill_serializable_array: Array[Item_Serializable]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
func Constructor() -> StatusEffect_Serializable:
	var _new_statuseffect_serializable: StatusEffect_Serializable = StatusEffect_Serializable.new()
	#-------------------------------------------------------------------------------
	_new_statuseffect_serializable.statuseffect_resource = statuseffect_resource
	_new_statuseffect_serializable.stored = stored
	#-------------------------------------------------------------------------------
	_new_statuseffect_serializable.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in skill_serializable_array.size():
		var _new_skill_serializable: Item_Serializable = skill_serializable_array[_i].Constructor()
		_new_statuseffect_serializable.skill_serializable_array.append(_new_skill_serializable)
	#-------------------------------------------------------------------------------
	return _new_statuseffect_serializable
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	_dictionary["statuseffect_resource"] = statuseffect_resource.resource_path
	_dictionary["stored"] = stored
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	statuseffect_resource = load(_dictionaty["statuseffect_resource"]) as StatusEffect_Resource
	stored = _dictionaty.get("stored", 0)
#-------------------------------------------------------------------------------
