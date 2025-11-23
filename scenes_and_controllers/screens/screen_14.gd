extends ScreenController

@onready var end: CanvasLayer = %End
@onready var fade_out_rect: ColorRect = %FadeOutRect
var main_menu := preload("uid://cbru62y3j5v1r")
@onready var spider: Sprite2D = %Spider

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"GraffitiedCoordinates": func(): 
			UiManager.start_dialogue("14_graffiti")
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body):
			UiManager.start_dialogue("14_go_back")
			await UiManager.dialogue_ended
			_change_screen(8,3,Global.Character.NUZZLE),
		1: func(_body):
			GameManager.player_controller.stop_movement()
			UiManager.start_dialogue("14_end")
			await UiManager.dialogue_ended
			_spider_attack(),
		2: func(_body):
			if GameManager.check_progress_dict("14_cant_go_back"):
				return
			UiManager.start_dialogue("14_sound")
			GameManager.player_controller.max_speed /= 2
			GameManager.player_controller.min_speed /= 2
			GameManager.add_to_progress_dict("14_cant_go_back",true),
		3: func(_body):
			if !GameManager.check_progress_dict("14_cant_go_back"):
				return
			GameManager.player_controller.stop_movement()
			UiManager.start_dialogue("14_cant_go_back")
			await UiManager.dialogue_ended
			GameManager.player_controller.set_target_position(_get_waypoint_by_name("EndAdvance").position)
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String):
	match arg:
		"nuzzle_inspect":
			var nuzzle := _get_interactable_by_name("Nuzzle") as InteractableEntityController
			nuzzle.set_target_position(_get_waypoint_by_name("NuzzleInspect").position)

func _screen_start():
	if !GameManager.has_visited_screen(14):
		UiManager.start_dialogue("14_start")
	_kid_follow()
	
func _screen_exit(): pass
#endregion

#region Private functions
func _end():
	end.show()
	await get_tree().create_timer(5.0).timeout
	var tween := create_tween()
	tween.tween_property(fade_out_rect,"modulate",Color.WHITE,5.0)
	tween.tween_callback(func(): get_tree().change_scene_to_packed(main_menu))
	
func _kid_follow():
	var kid := _get_interactable_by_name("Cyborg Kid") as InteractableEntityController
	kid.set_persistent_target(_get_interactable_by_name("Nuzzle"))
	
func _spider_attack():
	var tween := create_tween()
	var target_pos := _get_waypoint_by_name("SpiderGoal").position
	tween.tween_property(spider,"position",target_pos,0.5)
	tween.tween_callback(_end)
#endregion
