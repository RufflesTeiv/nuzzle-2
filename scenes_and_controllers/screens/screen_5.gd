extends ScreenController

var old_inventory : Inventory
var palluhae_in_position := false

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Drone": func():
			UiManager.start_dialogue("05_drone")
			await UiManager.dialogue_ended
			_get_interactable_by_name("Drone").queue_free()
			GameManager.player_inventory.add_item_by_id(5),
		"Terminal": func():
			if GameManager.player_inventory.has_item(5):
				UiManager.start_dialogue("05_terminal_good")
				await UiManager.dialogue_ended
				_change_screen(3,0,Global.Character.NUZZLE)
			else:
				UiManager.start_dialogue("05_terminal_bad"),
		"Door": func():
			UiManager.start_dialogue("05_door")
			await UiManager.dialogue_ended
			if GameManager.check_progress_dict("05_door_talked"):
				GameManager.add_to_progress_dict("05_door_talked",true),
		"Palluhae": func():
			if palluhae_in_position:
				UiManager.start_dialogue("05_palluhae_end")
			else:
				UiManager.start_dialogue("05_palluhae_start"),
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body):
			var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeTarget").position)
			await palluhae.target_reached
			palluhae_in_position = true
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String):
	match arg:
		pass

func _screen_start():
	UiManager.start_dialogue("05_start")
	old_inventory = GameManager.player_inventory
	var new_inventory := Inventory.new()
	new_inventory.add_item_by_id(0)
	new_inventory.add_item_by_id(1)
	GameManager.set_player_inventory(new_inventory)
	
func _screen_exit():
	GameManager.set_player_inventory(old_inventory)
#endregion

#region Private functions
#endregion
