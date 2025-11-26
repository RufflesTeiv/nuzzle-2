extends ScreenController

@export var random_jumpscare_chance := 0.25
@onready var jumpscare: Sprite2D = %Jumpscare
var jumpscare_moved := false

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"BiometricsTerminal": func():
			UiManager.start_dialogue("08_terminal")
			if GameManager.player_inventory.has_item(7) and !GameManager.has_visited_screen(11):
				await UiManager.dialogue_ended
				GameManager.add_to_progress_dict("08_terminal_opened",true)
				_change_screen(11,0,Global.Character.NUZZLE)
			elif !GameManager.check_progress_dict("08_terminal_interacted"):
				await UiManager.dialogue_ended
				GameManager.add_to_progress_dict("08_terminal_interacted",true)
				GameManager.player_inventory.add_item_by_id(8),
		"BreakableWall": func():
			if GameManager.check_progress_dict("08_wall_broken"):
				_change_screen(10,0,Global.Character.NUZZLE)
			else:
				UiManager.start_dialogue("08_breakable")
				await UiManager.dialogue_ended
				GameManager.add_to_progress_dict("08_wall_broken",true),
		"MainDoor": func():
			if GameManager.player_inventory.has_item(10) and !GameManager.check_progress_dict("08_door_open"):
				UiManager.start_dialogue("08_palluhae_wait")
				await UiManager.dialogue_ended
				GameManager.add_to_progress_dict("08_door_open",true)
				var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
				GameManager.player_controller.set_walkable(false)
				_position_kid()
				palluhae.set_target_position(_get_waypoint_by_name("PalluhaeEnd").position)
				await palluhae.target_reached
				UiManager.start_dialogue("08_palluhae_go")
				await UiManager.dialogue_ended
				_change_screen(14,0,Global.Character.PALLUHAE)
			elif GameManager.check_progress_dict("08_door_open"):
				_change_screen(14,0,Global.Character.PALLUHAE)
			else:
				UiManager.start_dialogue("08_main_door"),
		"CenterTable":func():
			UiManager.start_dialogue("08_table")
			await UiManager.dialogue_ended
			if !GameManager.has_visited_screen(9):
				_change_screen(9,0,Global.Character.NUZZLE),
		"Palluhae": func(): UiManager.start_dialogue("08_palluhae"),
		"Cyborg Kid": func(): UiManager.start_dialogue("08_cyborg_kid"),
		"CommunicationsRoomDoor": func():
			if GameManager.check_progress_dict("08_terminal_opened"):
				_change_screen(11,0,Global.Character.NUZZLE)
			else:
				UiManager.start_dialogue("08_comms_door")
				await UiManager.dialogue_ended
				GameManager.add_to_progress_dict("08_comms_door_seen",true)
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): _change_screen(7,1,Global.Character.NUZZLE),
		1: func(_body):
			var kid := _get_interactable_by_name("Cyborg Kid") as InteractableEntityController
			kid.set_target_position(_get_waypoint_by_name("KidMain").position)
			await kid.target_reached
			kid.enable_interaction = true,
		2: func(_body): _move_jumpscare()
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String):
	var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
	match arg:
		"move_to_break":
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeBreak").position)
		"nuzzle_move_away":
			var player := GameManager.player_controller
			player.set_target_position(_get_waypoint_by_name("NuzzleMoveAway").position)
		"return":
			if GameManager.check_progress_dict("08_door_open"):
				palluhae.set_target_position(_get_waypoint_by_name("PalluhaeEnd").position)
			else:
				palluhae.set_target_position(_get_waypoint_by_name("PalluhaeMain").position)
			
func _screen_start():
	if(!GameManager.has_visited_screen(8) and entered_through != 4):
		UiManager.start_dialogue("08_start")
	elif entered_through == 4:
		UiManager.start_dialogue("08_return_from_memory")
	_position_kid()
	_position_palluhae()
	_chance_jumpscare()
	_check_broken_wall()
	_check_door_open()
	
func _screen_exit(): pass
#endregion

#region Private functions
func _chance_jumpscare():
	if GameManager.check_progress_dict("08_jumpscare") or entered_through in [3,4]:
		return
	if randf() <= random_jumpscare_chance:
		jumpscare.show()
		
func _check_broken_wall():
	if GameManager.check_progress_dict("08_wall_broken"):
		# Do something
		pass
		
func _check_door_open():
	if GameManager.check_progress_dict("08_door_open"):
		# Do something
		pass
		
func _move_jumpscare():
	if !jumpscare.visible or jumpscare_moved:
		return
	var tween := create_tween()
	var jumpscare_target = _get_waypoint_by_name("JumpscareEnd")
	tween.tween_property(jumpscare,"position",jumpscare_target.position,0.6)
	jumpscare_moved = true
	GameManager.add_to_progress_dict("08_jumpscare",true)

func _position_kid():
	var kid := _get_interactable_by_name("Cyborg Kid") as InteractableEntityController
	var target := _get_waypoint_by_name("KidMain")
	if GameManager.check_progress_dict("08_door_open"):
		kid.force_position(target.position)
		kid.set_persistent_target(GameManager.player_controller)
	elif GameManager.has_visited_screen(8):
		kid.force_position(target.position)
		kid.enable_interaction = true
	else:
		kid.set_persistent_target(GameManager.player_controller)

func _position_palluhae(): 
	var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
	var target := _get_waypoint_by_name("PalluhaeMain")
	if GameManager.has_visited_screen(8):
		palluhae.force_position(target.position)
		palluhae.enable_interaction = true
	else:
		palluhae.set_target_position(target.position)
		await palluhae.target_reached
		palluhae.enable_interaction = true
#endregion
