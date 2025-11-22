extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"DeadFormidae": func():
			UiManager.start_dialogue("10_formidae")
			await UiManager.dialogue_ended
			if !GameManager.player_inventory.has_item(9):
				GameManager.player_inventory.add_item_by_id(9)
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(8,2,Global.Character.NUZZLE)
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String): pass

func _screen_start():
	UiManager.start_dialogue("10_start")
	
func _screen_exit(): pass
#endregion

#region Private functions
#endregion
