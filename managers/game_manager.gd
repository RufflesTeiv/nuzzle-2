extends Node

#region Enums
enum Character {
	NUZZLE,
	NONE
}
#endregion

#region Parameters (consts and exportvars)
#endregion

#region Signals
signal inventory_changed(inventory : Inventory)
#endregion

#region Variables
var current_character := Character.NUZZLE
var character_scenes : Dictionary[Character,PackedScene] = {
	Character.NUZZLE: preload("uid://cnkpty7qpcbtv")
}
var player_controller : PlayerController
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
func get_current_character_scene() -> PackedScene:
	return character_scenes[current_character]
	
func set_current_character(c:Character):
	if c == null:
		return
	current_character = c
	
func set_player_controller(pc: PlayerController): player_controller = pc
#endregion

#region Private functions
func _on_inventory_changed():
	inventory_changed.emit(player_inventory)
#endregion

#region Subclasses
#endregion
