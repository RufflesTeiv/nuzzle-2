extends Node2D
class_name MainSceneController

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var screen_holder: Node2D = %ScreenHolder
#endregion

#region Signals
#endregion

#region Variables
var current_screen : ScreenController
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	_load_screen(0,0,Global.Character.SLEEPY_NUZZLE)
	Console.create_command("goto",_load_screen_command)
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
#endregion

#region Private functions
func _clear_screen():
	if current_screen:
		current_screen.screen_changed.disconnect(_load_screen)
	Utility.destroy_all_children(screen_holder)
	
func _load_screen(id : int, entry_point := 0, character := Global.Character.NONE) -> bool:
	await UiManager.main_ui.fade_out()
	_clear_screen()
	if !ScreensData.is_loaded():
		ScreensData.load_resources()
	if ScreensData.screens.is_empty():
		print("No screens!")
		return false
	var screen := ScreensData.get_screen_by_id(id)
	if !screen:
		return false
	current_screen = screen.packed_scene.instantiate() as ScreenController
	screen_holder.call_deferred("add_child",current_screen)
	current_screen.enter(entry_point,character)
	current_screen.screen_changed.connect(_load_screen)
	if not current_screen.is_node_ready():
		await current_screen.ready
	UiManager.main_ui.reset()
	UiManager.main_ui.fade_in()
	return true
	
func _load_screen_command(id: int, entry_point: int, character_int: int) -> String:
	var success := await _load_screen(id,entry_point,character_int as Global.Character)
	return "Transporting to screen..." if success else "Error! Check print."
#endregion

#region Subclasses
#endregion
