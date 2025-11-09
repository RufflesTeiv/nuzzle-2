extends Node2D
class_name ScreenController

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var entry_points: Node2D = %EntryPoints
@onready var trigger_areas: Node2D = %TriggerAreas
#endregion

#region Signals
signal screen_changed(id:int,entry_point:int,character:GameManager.Character)
#endregion

#region Variables
var character_controller : PlayerController
#var trigger_areas_callables : Dictionary[int,Callable] = {} # (body) -> void
var trigger_areas_callables : Dictionary[int,Callable] = {
	0: func(_body):
		if not _body is PlayerController:
			return
		screen_changed.emit(-1,0,GameManager.Character.NONE)
}
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	_watch_trigger_areas()
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
func enter(entry_point : int, character := GameManager.Character.NONE):
	_instantiate_character(character)
	_position_at_entry_point(entry_point)
	_screen_setup()
#endregion

#region Private functions
func _get_entry_point(ep:int) -> Vector2:
	for child : Marker2D in entry_points.get_children():
		var id := int(child.name)
		if id == ep:
			return child.global_position
	return Vector2.ZERO
	
func _instantiate_character(c : GameManager.Character):
	if character_controller != null:
		character_controller.queue_free()
		character_controller = null
	if c != GameManager.Character.NONE:
		GameManager.set_current_character(c)
	var char_tscn := GameManager.get_current_character_scene()
	if char_tscn == null:
		return
	character_controller = char_tscn.instantiate() as PlayerController
	add_child(character_controller)
	
func _on_area_body_entered(id: int, body: Node2D):
	print("Body %s entered in area %s" % [body,id])
	if !trigger_areas_callables.has(id):
		return
	trigger_areas_callables[id].call(body)
	
func _position_at_entry_point(ep: int):
	if character_controller == null:
		return
	character_controller.force_position(_get_entry_point(ep))
	
func _screen_setup(): pass
	
func _watch_trigger_areas():
	for area : Area2D in trigger_areas.get_children():
		var id := int(area.name)
		area.body_entered.connect(func(body): _on_area_body_entered(id,body))
#endregion

#region Subclasses
#endregion
