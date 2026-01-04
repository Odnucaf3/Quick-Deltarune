extends Resource
class_name Item_Serializable
#-------------------------------------------------------------------------------
@export var item_resource: Item_Resource
@export var cooldown: int = 0
@export var hold: int = 1
#-------------------------------------------------------------------------------
func Constructor() -> Item_Serializable:
	var _item_serializable_new: Item_Serializable = Item_Serializable.new()
	#-------------------------------------------------------------------------------
	_item_serializable_new.item_resource = item_resource
	_item_serializable_new.cooldown = cooldown
	_item_serializable_new.hold = hold
	#-------------------------------------------------------------------------------
	return _item_serializable_new
#-------------------------------------------------------------------------------
func SaveData_Constructor() -> Dictionary:
	var _dictionary: Dictionary = {}
	#-------------------------------------------------------------------------------
	_dictionary["item_resource"] = item_resource.resource_path
	_dictionary["cooldown"] = cooldown
	_dictionary["hold"] = hold
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
func LoadData_Constructor(_dictionaty:Dictionary):
	item_resource = load(_dictionaty["item_resource"]) as Item_Resource
	cooldown = _dictionaty["cooldown"]
	hold = _dictionaty["hold"]
#-------------------------------------------------------------------------------
