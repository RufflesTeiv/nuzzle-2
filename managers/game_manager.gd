extends Node

#region Enums
#endregion

#region Parameters (consts and exportvars)
#endregion

#region Signals
signal inventory_changed(inventory : Inventory)
#endregion

#region Variables
var player_inventory : Inventory
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	# Inventário
	player_inventory = Inventory.new()
	player_inventory.items_changed.connect(_on_inventory_changed)
	Console.create_command("add_item", player_inventory.add_item_by_id)
	Console.create_command("remove_item", player_inventory.remove_item_by_id)
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
#endregion

#region Private functions
func _on_inventory_changed():
	inventory_changed.emit(player_inventory)
#endregion

#region Subclasses
#endregion
