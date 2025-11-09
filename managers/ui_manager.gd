extends Node

#region Enums
#endregion

#region Parameters (consts and exportvars)
#endregion

#region Signals
#endregion

#region Variables
var main_ui : MainUiView
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready(): pass
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
func set_main_ui_view(muv: MainUiView): main_ui = muv

func start_dialogue(timeline: String):
	InputManager.push_state_to_stack(InputManager.State.DIALOGUE)
	Dialogic.start(timeline)
	Dialogic.timeline_ended.connect(_on_dialogue_end)
#endregion

#region Private functions
func _on_dialogue_end():
	InputManager.remove_state_from_stack(InputManager.State.DIALOGUE)
	Dialogic.timeline_ended.disconnect(_on_dialogue_end)
#endregion

#region Subclasses
#endregion
