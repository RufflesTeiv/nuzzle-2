extends CanvasLayer
class_name ConsoleUiController

#region Enums
#endregion

#region Parameters (consts and exportvars)
#endregion

#region Signals
#endregion

#region Variables
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready(): pass
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent):
	match InputManager.get_top_state():
		InputManager.State.MAIN:
			if _event.is_action_pressed("open_console") and !visible:
				_open_console()
		InputManager.State.CONSOLE:
			if _event.is_action_pressed("ui_cancel") or _event.is_action_pressed("open_console"):
				_close_console()

func _exit_tree(): _close_console()
#endregion

#region Public functions
#endregion

#region Private functions
func _close_console():
	hide()
	await get_tree().process_frame
	InputManager.remove_state_from_stack(InputManager.State.CONSOLE)

func _open_console():
	show()
	InputManager.push_state_to_stack(InputManager.State.CONSOLE)
#endregion

#region Subclasses
#endregion
