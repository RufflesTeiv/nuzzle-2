extends InteractableController
class_name InteractableEntityController

@onready var nav2d: NavigationAgent2D = %NavigationAgent2D
@export var distance_to_persistent_target := 150.0
@export var min_speed := 300.0
@export var max_speed := 400.0

var movement_paused := false
var persistent_target : Node2D

signal target_reached()

#region Event
func _ready():
	super._ready()
	nav2d.target_position = global_position
	nav2d.target_reached.connect(target_reached.emit)

func _physics_process(delta):
	super._physics_process(delta)
	_check_persistent_target()
	_move_to_target(delta)
#endregion

#region Public methods
func force_position(pos:Vector2):
	position = pos
	set_target_position(pos)
	
func set_persistent_target(t: Node2D):
	persistent_target = t
	
func set_target_position(pos: Vector2):
	persistent_target = null
	nav2d.target_position = pos
#endregion

#region Private methods
func _check_persistent_target():
	if !persistent_target:
		return
	var vector := persistent_target.position - position
	var current_distance := vector.length()
	if current_distance > distance_to_persistent_target:
		var offset_direction := -vector.normalized()
		var new_position := persistent_target.position + offset_direction*distance_to_persistent_target
		nav2d.target_position = new_position

func _move_to_target(delta):
	if movement_paused:
		return
	if nav2d.is_navigation_finished():
		return
	var next_path_position := nav2d.get_next_path_position()
	var speed_modifier := nav2d.distance_to_target() / 1920.0
	var speed := clampf(max_speed*speed_modifier,min_speed,max_speed)
	var velocity = global_position.direction_to(next_path_position) * speed
	position += velocity*delta
#endregion
