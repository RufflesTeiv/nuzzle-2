class_name Utility

#region Enums
static func enum_find_key_string(key:int, keys:Array) -> String:
	var strings := Utility.enum_keys_to_names(keys)
	if key < 0 or key >= strings.size():
		return "ERROR"
	return strings[key]
	
static func enum_find_string_in_keys(s:String, keys:Array) -> int:
	var strings := Utility.enum_keys_to_names(keys)
	var treated_string = _treat_enum_string(s)
	if !strings.has(treated_string):
		return -1
	return strings.find(treated_string)

static func enum_keys_to_names(keys : Array) -> Array[String]:
	var strings : Array[String] = []
	for key : String in keys:
		strings.append(_treat_enum_string(key))
	return strings
	
static func _treat_enum_string(s : String) -> String:
	return s.replace("-"," ").capitalize().replace("And","and")
#endregion

#region Math
static var rng : RandomNumberGenerator

static func create_rng(new_seed := 0):
	rng = RandomNumberGenerator.new()
	if new_seed == 0:
		rng.randomize()
	else:
		rng.seed = new_seed

static func normal_distribution(mean : float, deviation : float) -> float:
	if !rng:
		create_rng()
	return rng.randfn(mean, deviation)
	
static func remap_range(value:float, old_min: float, old_max: float, new_min : float, new_max: float) -> float:
	return lerp(new_min,new_max,unlerp(value,old_min,old_max))
	
static func unlerp(value:float, minv:float, maxv:float) -> float:
	return (value-minv)/(maxv-minv)
	
static func xy_to_xz(vector2d: Vector2) -> Vector3:
	return Vector3(vector2d.x,0.0,vector2d.y)
#endregion

#region Node hierarchy
static func destroy_all_children(parent:Node):
	for child in parent.get_children():
		child.queue_free()
		
static func for_each_child_do(parent: Node, action: Callable): # Node -> void
	for child in parent.get_children():
		action.call(child)
		
static func remove_all_children(parent:Node):
	for child in parent.get_children():
		parent.remove_child(child)
#endregion

#region Signals
static func clear_connections_from_signal(sig : Signal):
	for connection in sig.get_connections():
		sig.disconnect(connection.callable)
		
static func connect_to_signal_safe(sig: Signal, cal: Callable):
	if !sig.is_connected(cal):
		sig.connect(cal)

static func disconnect_from_signal_safe(sig : Signal, cal : Callable):
	if sig.is_connected(cal):
		sig.disconnect(cal)
#endregion

#region Strings
static func to_screaming_snake(s : String) -> String:
	return s.to_snake_case().to_upper()
#endregion
