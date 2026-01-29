extends Resource
class_name Equip_Serializable
#-------------------------------------------------------------------------------
@export var equip_resource: Equip_Resource
@export var stored: int = 1
@export var price: int = 0
#-------------------------------------------------------------------------------
func Constructor() -> Equip_Serializable:
	var _equip_serializable_new: Equip_Serializable = Equip_Serializable.new()
	#-------------------------------------------------------------------------------
	_equip_serializable_new.equip_resource = equip_resource
	_equip_serializable_new.stored = stored
	_equip_serializable_new.price = price
	#-------------------------------------------------------------------------------
	return _equip_serializable_new
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	if(equip_resource == null):
		_dictionary["equip_resource"] = ""
	#-------------------------------------------------------------------------------
	else:
		_dictionary["equip_resource"] = equip_resource.resource_path
	#-------------------------------------------------------------------------------
	_dictionary["stored"] = stored
	_dictionary["price"] = price
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	#-------------------------------------------------------------------------------
	if(ResourceLoader.exists(_dictionaty["equip_resource"])):
		equip_resource = load(_dictionaty["equip_resource"]) as Equip_Resource
	#-------------------------------------------------------------------------------
	else:
		equip_resource = null
	#-------------------------------------------------------------------------------
	stored = _dictionaty.get("stored", 1)
	price = _dictionaty.get("price", 0)
#-------------------------------------------------------------------------------
