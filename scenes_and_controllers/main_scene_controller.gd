extends Node2D
class_name MainSceneController

#region Enums
#endregion

#region Parameters (consts and exportvars)
@export var screens : Array[ScreenResource] = []
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
	_load_screen(-1,0,GameManager.Character.NUZZLE)
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
	Utility.destroy_all_children(screen_holder)
	
func _load_screen(id : int, entry_point := 0, character := GameManager.Character.NONE):
	await UiManager.main_ui.fade_out()
	_clear_screen()
	if screens.is_empty():
		return
	var idx := screens.find_custom(func(sr): return sr.id == id)
	if idx == -1:
		return
	current_screen = screens[idx].packed_scene.instantiate() as ScreenController
	screen_holder.add_child(current_screen)
	current_screen.enter(entry_point,character)
	current_screen.screen_changed.connect(_load_screen)
	if not current_screen.is_node_ready():
		await current_screen.ready
	UiManager.main_ui.reset()
	UiManager.main_ui.fade_in()
	
func _load_screen_command(id: int, entry_point: int, character_int: int):
	_load_screen(id,entry_point,character_int)
#endregion

#region Subclasses
#endregion
