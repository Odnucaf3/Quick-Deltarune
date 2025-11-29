extends CharacterBody2D
class_name Party_Member
#-------------------------------------------------------------------------------
@export var id: StringName
@export var texture2d: Texture2D
var hp: int
var max_hp: int = 30
var sp: int
var max_sp: int = 20
var is_in_guard: bool
#-------------------------------------------------------------------------------
@export var skill_array: Array[Item_Resource]
var skill_array_in_battle: Array[Item_Resource]
#-------------------------------------------------------------------------------
@export var status_array: Array[Status_Resource]
var status_array_in_battle: Array[Status_Resource]
#-------------------------------------------------------------------------------
var can_enter_fight: bool
var is_Facing_Left: bool = false
var is_Moving: bool = false
#-------------------------------------------------------------------------------
var user_party: Array[Party_Member]
var target: Party_Member
var target_party: Array[Party_Member]
#-------------------------------------------------------------------------------
var item_resource: Item_Resource
#-------------------------------------------------------------------------------
@export var pivot: Marker2D
@export var sprite: Sprite2D
@export var collider: CollisionShape2D
@export var animation_tree: AnimationTree
var playback : AnimationNodeStateMachinePlayback
#-------------------------------------------------------------------------------
var party_member_ui: Party_Member_UI
#-------------------------------------------------------------------------------
