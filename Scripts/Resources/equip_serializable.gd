extends Resource
class_name Equip_Serializable
#-------------------------------------------------------------------------------
@export var equip_resource: Equip_Resource
@export var hold: int = 1
#-------------------------------------------------------------------------------
func Constructor() -> Equip_Serializable:
	var _equip_serializable_new: Equip_Serializable = Equip_Serializable.new()
	#-------------------------------------------------------------------------------
	_equip_serializable_new.equip_resource = equip_resource
	_equip_serializable_new.hold = hold
	#-------------------------------------------------------------------------------
	return _equip_serializable_new
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	_dictionary["equip_resource"] = equip_resource.resource_path
	_dictionary["hold"] = hold
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	equip_resource = load(_dictionaty["equip_resource"]) as Equip_Resource
	hold = _dictionaty["hold"]
#-------------------------------------------------------------------------------
