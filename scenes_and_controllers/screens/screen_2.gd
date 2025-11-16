extends ScreenController

var ready_to_leave := false

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Guard": func(): UiManager.start_dialogue("2_guard"),
		"Palluhae": func():
			UiManager.start_dialogue("2_palluhae")
			UiManager.dialogue_signal.connect(_on_palluhae_dialogue_signal)
			UiManager.dialogue_ended.connect(_on_palluhae_dialogue_end),
		"Car": func(): UiManager.start_dialogue("2_car"),
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(1,1,Global.Character.NUZZLE),
		1: func(_body):
			UiManager.start_dialogue("2_leave")
			await UiManager.dialogue_ended
			var wp := _get_waypoint_by_name("ExitStop")
			if !wp:
				return
			GameManager.player_controller.set_target_position(wp.position)
	}
	return dict

func _screen_start():
	UiManager.start_unique_dialogue("2_enter")
	
func _screen_exit(): pass
#endregion

#region Private functions
func _on_palluhae_dialogue_end():
	UiManager.dialogue_ended.disconnect(_on_palluhae_dialogue_end)
	if ready_to_leave:
		_change_screen(3,0,Global.Character.NUZZLE)
	
func _on_palluhae_dialogue_signal(arg:String):
	UiManager.dialogue_ended.disconnect(_on_palluhae_dialogue_signal)
	if arg == "ready":
		ready_to_leave = true
#endregion
