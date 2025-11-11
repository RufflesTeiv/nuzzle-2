extends ScreenController


func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Computer": func():
			UiManager.start_dialogue("0_computer"),
		"Pipes": func():
			UiManager.start_dialogue("0_pipes"),
		"GuardRobot": func():
			UiManager.start_dialogue("0_guard_robot")
			await Dialogic.timeline_ended,
	}
	return dict

func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		1: func(_body):
			var pc := GameManager.player_controller
			pc.stop_movement()
			pc.min_speed /= 1.5
			pc.max_speed /= 1.5
			_set_monitoring_for_area(1,false)
			UiManager.start_dialogue("0_middle"),
		2: func(_body):
			var pc := GameManager.player_controller
			pc.min_speed /= 1.5
			pc.max_speed /= 1.5
			_set_monitoring_for_area(3,true),
		3: func(_body):
			_set_monitoring_for_area(3,false)
			var guard_robot := _get_interactable_by_name("GuardRobot")
			
	}
	return dict


func _screen_start():
	UiManager.start_dialogue("0_start")
	
func _screen_exit(): pass
