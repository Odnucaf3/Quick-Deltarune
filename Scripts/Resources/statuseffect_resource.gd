extends Resource
class_name StatusEffect_Resource
#-------------------------------------------------------------------------------
@export var max_hold: int = 10
@export var is_infinite: bool = false
#-------------------------------------------------------------------------------
@export_group("Base Stats")
@export var max_hp: int = 0
@export var max_sp: int = 0
@export var physical_attack: int = 0
@export var physical_defense: int = 0
@export var magical_attack: int = 0
@export var magical_defense: int = 0
@export var agility: int = 0
@export var luck: int = 0
@export_group("")
#-------------------------------------------------------------------------------
@export_group("Extra Stats")
@export var physical_presition: int = 0
@export var physical_evasion: int = 0
@export var magical_presition: int = 0
@export var magical_evasion: int = 0
@export var hp_regeneration: int = 0
@export var sp_regeneration: int = 0
@export var tp_regeneration: int = 0
@export_group("")
#-------------------------------------------------------------------------------
@export_group("Special Stats")
@export var target_rate: int = 0
@export var guard_effect_rate: int = 0
@export var recovery_effect_rate: int = 0
@export var pharmacology: int = 0
@export var hp_cost_rate: int = 0
@export var sp_cost_rate: int = 0
@export var tp_cost_rate: int = 0
@export var physical_damage_rate: int = 0
@export var magical_damage_rate: int = 0
@export var gold_rate: int = 0
@export var experience_rate: int = 0
@export_group("")
#-------------------------------------------------------------------------------
@export var skill_resource_array: Array[Item_Resource]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
