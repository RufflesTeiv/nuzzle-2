extends PanelContainer
class_name InventoryItemView

#region Enums
#endregion

#region Parameters (consts and exportvars)
@onready var debug_label: Label = %DebugLabel
@onready var texture_rect: TextureRect = %TextureRect
#endregion

#region Signals
#endregion

#region Variables
var item : Item
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	_update_graphics()
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
func set_item(i: Item):
	item = i
	_update_graphics()
#endregion

#region Private functions
func _update_graphics():
	if !texture_rect or !debug_label:
		await ready
	if item == null:
		debug_label.hide()
		texture_rect.hide()
		return
	texture_rect.texture = item.texture_2d
	texture_rect.show()
	debug_label.text = item.name
	debug_label.show()
#endregion

#region Subclasses
#endregion
