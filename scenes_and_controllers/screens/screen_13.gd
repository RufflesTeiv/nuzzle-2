extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Chair": func():
			UiManager.start_dialogue("13_chair")
			await UiManager.dialogue_ended
			_change_screen(11,1,Global.Character.NUZZLE)
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): print("This is the Area 0 callable!")
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String): pass

func _screen_start():
	UiManager.main_ui.set_can_open_inventory(false)
	UiManager.start_dialogue("13_start")
	
func _screen_exit():
	UiManager.main_ui.set_can_open_inventory(true)
	await UiManager.main_ui.fade_out()
	UiManager.start_dialogue("13_exit")
	await UiManager.dialogue_ended
#endregion

#region Private functions
#endregion
