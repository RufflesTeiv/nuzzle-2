extends Node

#region Enums
enum State {
	MAIN,
	CONSOLE
}
#endregion

#region Parameters (consts and exportvars)
#endregion

#region Signals
#endregion

#region Variables
var state_stack : Array[State] = [State.MAIN]
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
func check_top_state(c:State) -> bool:
	var top_state := get_top_state()
	return c == top_state

func get_top_state() -> State:
	return state_stack[state_stack.size()-1]
	
func push_state_to_stack(s : State):
	if state_stack.has(s):
		return
	state_stack.append(s)
	
func remove_state_from_stack(s : State):
	var idx := state_stack.find(s)
	if idx == -1:
		return
	state_stack.remove_at(idx)
#endregion

#region Private functions
#endregion

#region Subclasses
#endregion
