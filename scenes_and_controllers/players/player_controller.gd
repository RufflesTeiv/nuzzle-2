extends CharacterBody2D
class_name PlayerController

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var nav2d: NavigationAgent2D = %NavigationAgent2D
@onready var debug_label: Label = %DebugLabel

@export var min_speed := 300.0
@export var max_speed := 800.0
@export var interaction_range := 15.0
#endregion

#region Signals
signal target_reached()
#endregion

#region Variables
var can_walk := true
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	nav2d.target_position = global_position
	nav2d.target_reached.connect(target_reached.emit)
	
func _process(_delta): pass
	
func _physics_process(_delta):
	_move_to_goal()
	_update_debug_label()
	
func _input(_event: InputEvent):
	if InputManager.check_top_state(InputManager.State.MAIN) and _event is InputEventMouseButton:
		var mouse_event := _event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed and can_walk:
			set_target_position(_get_local_mouse_pos(mouse_event.global_position))
			

func _exit_tree(): pass
#endregion

#region Public functions
func force_position(p:Vector2):
	velocity = Vector2.ZERO
	global_position = p
	set_target_position(p)
	
func set_target_position(pos:Vector2):
	_clear_target_listeners()
	nav2d.target_position = pos
	
func set_walkable(walkable : bool):
	can_walk = walkable
	
func stop_movement():
	set_target_position(global_position)
#endregion

#region Private functions
func _clear_target_listeners():
	Utility.clear_connections_from_signal(target_reached)
	
func _get_local_mouse_pos(global_pos : Vector2) -> Vector2:
	var camera := get_viewport().get_camera_2d()
	if !camera:
		return global_pos
	return global_pos / camera.zoom.x

func _move_to_goal():
	if nav2d.is_navigation_finished():
		return
	var next_path_position := nav2d.get_next_path_position()
	var speed_modifier := nav2d.distance_to_target() / 1920.0
	var speed := clampf(max_speed*speed_modifier,min_speed,max_speed)
	velocity = global_position.direction_to(next_path_position) * speed
	move_and_slide()
	
func _update_debug_label():
	if !debug_label.visible:
		return
	debug_label.text = "Done: %s\nHit target: %s\nReachable: %s" % [
		nav2d.is_navigation_finished(),
		nav2d.is_target_reached(),
		nav2d.is_target_reachable()
	]
#endregion

#region Subclasses
#endregion
