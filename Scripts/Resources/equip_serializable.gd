extends Resource
class_name Equip_Serializable
#-------------------------------------------------------------------------------
@export var equip_resource: Equip_Resource
@export var myEQUIP_TYPE: Equip_Resource.EQUIP_TYPE
@export var stored: int = 1
@export var price: int = 0
#-------------------------------------------------------------------------------
var skill_serializable_array: Array[Item_Serializable]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
func Constructor() -> Equip_Serializable:
	var _new_equip_serializable: Equip_Serializable = Equip_Serializable.new()
	#-------------------------------------------------------------------------------
	_new_equip_serializable.equip_resource = equip_resource
	_new_equip_serializable.myEQUIP_TYPE = myEQUIP_TYPE
	_new_equip_serializable.stored = stored
	_new_equip_serializable.price = price
	#-------------------------------------------------------------------------------
	_new_equip_serializable.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in skill_serializable_array.size():
		var _new_skill_serializable: Item_Serializable = skill_serializable_array[_i].Constructor()
		_new_equip_serializable.skill_serializable_array.append(_new_skill_serializable)
	#-------------------------------------------------------------------------------
	return _new_equip_serializable
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
	_dictionary["myEQUIP_TYPE"] = myEQUIP_TYPE
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
	myEQUIP_TYPE = _dictionaty.get("myEQUIP_TYPE", Equip_Resource.EQUIP_TYPE.WEAPON)
	stored = _dictionaty.get("stored", 1)
	price = _dictionaty.get("price", 0)
#-------------------------------------------------------------------------------
