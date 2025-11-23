extends CanvasLayer
class_name MainUiView

#region Enums
enum FadeOutLayer{
	BACKGROUND,
	FULL
}
#endregion

#region Parameters (consts and exportvars)
@onready var background_rect: ColorRect = %BackgroundRect
@onready var inventory: InventoryView = %Inventory
@onready var fade_out_rect: ColorRect = %FadeOutRect
@onready var dialogue_image: TextureRect = %DialogueImage
@onready var tooltip: TooltipView = %Tooltip

const DIALOGUE_IMAGES_FOLDER := "res://assets/dialogic/images/"
#endregion

#region Signals
#endregion

#region Variables
var can_open_inventory := true
var fade_out_tweens : Dictionary[FadeOutLayer,Tween] = {}
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	fade_out_rect.modulate.a = 1.0
	UiManager.set_main_ui_view(self)
	Dialogic.signal_event.connect(_check_image_signal)
	#UiManager.dialogue_signal.connect(_check_image_signal)
	InputManager.stack_changed.connect(_on_input_stack_changed)
	background_rect.gui_input.connect(_on_background_input)
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent):
	match InputManager.get_top_state():
		InputManager.State.MAIN:
			if _event.is_action_pressed("toggle_inventory"): _toggle_inventory()
		InputManager.State.INVENTORY:
			if _event.is_action_pressed("toggle_inventory"): _toggle_inventory()
			if _event.is_action_pressed("ui_cancel"): _close_inventory()

func _exit_tree(): pass
#endregion

#region Public functions
func close_dialogue_image():
	_tween_modulate_alpha(dialogue_image,0.0,0.5)

func fade_in(fo_layer := FadeOutLayer.FULL, time := 0.5):
	await _fade_layer(fo_layer,0.0,time)
	
func fade_out(fo_layer := FadeOutLayer.FULL, time := 0.5):
	await _fade_layer(fo_layer,1.0,time)
	
func reset():
	_close_inventory()
	
func open_dialogue_image(img_name : String):
	var texture = load(DIALOGUE_IMAGES_FOLDER+img_name+".png")
	dialogue_image.texture = texture
	_tween_modulate_alpha(dialogue_image,1.0,0.5)
	
func open_inventory():
	inventory.show()
	InputManager.push_state_to_stack(InputManager.State.INVENTORY)
	
func set_can_open_inventory(v: bool): can_open_inventory = v
#endregion

#region Private functions	
func _check_image_signal(arg:String):
	if arg == "close_image":
		close_dialogue_image()
	elif arg.contains("open_image:"):
		var img_name := arg.trim_prefix("open_image:")
		open_dialogue_image(img_name)
	
func _close_all():
	_close_inventory()
	
func _close_inventory():
	inventory.hide()
	InputManager.remove_state_from_stack(InputManager.State.INVENTORY)
	
func _fade_layer(fo_layer: FadeOutLayer, to: float, time: float):
	var rect := _get_layer_rect(fo_layer)
	if fade_out_tweens.has(fo_layer) and fade_out_tweens[fo_layer].is_running():
		#await fade_out_tweens[fo_layer].finished
		fade_out_tweens[fo_layer].kill()
	fade_out_tweens[fo_layer] = _tween_modulate_alpha(rect,to,time)
	await fade_out_tweens[fo_layer].finished
	
func _get_layer_rect(fo_layer:FadeOutLayer) -> ColorRect:
	match fo_layer:
		FadeOutLayer.BACKGROUND: return background_rect
		_: return fade_out_rect
	
func _on_background_input(event : InputEvent):
	if !event is InputEventMouseButton: return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
		_close_all()
	
func _on_input_stack_changed(stack: Array[InputManager.State]):
	var find := stack.find(InputManager.State.INVENTORY) + stack.find(InputManager.State.DIALOGUE)
	if find == -2:
		close_dialogue_image()
		background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		fade_in(FadeOutLayer.BACKGROUND,0.25)
	else:
		background_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		fade_out(FadeOutLayer.BACKGROUND,0.25)
		tooltip.hide_tooltip()
	
func _toggle_inventory():
	if inventory.visible: _close_inventory()
	elif can_open_inventory: open_inventory()
	
func _tween_modulate_alpha(ci : CanvasItem, to: float, time: float) -> Tween:
	if !ci.visible and to > 0.0:
		ci.show()
	var tween := get_tree().create_tween()
	tween.tween_property(ci,"modulate:a",to,time)
	if ci.visible and to <= 0.0:
		tween.tween_callback(func(): ci.hide())
	return tween
	
#endregion

#region Subclasses
#endregion
