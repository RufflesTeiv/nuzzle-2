class_name ScreensData

const SCREENS_FOLDER := "res://scenes_and_controllers/screens/"
static var screens : Array[ScreenResource] = []
			
static func get_screen_by_id(id: int) -> ScreenResource:
	if !is_loaded():
		load_resources()
	var idx := screens.find_custom(func(s): return s.id == id)
	if idx == -1:
		print("No screen with id %d" % id)
		return null
	return screens[idx]
	
static func is_loaded() -> bool:
	return !screens.is_empty()

static func load_resources():
	var scenes := load_scenes()
	screens = []
	for scene in scenes:
		if !scene:
			continue
		var screen := ScreenResource.new()
		var screen_id_string := scene.resource_name.trim_prefix("screen_")
		if !screen_id_string.is_valid_int():
			continue
		screen.id = int(screen_id_string)
		screen.packed_scene = scene
		screens.append(screen)
			
static func load_scenes() -> Array[PackedScene]:
	var packed_scenes : Array[PackedScene] = []
	var scene_paths := FileUtility.get_scene_paths(SCREENS_FOLDER)
	for path in scene_paths:
		var scene : PackedScene = load(path)
		if scene:
			scene.resource_name = FileUtility.get_file_name(SCREENS_FOLDER,path,false)
			packed_scenes.append(scene)
	return packed_scenes
