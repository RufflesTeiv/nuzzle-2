extends ScreenController

var robot_tween : Tween

func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Computer": func():
			UiManager.start_dialogue("0_computer"),
		"Pipes": func():
			UiManager.start_dialogue("0_pipes"),
		"GuardRobot": func():
			UiManager.start_dialogue("0_guard_robot")
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
			GameManager.player_controller.stop_movement()
			_move_robot()
	}
	return dict


func _screen_start():
	UiManager.start_dialogue("0_start")
	
func _screen_exit():
	if robot_tween:
		robot_tween.kill()

#region Private functions
func _move_robot():	
	var guard_robot := _get_interactable_by_name("GuardRobot")
	robot_tween = get_tree().create_tween()
	robot_tween.tween_property(
		guard_robot,
		"position",
		Vector2(0.0, guard_robot.global_position.y),
		6.0
	)
	var end_scene_tween := get_tree().create_tween()
	end_scene_tween.tween_interval(1.0)
	end_scene_tween.tween_callback(func():
		UiManager.main_ui.fade_out(MainUiView.FadeOutLayer.FULL,0)
	)
	end_scene_tween.tween_interval(3.0)
	end_scene_tween.tween_callback(func():
		UiManager.main_ui.fade_out(MainUiView.FadeOutLayer.FULL,0)
		_change_screen(0,0,GameManager.Character.SLEEPY_NUZZLE)
	)
#endregion
