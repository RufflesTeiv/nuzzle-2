extends ScreenController

var palluhae_talked := false
var random_plant_number : int

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Car": func():
			UiManager.start_dialogue("04_car")
			Utility.connect_to_signal_safe(UiManager.dialogue_signal,_wait_glovebox_signal),
		"Palluhae": func():
			UiManager.start_dialogue("04_palluhae_interact")
			await UiManager.dialogue_ended
			UiManager.start_dialogue("04_palluhae")
			palluhae_talked = true
			Utility.connect_to_signal_safe(UiManager.dialogue_signal, _palluhae_dialogue_actions),
		"Cyborg Kid": func():
			UiManager.start_dialogue("04_cyborg_kid"),
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		2: func(_body):
			if palluhae_talked:
				_change_screen(6,0,Global.Character.NUZZLE)
			else:
				UiManager.start_dialogue("04_palluhae_wait")
				await UiManager.dialogue_ended
				var player := GameManager.player_controller
				player.set_target_position(_get_waypoint_by_name("NuzzleWait").position)
				player.set_walkable(false)
				await player.target_reached
				UiManager.start_dialogue("04_palluhae")
				palluhae_talked = true
				player.set_walkable(true)
				Utility.connect_to_signal_safe(UiManager.dialogue_signal, _palluhae_dialogue_actions)
	}
	return dict
	
func _on_interactable_interacted(i_name: String):
	if _is_plant(i_name):
		_check_plant_interactable(i_name)
	var callables = _get_interactables_callables()
	if !callables.has(i_name):
		return
	callables[i_name].call()

func _screen_start():
	_randomize_plant()
	UiManager.start_dialogue("04_start")
	#GameManager.player_controller.set_target_position(_get_waypoint_by_name("PalluhaeTarget2").position)
	
func _screen_exit(): pass
#endregion

#region Private functions
func _check_plant_interactable(i_name: String):
	var is_random_plant := int(i_name.trim_prefix("Plant")) == random_plant_number
	var player_has_item := GameManager.player_inventory.has_item(6)
	if is_random_plant and !player_has_item:
		UiManager.start_dialogue("04_right_plant")
		GameManager.player_inventory.add_item_by_id(6)
	else:
		UiManager.start_dialogue("04_wrong_plant")
		pass
		
func _is_plant(n:String) -> bool:
	return n.contains("Plant")
	
func _palluhae_dialogue_actions(arg:String):
	match arg:
		"throw_down":
			var kid := _get_interactable_by_name("Cyborg Kid")
			kid.show()
		"palluhae_move":
			var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeTarget1").position)
			await palluhae.target_reached
			await get_tree().create_timer(0.5).timeout
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeTarget2").position)
		"end":
			var kid := _get_interactable_by_name("Cyborg Kid") as InteractableEntityController
			kid.set_persistent_target(GameManager.player_controller)
			

func _randomize_plant():
	var interacts := _get_interactables()
	var plants := interacts.filter(func(i:InteractableController): return i.name.contains("Plant"))
	random_plant_number = range(plants.size()).pick_random()+1
	
func _wait_glovebox_signal(arg:String):
	if arg == "glovebox":
		UiManager.dialogue_signal.disconnect(_wait_glovebox_signal)
		UiManager.start_dialogue("3_glovebox")
	
#endregion
