extends PanelContainer
class_name InventoryView

#region Enums
#endregion

#region Parameters (consts and exportvars)
const INVENTORY_ITEM_VIEW = preload("uid://bqv1qam6n8gvx")
@onready var grid_container: GridContainer = %GridContainer
#endregion

#region Signals
#endregion

#region Variables
var item_views: Array[InventoryItemView] = []
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	Utility.remove_all_children(grid_container)
	_create_item_views()
	GameManager.inventory_changed.connect(_update_graphics)
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
#endregion

#region Private functions
func _create_item_views():
	for i in 10:
		var item_view := INVENTORY_ITEM_VIEW.instantiate()
		grid_container.add_child(item_view)
		item_views.append(item_view)
		
func _update_graphics(inventory:Inventory):
	for i in item_views.size():
		var item_view := item_views[i]
		if i < inventory.items.size():
			item_view.set_item(inventory.items[i])
		else:
			item_view.set_item(null)
#endregion

#region Subclasses
#endregion
