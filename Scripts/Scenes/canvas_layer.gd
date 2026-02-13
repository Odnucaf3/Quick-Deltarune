extends CanvasLayer
#-------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	singleton.game_scene.Debug_Information()
	#-------------------------------------------------------------------------------
	singleton.game_scene.Set_SlowMotion()
	singleton.game_scene.Set_DebugInfo()
#-------------------------------------------------------------------------------
