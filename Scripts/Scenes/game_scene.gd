extends Node
class_name Game_Scene
#-------------------------------------------------------------------------------
@export var world_2d: World_2D
#-------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	world_2d.Debug_Information()
	world_2d.Show_fps()
	#-------------------------------------------------------------------------------
	world_2d.Set_FullScreen()
	world_2d.Set_Vsync()
	world_2d.Set_SlowMotion()
	world_2d.Set_MouseMode()
	world_2d.Set_ResetGame()
	world_2d.Set_DebugInfo()
#-------------------------------------------------------------------------------
