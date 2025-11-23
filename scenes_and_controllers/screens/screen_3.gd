extends ScreenController

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Glovebox": func():
			UiManager.start_dialogue("3_glovebox")
			UiManager.dialogue_signal.connect(_on_pistol_get),
		"Palluhae": func():
			UiManager.start_dialogue("3_palluhae_start")
			await UiManager.dialogue_ended
			_change_screen(5,0,Global.Character.NUZZLE),
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	return {}

func _screen_start(): 
	UiManager.start_dialogue("3_start")
	UiManager.dialogue_signal.connect(_on_start_dialogue_signal)
	
func _screen_exit(): pass
#endregion
  
#region Private functions
func _on_pistol_get(arg : String):
	UiManager.dialogue_signal.disconnect(_on_pistol_get)
	if arg != "pistol_get":
		return
	GameManager.player_inventory.add_item_by_id(3)
	
func _on_start_dialogue_signal(arg:String):
	match arg:
		"arrived":
			pass
			#parar o carro na animação
		"ended":
			UiManager.dialogue_ended.disconnect(_on_start_dialogue_signal)
			_change_screen(4,0,Global.Character.NUZZLE)	
#endregion
