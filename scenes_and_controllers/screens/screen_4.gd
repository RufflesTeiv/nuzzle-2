extends ScreenController

var random_plant_number : int

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Interactable": func(): print("This is an interactable!")
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		2: func(_body): _change_screen(6,0,Global.Character.NUZZLE)
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
	
func _screen_exit(): pass
#endregion

#region Private functions
func _check_plant_interactable(i_name: String):
	var is_random_plant := int(i_name.trim_prefix("Plant")) == random_plant_number
	var player_has_item := GameManager.player_inventory.has_item(6)
	if is_random_plant and !player_has_item:
		#Diálogo
		GameManager.player_inventory.add_item_by_id(6)
	else:
		#Diálogo
		pass
		
func _is_plant(n:String) -> bool:
	return n.contains("Plant")

func _randomize_plant():
	var interacts := _get_interactables()
	print(interacts.size())
	var plants := interacts.filter(func(i:InteractableController): return i.name.contains("Plant"))
	print(plants.size())
	random_plant_number = range(plants.size()).pick_random()+1
#endregion
