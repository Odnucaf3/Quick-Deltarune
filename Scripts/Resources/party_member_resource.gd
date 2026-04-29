extends Resource
class_name Party_Member_Resource
#-------------------------------------------------------------------------------
@export var body_sprite: Texture2D
@export var face_sprite: Texture2D
#-------------------------------------------------------------------------------
@export_group("Base Stats")
@export var max_hp: int = 20
@export var max_sp: int = 10
@export var physical_attack: int = 10
@export var physical_defense: int = 10
@export var magical_attack: int = 10
@export var magical_defense: int = 10
@export var agility: int = 10
@export var luck: int = 10
@export_group("")
#-------------------------------------------------------------------------------
@export_group("Extra Stats")
@export var physical_presition: int = 100
@export var physical_evasion: int = 0
@export var magical_presition: int = 100
@export var magical_evasion: int = 0
@export var hp_regeneration: int = 0
@export var sp_regeneration: int = 0
@export var tp_regeneration: int = 0
@export_group("")
#-------------------------------------------------------------------------------
@export_group("Special Stats")
@export var target_rate: int = 100
@export var guard_effect_rate: int = 50
@export var recovery_effect_rate: int = 100
@export var pharmacology: int = 100
@export var hp_cost_rate: int = 100
@export var sp_cost_rate: int = 100
@export var tp_cost_rate: int = 100
@export var physical_damage_rate: int = 100
@export var magical_damage_rate: int = 100
@export var gold_rate: int = 100
@export var experience_rate: int = 100
@export_group("")
#-------------------------------------------------------------------------------
@export var skill_resource_array: Array[Item_Resource]
#-------------------------------------------------------------------------------
@export var equip_type_array: Array[Equip_Resource.EQUIP_TYPE] = [
	Equip_Resource.EQUIP_TYPE.WEAPON,
	Equip_Resource.EQUIP_TYPE.HEAD,
	Equip_Resource.EQUIP_TYPE.BODY,
	Equip_Resource.EQUIP_TYPE.RING,
	Equip_Resource.EQUIP_TYPE.RING,
	Equip_Resource.EQUIP_TYPE.RING
]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
