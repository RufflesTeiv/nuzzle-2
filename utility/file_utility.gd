class_name FileUtility

static func get_file_name(dir_path:String, file_path:String, with_extension := true):
	var file_name := file_path.trim_prefix(dir_path).trim_prefix("/")
	if with_extension:
		return file_name
	var parts := file_name.split(".")
	return parts[0]

static func get_file_paths_with_extension(dirPath : String, extension: String):
	var dir = _get_dir_access(dirPath)
	if !dir: return []
	var file_paths : Array[String] = []
	var file_name = dir.get_next()
	while(file_name != ""):
		if dir.current_is_dir():
			continue
		if extension in file_name:
			file_name = file_name.trim_suffix('.remap')
			file_paths.append(dirPath+"/"+file_name)
		file_name = dir.get_next()
	return file_paths

static func get_resource_paths(dirPath : String) -> Array[String]:
	return get_file_paths_with_extension(dirPath, '.tres')
	
static func get_scene_paths(dirPath : String) -> Array[String]:
	return get_file_paths_with_extension(dirPath, '.tscn')

static func _get_dir_access(dirPath:String) -> DirAccess:
	var dir = DirAccess.open(dirPath)
	if !dir:
		return null
	dir.list_dir_begin()
	return dir
