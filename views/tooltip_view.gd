extends PanelContainer
class_name TooltipView

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var label: RichTextLabel = %Label
@export var offset := Vector2(5.0,5.0)
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
	
func _input(event: InputEvent):
	if visible and event is InputEventMouseMotion:
		_update_mouse_position()

func _exit_tree(): pass
#endregion

#region Public functions
func hide_tooltip(text:String):
	hide()
	label.text = ""
	size = Vector2.ZERO
	
func show_tooltip(text:String):
	label.text = text
	_update_mouse_position()
	show()
#endregion

#region Private functions
func _update_mouse_position():
	global_position = get_global_mouse_position() + offset
#endregion

#region Subclasses
#endregion
