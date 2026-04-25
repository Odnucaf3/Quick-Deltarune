extends Node2D
class_name Party_Member_Node
#-------------------------------------------------------------------------------
@export var party_member_serializable: Party_Member_Serializable
var party_member_serializable_in_battle: Party_Member_Serializable
#-------------------------------------------------------------------------------
var damage_label_array: Array[PopUp_UI]
#-------------------------------------------------------------------------------
var is_Facing_Left: bool = false
var is_Moving: bool = false
#-------------------------------------------------------------------------------
# This is used for skills to infor who are ally and who are enemies
var user_party: Array[Party_Member_Node]
var target: Party_Member_Node
var target_party: Array[Party_Member_Node]
#-------------------------------------------------------------------------------
var item_serializable: Item_Serializable
#-------------------------------------------------------------------------------
@export var pivot: Marker2D
@export var sprite: Sprite2D
#-------------------------------------------------------------------------------
@export var animation_tree: AnimationTree
#-------------------------------------------------------------------------------
var party_member_ui: Party_Member_UI
#-------------------------------------------------------------------------------
var disappears_when_dies: bool = true
#-------------------------------------------------------------------------------
