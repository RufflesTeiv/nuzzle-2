extends CanvasLayer
class_name MainUiView

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var background_rect: ColorRect = %BackgroundRect
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
	fade_out_rect.color = Color.BLACK
	UiManager.set_main_ui_view(self)
	InputManager.stack_changed.connect(_on_input_stack_changed)
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent):
	match InputManager.get_top_state():
		InputManager.State.MAIN, InputManager.State.INVENTORY:
			if _event.is_action_pressed("toggle_inventory"): _toggle_inventory()
		InputManager.State.INVENTORY:
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
func _on_input_stack_changed(stack: Array[InputManager.State]):
	var find := stack.find(InputManager.State.INVENTORY) + stack.find(InputManager.State.DIALOGUE)
	if find == -2:
		background_rect.hide()
	else:
		background_rect.show()
	
func _close_inventory():
	inventory.hide()
	InputManager.remove_state_from_stack(InputManager.State.INVENTORY)
	
func _open_inventory():
	inventory.show()
	InputManager.push_state_to_stack(InputManager.State.INVENTORY)
	
func _toggle_inventory():
	if inventory.visible: _close_inventory()
	else: _open_inventory()
#endregion

#region Subclasses
#endregion
