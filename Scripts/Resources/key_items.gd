extends Resource
class_name Key_Item_Resource
#-------------------------------------------------------------------------------
var id: StringName
#-------------------------------------------------------------------------------
@export_multiline  var lore: String
@export_multiline  var description: String
#-------------------------------------------------------------------------------
var hold: int = 0
#-------------------------------------------------------------------------------
func Constructor() -> Key_Item_Resource:
	var _key_item_resource_new: Key_Item_Resource = Key_Item_Resource.new()
	#-------------------------------------------------------------------------------
	_key_item_resource_new.id = id
	#-------------------------------------------------------------------------------
	_key_item_resource_new.lore = lore
	_key_item_resource_new.description = description
	#-------------------------------------------------------------------------------
	_key_item_resource_new.hold = hold
	#-------------------------------------------------------------------------------
	return _key_item_resource_new
#-------------------------------------------------------------------------------
