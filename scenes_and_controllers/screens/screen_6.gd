extends ScreenController

var door_opened := false
var middle_reached := false

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Terminal": func():
			UiManager.start_dialogue("06_terminal"),
		"Door": func():
			UiManager.start_dialogue("06_door"),
		"Skeleton": func():
			if GameManager.check_progress_dict("08_terminal_interacted") and GameManager.player_inventory.has_item(8):
				UiManager.start_dialogue("06_skeleton_extract")
			elif GameManager.check_progress_dict("08_terminal_interacted"):
				UiManager.start_dialogue("06_skeleton_extract_fail")
			else:
				UiManager.start_dialogue("06_skeleton"),
		"Palluhae": func():
			if !door_opened:
				UiManager.start_dialogue("06_palluhae")
				await UiManager.dialogue_ended
				_get_interactable_by_name("Skeleton").try_interaction(),
		"Cyborg Kid": func():
			UiManager.start_dialogue("06_kid"),
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(4,1,Global.Character.NUZZLE),
		1: func(_body): _change_screen(7,0,Global.Character.NUZZLE),
		2: func(_body):
			if middle_reached:
				return
			GameManager.player_controller.stop_movement()
			UiManager.start_dialogue("06_middle")
			middle_reached = true
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String):
	match arg:
		"door_open": _remove_door()

func _screen_start():
	_check_remove_door()
	_kid_follow()
	_move_palluhae()
	_starting_dialogue()
	
func _screen_exit():
	GameManager.player_controller.stop_movement()
	if !GameManager.has_visited_screen(7) and going_to_screen == 7:
		UiManager.start_dialogue("06_end")
		await UiManager.dialogue_ended
#endregion

#region Private functions
func _check_remove_door():
	if GameManager.has_visited_screen(7):
		_remove_door()
	
func _kid_follow():
	var kid := _get_interactable_by_name("Cyborg Kid") as InteractableEntityController
	if GameManager.has_visited_screen(8):
		kid.hide()
	if entered_through == 1:
		kid.force_position(_get_waypoint_by_name("KidSpawn1").position)
	kid.set_persistent_target(GameManager.player_controller)
	
func _move_palluhae():
	var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
	var target_pos := _get_waypoint_by_name("PalluhaeTarget").position
	if GameManager.has_visited_screen(7):
		palluhae.hide()
	elif GameManager.has_visited_screen(6):
		palluhae.force_position(target_pos)
		palluhae.enable_interaction = true
	else:
		await UiManager.dialogue_ended
		palluhae.set_target_position(target_pos)
		await palluhae.target_reached
		palluhae.enable_interaction = true
		
func _remove_door():
	_get_navigation_collision_by_name("DoorCollision").disabled = true
	await _bake_navigation_region()
	_get_area_by_id(1).monitoring = true
	_get_interactable_by_name("Door").hide()
	var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
	if palluhae.visible:
		palluhae.set_target_position(_get_waypoint_by_name("PalluhaeTarget2").position)
	door_opened = true
	
func _starting_dialogue():
	if !GameManager.has_visited_screen(6):
		UiManager.start_dialogue("06_start")
#endregion
