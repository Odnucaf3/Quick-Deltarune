extends Resource
class_name Party_Member_Resource
#-------------------------------------------------------------------------------
@export var body_sprite: Texture2D
@export var face_sprite: Texture2D
#-------------------------------------------------------------------------------
var base_stats_dictionarty: Dictionary[StringName, int] = {
	"max_hp": 100,
	"max_sp": 20,
	"physical_attack": 10,
	"physical_defense": 10,
	"magical_attack": 10,
	"magical_defense": 10,
	"agility": 10,
	"luck": 10
}
#-------------------------------------------------------------------------------
var extra_stats_dictionarty: Dictionary[StringName, int] = {
	"physical_presition": 100,
	"physical_evasion": 0,
	"magical_presition": 100,
	"magical_evasion": 0,
	"hp_regeneration": 0,
	"sp_regeneration": 0,
	"tp_regeneration": 0
}
#-------------------------------------------------------------------------------
var special_stats_dictionarty: Dictionary[StringName, int] = {
	"target_rate": 100,
	"guard_effect_rate": 50,
	"recovery_effect_rate": 100,
	"pharmacology": 100,
	"hp_cost_rate": 100,
	"sp_cost_rate": 100,
	"tp_cost_rate": 100,
	"physical_damage_rate": 100,
	"magical_damage_rate": 100,
	"gold_rate": 100,
	"experience_rate": 100
}
#-------------------------------------------------------------------------------
@export var skill_resource_array: Array[Item_Resource]
@export var equip_serializable_array: Array[Equip_Serializable]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
