extends Resource
class_name Item_Resource
#-------------------------------------------------------------------------------
enum TARGET_TYPE{ENEMY_1, ALLY_1, ALLY_DEATH, USER}
#-------------------------------------------------------------------------------
#region VARIABLES
@export_category("Common Paramenters")
var id: StringName
@export var myTARGET_TYPE: TARGET_TYPE
@export var speed: int
@export var anim: String = "Aim"
@export var action_string: String = "Do_Nothing"
#-------------------------------------------------------------------------------
@export_multiline  var lore: String
@export_multiline  var description: String
#-------------------------------------------------------------------------------
@export_category("Skill Paramenters")
@export var hp_cost: int
@export var sp_cost: int
@export var max_cooldown: int = 3
var cooldown: int = 0
#-------------------------------------------------------------------------------
@export_category("Item Paramenters")
@export var max_hold: int = 10
var hold: int = 0
#endregion
#-------------------------------------------------------------------------------
func Constructor() -> Item_Resource:
	var _item_resource_new: Item_Resource = Item_Resource.new()
	#-------------------------------------------------------------------------------
	_item_resource_new.id = id
	_item_resource_new.action_string = action_string
	#-------------------------------------------------------------------------------
	_item_resource_new.lore = lore
	_item_resource_new.description = description
	#-------------------------------------------------------------------------------
	_item_resource_new.myTARGET_TYPE = myTARGET_TYPE
	_item_resource_new.speed = speed
	#-------------------------------------------------------------------------------
	_item_resource_new.hp_cost = hp_cost
	_item_resource_new.sp_cost = sp_cost
	_item_resource_new.max_cooldown = max_cooldown
	_item_resource_new.cooldown = cooldown
	#-------------------------------------------------------------------------------
	_item_resource_new.max_hold = max_hold
	_item_resource_new.hold = hold
	#-------------------------------------------------------------------------------
	return _item_resource_new
#-------------------------------------------------------------------------------
