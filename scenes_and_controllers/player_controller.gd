extends CharacterBody2D
class_name PlayerController

#region Enums
#endregion

#region Parameters (consts and exportvars)
@export var check_distance_to_goal := 10.0
@export var max_speed := 800.0
#endregion

#region Signals
#endregion

#region Variables
var position_goal : Vector2
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	position_goal = position
	
func _process(_delta): pass
	
func _physics_process(_delta):
	_move_to_goal()
	
func _input(_event: InputEvent):
	if InputManager.check_top_state(InputManager.State.MAIN) and _event is InputEventMouseButton:
		var mouse_event := _event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_set_position_goal(mouse_event.global_position)
			

func _exit_tree(): pass
#endregion

#region Public functions
#endregion

#region Private functions
func _move_to_goal():
	var vector := position_goal - position
	var distance_to_goal := vector.length()
	print(distance_to_goal)
	if distance_to_goal <= check_distance_to_goal:
		return
	var direction := vector.normalized()
	var speed = clampf(distance_to_goal*1.5,max_speed/2,max_speed)
	velocity = direction * speed
	move_and_slide()
	
func _set_position_goal(p : Vector2): position_goal = p
#endregion

#region Subclasses
#endregion
