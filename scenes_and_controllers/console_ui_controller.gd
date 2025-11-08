extends CanvasLayer
class_name ConsoleUiController

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var main_container: MarginContainer = $MainContainer
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
	if _event.is_action_pressed("open_console"):
		if main_container.visible: _close_console()
		else: _open_console()
	elif _event.is_action_pressed("ui_cancel"):
		_close_console()

func _exit_tree(): _close_console()
#endregion

#region Public functions
#endregion

#region Private functions
func _close_console(): main_container.hide()

func _open_console(): main_container.show()
#endregion

#region Subclasses
#endregion
