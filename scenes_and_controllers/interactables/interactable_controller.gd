extends Node2D
class_name InteractableController

#region Enums
enum Type {
	TOUCH,
	WATCH
}
#endregion

#region Parameters (consts and exportvars)
@onready var canvas_group: CanvasGroup = %CanvasGroup
@onready var mouse_area: Area2D = %MouseArea
@onready var interaction_target_marker: Marker2D = %InteractionTarget

@export var type := Type.TOUCH
@export var display_name := ""
@export var enable_interaction := true
#endregion

#region Signals
signal interacted
#endregion

#region Variables
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	_watch_mouse_over_area()
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
func try_interaction():
	match type:
		Type.TOUCH:
			var pos := interaction_target_marker.global_position
			_on_mouse_exited()
			GameManager.player_controller.set_target_position(pos)
			GameManager.player_controller.target_reached.connect(_interact)
		Type.WATCH:
			_interact()
#endregion

#region Private functions
func _check_input_state() -> bool:
	return InputManager.check_top_state(InputManager.State.MAIN) and enable_interaction

func _on_input_event(_v: Node, event: InputEvent, _sidx: int):
	if not _check_input_state():
		return
	if not event is InputEventMouseButton:
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.pressed:
		try_interaction()
		
func _interact():
	interacted.emit()
	
func _on_mouse_entered():
	if not _check_input_state():
		return
	canvas_group.modulate = Color(1.353, 1.353, 1.353, 1.0)
	
func _on_mouse_exited():
	if not _check_input_state():
		return
	canvas_group.modulate = Color.WHITE
	
func _watch_mouse_over_area():
	mouse_area.mouse_entered.connect(_on_mouse_entered)
	mouse_area.mouse_exited.connect(_on_mouse_exited)
	mouse_area.input_event.connect(_on_input_event)
#endregion

#region Subclasses
#endregion
