extends Resource
class_name Party_Member_Resource
#-------------------------------------------------------------------------------
@export var body_sprite: Texture2D
@export var face_sprite: Texture2D
#-------------------------------------------------------------------------------
@export_category("Base Stats")
@export var max_hp: int = 100
@export var max_sp: int = 20
@export var physical_attack: int = 10
@export var physical_defense: int = 10
@export var magical_attack: int = 10
@export var magical_defense: int = 10
@export var luck: int = 10
#-------------------------------------------------------------------------------
