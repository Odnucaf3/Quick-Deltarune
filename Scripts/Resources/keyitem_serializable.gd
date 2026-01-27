extends Resource
class_name Key_Item_Serializable
#-------------------------------------------------------------------------------
@export var key_item_resource: Key_Item_Resource
@export var stored: int = 1
#-------------------------------------------------------------------------------
func Constructor() -> Key_Item_Serializable:
	var _key_item_serializable_new: Key_Item_Serializable = Key_Item_Serializable.new()
	#-------------------------------------------------------------------------------
	_key_item_serializable_new.key_item_resource = key_item_resource
	_key_item_serializable_new.stored = stored
	#-------------------------------------------------------------------------------
	return _key_item_serializable_new
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	_dictionary["key_item_resource"] = key_item_resource.resource_path
	_dictionary["stored"] = stored
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	key_item_resource = load(_dictionaty["key_item_resource"]) as Key_Item_Resource
	stored = _dictionaty.get("stored", 1)
#-------------------------------------------------------------------------------
