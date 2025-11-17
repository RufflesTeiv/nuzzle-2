extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"BiometricsTerminal": func():
			if GameManager.player_inventory.has_item(7):
				_change_screen(11,0,Global.Character.NUZZLE),
		"BreakableWall": func(): _change_screen(10,0,Global.Character.NUZZLE),
		"MainDoor": func():
			if GameManager.player_inventory.has_item(10):
				_change_screen(14,0,Global.Character.NUZZLE),
		"CenterTable": func():
			if !GameManager.player_inventory.has_item(7):
				GameManager.player_inventory.add_item_by_id(7)
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(7,1,Global.Character.NUZZLE)
	}
	return dict

func _screen_start(): pass
	
func _screen_exit(): pass
#endregion

#region Private functions
#endregion
