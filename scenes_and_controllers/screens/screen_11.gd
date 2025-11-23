extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Mainframe": func():
			UiManager.start_dialogue("11_mainframe")
			if GameManager.player_inventory.has_item(9) and !GameManager.has_visited_screen(12):
				await UiManager.dialogue_ended
				_change_screen(12,0,Global.Character.NUZZLE),
		"Locker": func():
			UiManager.start_dialogue("11_locker"),
			#var inventory := GameManager.player_inventory
			#if inventory.has_item(6) and !inventory.has_item(10):
				#inventory.add_item_by_id(10),
		"WrappedFormidae": func():
			UiManager.start_dialogue("11_formidae")
			await UiManager.dialogue_ended
			var inventory := GameManager.player_inventory
			if !inventory.has_item(10):
				inventory.add_item_by_id(10),
		"Palluhae": func():
			UiManager.start_dialogue("11_palluhae")
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(8,1,Global.Character.NUZZLE),
		1: func(_body):
			if !GameManager.check_progress_dict("11_palluhae_leave") or GameManager.check_progress_dict("11_formidae_dropped"):
				return
			GameManager.player_controller.stop_movement()
			GameManager.add_to_progress_dict("11_formidae_dropped",true)
			_show_formidae()
			UiManager.start_dialogue("11_formidae_dropped")
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String):
	var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
	match arg:
		"palluhae_leave":
			GameManager.add_to_progress_dict("11_palluhae_leave",true)
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeLeave").position)
			await palluhae.target_reached
			_check_palluhae()
		"palluhae_check":
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeCheck").position)
			

func _screen_start():
	if !GameManager.has_visited_screen(11):
		UiManager.start_dialogue("11_start")
	elif entered_through == 1:
		UiManager.start_dialogue("11_start_from_memory")
	_check_palluhae()
	_show_formidae()
	
func _screen_exit(): pass
#endregion

#region Private functions
func _check_palluhae():
	if GameManager.check_progress_dict("11_palluhae_leave"):
		_get_interactable_by_name("Palluhae").hide()
	elif entered_through == 1:
		var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
		palluhae.force_position(_get_waypoint_by_name("PalluhaeCheck").position)
	
func _show_formidae():
	if !GameManager.check_progress_dict("11_formidae_dropped"):
		return
	var formidae := _get_interactable_by_name("WrappedFormidae")
	formidae.show()
#endregion
