extends ScreenController

func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Bed": func(): UiManager.start_dialogue("1_bed"),
		"Window": func(): UiManager.start_dialogue("1_window"),
		"Computer": func():
			UiManager.start_dialogue("1_computer")
			await UiManager.dialogue_ended
			var inventory := GameManager.player_inventory
			if !inventory.has_item(1):
				inventory.add_item_by_id(1),
		"Closet": func():
			UiManager.start_dialogue("1_closet")
			await UiManager.dialogue_ended
			var inventory := GameManager.player_inventory
			if !inventory.has_item(0):
				inventory.add_item_by_id(0),
		"Table": func():
			UiManager.start_dialogue("1_table")
			await UiManager.dialogue_ended
			var inventory := GameManager.player_inventory
			if !inventory.has_item(2):
				inventory.add_item_by_id(2),
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body):
			_try_leave_room(),
	}
	return dict

func _screen_start(): 
	UiManager.start_unique_dialogue("1_start")
	
func _screen_exit(): pass



# Private tãnãnã
func _try_leave_room():
	if GameManager.player_inventory.has_item(0):
		_change_screen(2,0,Global.Character.NUZZLE)
	else:
		UiManager.start_dialogue("1_naked")
		await UiManager.dialogue_ended
		var wp := _get_waypoint_by_name("ExitFail")
		if !wp:
			return
		GameManager.player_controller.set_target_position(wp.position)
