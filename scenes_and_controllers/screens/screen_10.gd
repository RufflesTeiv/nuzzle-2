extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Interactable": func(): print("This is an interactable!")
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(8,2,Global.Character.NUZZLE)
	}
	return dict

func _screen_start(): pass
	
func _screen_exit(): pass
#endregion

#region Private functions
#endregion
