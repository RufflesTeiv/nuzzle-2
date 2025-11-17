extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Door": func(): _change_screen(7,0,Global.Character.NUZZLE)
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(4,1,Global.Character.NUZZLE)
	}
	return dict

func _screen_start(): pass
	
func _screen_exit(): pass
#endregion

#region Private functions
#endregion
