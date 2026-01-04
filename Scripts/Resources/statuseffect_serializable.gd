extends Resource
class_name StatusEffect_Serializable
#-------------------------------------------------------------------------------
@export var statuseffect_resource: StatusEffect_Resource
@export var hold: int = 0
#-------------------------------------------------------------------------------
func Constructor() -> StatusEffect_Serializable:
	var _statuseffect_serializable_new: StatusEffect_Serializable = StatusEffect_Serializable.new()
	#-------------------------------------------------------------------------------
	_statuseffect_serializable_new.statuseffect_resource = statuseffect_resource
	_statuseffect_serializable_new.hold = hold
	#-------------------------------------------------------------------------------
	return _statuseffect_serializable_new
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	_dictionary["statuseffect_resource"] = statuseffect_resource.resource_path
	_dictionary["hold"] = hold
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	statuseffect_resource = load(_dictionaty["statuseffect_resource"]) as StatusEffect_Resource
	hold = _dictionaty["hold"]
#-------------------------------------------------------------------------------
