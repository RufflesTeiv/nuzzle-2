extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Mainframe": func(): _change_screen(12,0,Global.Character.NUZZLE),
		"Locker": func():
			var inventory := GameManager.player_inventory
			if inventory.has_item(6) and !inventory.has_item(10):
				inventory.add_item_by_id(10)
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(8,1,Global.Character.NUZZLE)
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String): pass

func _screen_start(): pass
	
func _screen_exit(): pass
#endregion

#region Private functions
#endregion
