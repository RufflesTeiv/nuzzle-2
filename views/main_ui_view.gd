extends CanvasLayer
class_name MainUiView

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var inventory: InventoryView = %Inventory
@onready var fade_out_rect: ColorRect = %FadeOutRect
#endregion

#region Signals
#endregion

#region Variables
#endregion

#region Computed properties
func is_faded_out() -> bool:
	return fade_out_rect.color == Color.BLACK
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
func fade_in(time := 0.5):
	if !is_faded_out():
		return
	fade_out_rect.color = Color.BLACK
	var tween := get_tree().create_tween()
	tween.tween_property(fade_out_rect,"color",Color(0.0, 0.0, 0.0, 0.0),time)
	await tween.finished
	
func fade_out(time := 0.5):
	if is_faded_out():
		return
	fade_out_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	var tween := get_tree().create_tween()
	tween.tween_property(fade_out_rect,"color",Color.BLACK,time)
	await tween.finished
	
func reset():
	_close_inventory()
#endregion

#region Private functions
func _close_inventory(): inventory.hide()
func _toggle_inventory(): inventory.visible = !inventory.visible
#endregion

#region Subclasses
#endregion
