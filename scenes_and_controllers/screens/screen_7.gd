extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"BodyPile": func(): UiManager.start_dialogue("07_bodies"),
		"BodyPile2": func(): UiManager.start_dialogue("07_bodies"),
		"QyvenCorpse": func(): UiManager.start_dialogue("07_qyven"),
		"Palluhae": func():
			_get_interactable_by_name("QyvenCorpse").try_interaction(),
		"Cyborg Kid": func(): UiManager.start_dialogue("07_kid"),
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(6,1,Global.Character.NUZZLE),
		1: func(_body): _change_screen(8,0,Global.Character.NUZZLE),
		2: func(_body):
			if GameManager.has_visited_screen(8):
				return
			UiManager.start_dialogue("07_middle")
			await UiManager.dialogue_ended
			var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeTargetFinal").position)
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String):
	match arg:
		"kid_approach": _kid_follow()

func _screen_start():
	if !GameManager.has_visited_screen(7):
		UiManager.start_dialogue("07_start")
	_kid_follow()
	_position_palluhae()
	
func _screen_exit(): pass
#endregion

#region Private functions
func _kid_follow():
	var kid := _get_interactable_by_name("Cyborg Kid") as InteractableEntityController
	if GameManager.has_visited_screen(8):
		kid.hide()
	if !UiManager.current_timeline.is_empty():
		await UiManager.dialogue_signal
	kid.set_persistent_target(GameManager.player_controller)
	
func _position_palluhae():
	var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
	var target_pos := _get_waypoint_by_name("PalluhaeTargetMiddle").position
	if GameManager.has_visited_screen(8):
		palluhae.hide()
	elif GameManager.has_visited_screen(7):
		palluhae.force_position(target_pos)
		palluhae.enable_interaction = true
	else:
		if !UiManager.current_timeline.is_empty():
			await UiManager.dialogue_ended
		palluhae.set_target_position(target_pos)
		await palluhae.target_reached
		palluhae.enable_interaction = true
#endregion
