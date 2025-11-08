class_name Inventory

#region Enums
#endregion

#region Variables
@export var items : Array[Item] = []
#endregion

#region Computed properties
#endregion

signal items_changed()

func _init(): pass

#region Public functions
func add_item(item : Item):
	if items.has(item):
		return
	items.append(item)
	_items_changed()
	
func add_item_by_id(id: int):
	var item := ItemsData.get_item_by_id(id)
	if item == null:
		return
	add_item(item)
	
func remove_item(item : Item):
	var idx = items.find(item)
	if idx == -1:
		return
	items.remove_at(idx)
	_items_changed()
	
func remove_item_by_id(id: int):
	var idx := items.find_custom(func(i): return id == i.id)
	if idx == -1:
		return
	items.remove_at(idx)
	_items_changed()
#endregion

#region Private functions
func _items_changed():
	items_changed.emit()
	items.sort_custom(func(a,b): return a.id < b.id)
	if items.is_empty():
		print("Inventory emptied.")
	else:
		var items_print := items.map(func(i): return "(%d: %s)" % [i.id, i.name])
		print("Current inventory: %s" % items_print)
#endregion

#region Subclasses
#endregion
