extends Node

#region Enums
#endregion

#region Parameters (consts and exportvars)
#endregion

#region Signals
signal dialogue_ended()
signal dialogue_signal(arg: Variant)
signal dialogue_started()
signal dialogue_text_signal(arg: String)
#endregion

#region Variables
var dialogue_history : Array[String] = []
var main_ui : MainUiView
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	Console.create_command("dialogue", start_dialogue)
	_connect_to_dialogic_signals()
		
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
func set_main_ui_view(muv: MainUiView): main_ui = muv

func start_dialogue(timeline: String):
	if !Dialogic.timeline_exists(timeline):
		return
	InputManager.push_state_to_stack(InputManager.State.DIALOGUE)
	Dialogic.start(timeline)
	if !Dialogic.timeline_ended.is_connected(_on_dialogue_end):
		Dialogic.timeline_ended.connect(_on_dialogue_end)
		
func start_unique_dialogue(timeline:String):
	if dialogue_history.has(timeline):
		return
	dialogue_history.append(timeline)
	start_dialogue(timeline)
#endregion

#region Private functions
func _connect_to_dialogic_signals():
	Dialogic.timeline_ended.connect(dialogue_ended.emit)
	Dialogic.timeline_started.connect(dialogue_started.emit)
	Dialogic.signal_event.connect(dialogue_signal.emit)
	Dialogic.text_signal.connect(dialogue_text_signal.emit)
	
func _on_dialogue_end():
	InputManager.remove_state_from_stack(InputManager.State.DIALOGUE)
	Dialogic.timeline_ended.disconnect(_on_dialogue_end)
#endregion

#region Subclasses
#endregion
