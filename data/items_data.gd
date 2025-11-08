class_name ItemsData

const ITEMS_FOLDER := "res://data/items/"
static var items : Array[Item] = []

static func load_resources():
	items = []
	var resource_paths := FileUtility.get_resource_paths(ITEMS_FOLDER)
	for path in resource_paths:
		var resource : Item = load(path)
		if resource:
			items.append(resource)
			
static func get_item_by_id(id: int) -> Item:
	var idx := items.find_custom(func(i): return i.id == id)
	if idx == -1:
		print("No item with id %d" % id)
		return null
	return items[idx]
