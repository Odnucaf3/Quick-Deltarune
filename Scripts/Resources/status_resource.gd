extends Resource
class_name Status_Resource
#-------------------------------------------------------------------------------
var id: StringName
#-------------------------------------------------------------------------------
@export_multiline  var lore: String
@export_multiline  var description: String
#-------------------------------------------------------------------------------
@export var max_hold: int = 10
var hold: int = 0
#-------------------------------------------------------------------------------#-------------------------------------------------------------------------------
func Constructor() -> Status_Resource:
	var _status_resource_new: Status_Resource = Status_Resource.new()
	#-------------------------------------------------------------------------------
	_status_resource_new.id = id
	#-------------------------------------------------------------------------------
	_status_resource_new.lore = lore
	_status_resource_new.description = description
	#-------------------------------------------------------------------------------
	_status_resource_new.hold = hold
	_status_resource_new.max_hold = max_hold
	#-------------------------------------------------------------------------------
	return _status_resource_new
#-------------------------------------------------------------------------------
