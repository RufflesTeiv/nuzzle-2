extends Node2D
class_name ScreenController

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var entry_points: Node2D = %EntryPoints
@onready var interactables : Node2D = %Interactables
@onready var objects: Node2D = %Objects
@onready var trigger_areas: Node2D = %TriggerAreas
#endregion

#region Signals
signal screen_changed(id:int,entry_point:int,character:GameManager.Character)
#endregion

#region Variables
var character_controller : PlayerController
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
func enter(entry_point : int, character := GameManager.Character.NONE):
	_instantiate_character(character)
	_position_character_at_entry_point(entry_point)
	_screen_start()
	#await get_tree().create_timer(1.0).timeout
	await get_tree().process_frame
	_watch_interactables()
	_watch_trigger_areas()
#endregion

#region Overridables
func _get_interactables_callables() -> Dictionary[String,Callable]:
	var dict : Dictionary[String,Callable] = {
		"Interactable": func(): print("This is an interactable!")
	}
	return dict
	
func _get_trigger_areas_callables() -> Dictionary[int,Callable]:
	var dict : Dictionary[int,Callable] = {
		0: func(_body): print("This is the Area 0 callable!")
	}
	return dict
	
func _screen_exit(): pass

func _screen_start(): pass
#endregion

#region Private functions	
func _change_screen(id:int,entry_point:int,character:GameManager.Character):
	await _screen_exit()
	screen_changed.emit(id,entry_point,character)
	
func _get_area_by_id(id:int) -> Area2D:
	for area in trigger_areas.get_children():
		if int(area.name) == id:
			return area as Area2D
	return null
	
func _get_entry_point(ep:int) -> Vector2:
	for child : Marker2D in entry_points.get_children():
		var id := int(child.name)
		if id == ep:
			return child.global_position
	return Vector2.ZERO
	
func _get_interactable_by_name(n:String) -> Node2D:
	for child : Node2D in interactables.get_children():
		if child.name == n:
			return child
	return null
	
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
	GameManager.set_player_controller(character_controller)
	objects.add_child(character_controller)
	
func _on_area_body_entered(id: int, body: Node2D):
	print("Body %s entered in area %s" % [body,id])
	if not body is PlayerController:
		return
	var callables = _get_trigger_areas_callables()
	if !callables.has(id):
		return
	callables[id].call(body)
	
func _on_interactable_interacted(i_name: String):
	var callables = _get_interactables_callables()
	if !callables.has(i_name):
		return
	callables[i_name].call()
	
func _position_character_at_entry_point(ep: int):
	if character_controller == null:
		return
	character_controller.force_position(_get_entry_point(ep))

func _set_monitoring_for_all_areas(m:bool):
	for area : Area2D in trigger_areas.get_children():
		area.monitoring = m
		
func _set_monitoring_for_area(id:int, m:bool):
	var area := _get_area_by_id(id)
	if !area: return
	area.set_deferred("monitoring", m)
	
func _watch_interactables():
	for interactable : InteractableController in interactables.get_children():
		var i_name := interactable.name
		interactable.interacted.connect(func(): _on_interactable_interacted(i_name))
	
func _watch_trigger_areas():
	for area : Area2D in trigger_areas.get_children():
		var id := int(area.name)
		area.body_entered.connect(func(body): _on_area_body_entered(id,body))
#endregion

#region Subclasses
#endregion
