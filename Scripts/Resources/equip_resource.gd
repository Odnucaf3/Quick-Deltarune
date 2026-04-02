extends Resource
class_name Equip_Resource
#-------------------------------------------------------------------------------
enum EQUIP_TYPE{WEAPON, HEAD, BODY, RING}
#-------------------------------------------------------------------------------
@export var myEQUIP_TYPE: EQUIP_TYPE
#-------------------------------------------------------------------------------
@export var base_stats_dictionarty: Dictionary[StringName, int] = {
	"max_hp": 0,
	"max_sp": 0,
	"physical_attack": 0,
	"physical_defense": 0,
	"magical_attack": 0,
	"magical_defense": 0,
	"agility": 0,
	"luck": 0
}
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
