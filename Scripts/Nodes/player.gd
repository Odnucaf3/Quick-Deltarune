extends CharacterBody2D
class_name Party_Member
#-------------------------------------------------------------------------------
var hp: int
var max_hp: int = 30
var sp: int
var max_sp: int = 25
var is_in_guard: bool
#-------------------------------------------------------------------------------
var can_enter_fight: bool
#-------------------------------------------------------------------------------
@export var sprite: Sprite2D
@export var collider: CollisionShape2D
@export var animation_tree: AnimationTree
var playback : AnimationNodeStateMachinePlayback
#-------------------------------------------------------------------------------
@export var party_member_ui: Party_Member_UI
#-------------------------------------------------------------------------------
