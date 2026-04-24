extends Node2D
class_name Party_Member
#-------------------------------------------------------------------------------
@export var party_member_serializable: Party_Member_Serializable
#-------------------------------------------------------------------------------
var damage_label_array: Array[PopUp_UI]
#-------------------------------------------------------------------------------
var is_Facing_Left: bool = false
var is_Moving: bool = false
#-------------------------------------------------------------------------------
# This is used for skills to infor who are ally and who are enemies
var user_party: Array[Party_Member]
var target: Party_Member
var target_party: Array[Party_Member]
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
func Constructor() -> Party_Member:
	var _party_member: Party_Member = Party_Member.new()
	#-------------------------------------------------------------------------------
	_party_member.party_member_serializable = party_member_serializable.Constructor()
	#-------------------------------------------------------------------------------
	_party_member.is_Facing_Left = is_Facing_Left
	_party_member.is_Moving = is_Moving
	#-------------------------------------------------------------------------------
	_party_member.pivot = pivot
	_party_member.sprite = sprite
	_party_member.animation_tree = animation_tree
	_party_member.party_member_ui = party_member_ui
	#-------------------------------------------------------------------------------
	_party_member.disappears_when_dies = disappears_when_dies
	#-------------------------------------------------------------------------------
	return _party_member
#-------------------------------------------------------------------------------
