extends Node2D
class_name Animation_Effect
#-------------------------------------------------------------------------------
@export var animation_player: AnimationPlayer
var animation_effect_callable: Callable = func():pass
#-------------------------------------------------------------------------------
func Animation_Effect_Action():
	animation_effect_callable.call()
#-------------------------------------------------------------------------------
