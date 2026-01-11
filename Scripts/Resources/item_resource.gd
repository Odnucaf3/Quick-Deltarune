extends Resource
class_name Item_Resource
#-------------------------------------------------------------------------------
enum TARGET_TYPE{ENEMY_1, ALLY_1, ALLY_DEATH, USER}
#-------------------------------------------------------------------------------
#region VARIABLES
@export_category("Common Paramenters")
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
@export var tp_cost: int
@export var max_cooldown: int
#-------------------------------------------------------------------------------
@export_category("Item Paramenters")
@export var max_hold: int
@export var price: int
#endregion
#-------------------------------------------------------------------------------
