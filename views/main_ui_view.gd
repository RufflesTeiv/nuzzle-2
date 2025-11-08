extends CanvasLayer
class_name MainUiView

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var inventory: InventoryView = %Inventory
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
	
func _ready():
	UiManager.set_main_ui_view(self)
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent):
	if not InputManager.check_top_state(InputManager.State.MAIN):
		return
	if _event.is_action_pressed("toggle_inventory"): _toggle_inventory()
	if _event.is_action_pressed("ui_cancel"): _close_inventory()

func _exit_tree(): pass
#endregion

#region Public functions
#endregion

#region Private functions
func _close_inventory(): inventory.hide()
func _toggle_inventory(): inventory.visible = !inventory.visible
#endregion

#region Subclasses
#endregion
