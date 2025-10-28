extends CharacterBody2D
class_name Party_Member
#-------------------------------------------------------------------------------
var hp: int
var max_hp: int = 30
var sp: int
var max_sp: int = 100
var is_in_guard: bool
#-------------------------------------------------------------------------------
@export var skill_array: Array[Item_Resource]
var skill_array_in_battle: Array[Item_Resource]
#-------------------------------------------------------------------------------
var can_enter_fight: bool
#-------------------------------------------------------------------------------
var user_party: Array[Party_Member]
var target: Party_Member
var target_party: Array[Party_Member]
#-------------------------------------------------------------------------------
var item_resource: Item_Resource
#-------------------------------------------------------------------------------
@export var sprite: Sprite2D
@export var collider: CollisionShape2D
@export var animation_tree: AnimationTree
var playback : AnimationNodeStateMachinePlayback
#-------------------------------------------------------------------------------
@export var party_member_ui: Party_Member_UI
#-------------------------------------------------------------------------------
