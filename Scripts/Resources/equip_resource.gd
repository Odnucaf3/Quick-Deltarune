extends Resource
class_name Equip_Resource
#-------------------------------------------------------------------------------
var id: StringName
#-------------------------------------------------------------------------------
@export_multiline  var lore: String
@export_multiline  var description: String
#-------------------------------------------------------------------------------
var hold: int = 0
@export var price: int = 0
#-------------------------------------------------------------------------------
func Constructor() -> Equip_Resource:
	var _equip_resource_new: Equip_Resource = Equip_Resource.new()
	#-------------------------------------------------------------------------------
	_equip_resource_new.id = id
	#-------------------------------------------------------------------------------
	_equip_resource_new.lore = lore
	_equip_resource_new.description = description
	#-------------------------------------------------------------------------------
	_equip_resource_new.hold = hold
	#-------------------------------------------------------------------------------
	return _equip_resource_new
#-------------------------------------------------------------------------------
