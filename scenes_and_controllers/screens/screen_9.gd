extends ScreenController

var old_inventory : Inventory
@onready var red_overlay: Sprite2D = %RedOverlay
@onready var robot: Sprite2D = %Robot
@export var robot_end_position : Vector2
@export var robot_end_scale : Vector2

#region Overrides
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		#"Computer": func(): _change_screen(8,4,Global.Character.NUZZLE),
		"Computer": func():
			UiManager.start_dialogue("09_computer")
			await UiManager.dialogue_ended
			_change_screen(8,4,Global.Character.NUZZLE),
		"Pipes": func():
			UiManager.start_dialogue("09_pipes"),
		"Palluhae": func():
			UiManager.start_dialogue("09_palluhae")
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body):
			var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeTarget").position)
	}
	return dict
	
func _on_dialogue_signal(timeline:String,arg:String):
	match arg:
		"alarm":
			red_overlay.show()
		"robot_approached":
			robot.show()
		"palluhae_attack":
			var palluhae := _get_interactable_by_name("Palluhae") as InteractableEntityController
			palluhae.set_target_position(_get_waypoint_by_name("PalluhaeEnd").position)
		"robot_destroyed":
			robot.position = robot_end_position
			robot.scale = robot_end_scale

func _screen_start():
	_change_inventory()
	UiManager.start_dialogue("09_start")
	
func _screen_exit():
	GameManager.set_player_inventory(old_inventory)
#endregion

#region Private functions
func _change_inventory():
	old_inventory = GameManager.player_inventory
	var new_inventory := Inventory.new()
	new_inventory.add_item_by_id(0)
	new_inventory.add_item_by_id(1)
	new_inventory.add_item_by_id(5)
	GameManager.set_player_inventory(new_inventory)
#endregion
