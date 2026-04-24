extends Resource
class_name Item_Resource
#-------------------------------------------------------------------------------
enum TARGET_TYPE{ONE_ENEMY, ALL_ENEMIES, ONE_ALLY, ALL_ALLIES, ONE_DEAD_ALLY, ALL_DEAD_ALLIES, USER}
#-------------------------------------------------------------------------------
#region VARIABLES
@export_category("Common Paramenters")
@export var myTARGET_TYPE: TARGET_TYPE
@export var speed: int
@export var anim: String = "Aim"
#-------------------------------------------------------------------------------
@export_category("Skill Paramenters")
@export var hp_cost: int
@export var sp_cost: int
@export var tp_cost: int
@export var max_cooldown: int
#-------------------------------------------------------------------------------
@export_category("Item Paramenters")
@export var max_hold: int
#endregion
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
