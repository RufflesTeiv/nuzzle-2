extends ScreenController

var old_inventory : Inventory

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Bed": func(): UiManager.start_dialogue("12_bed"),
		"Window": func(): UiManager.start_dialogue("12_window"),
		"Closet": func(): UiManager.start_dialogue("12_closet"),
		"Computer": func(): 
			UiManager.start_dialogue("12_computer")
			await UiManager.dialogue_ended
			_change_screen(13,0,Global.Character.FORMIDAE_LEADER)
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): print("This is the Area 0 callable!")
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String): pass

func _screen_start(): 
	_change_inventory()
	UiManager.start_dialogue("12_start")
	
func _screen_exit():
	GameManager.set_player_inventory(old_inventory)
	await UiManager.main_ui.fade_out()
	UiManager.start_dialogue("12_exit")
	await UiManager.dialogue_ended
#endregion

#region Private functions
func _change_inventory():
	old_inventory = GameManager.player_inventory
	var new_inventory := Inventory.new()
	new_inventory.add_item_by_id(0)
	new_inventory.add_item_by_id(1)
	GameManager.set_player_inventory(new_inventory)
#endregion
