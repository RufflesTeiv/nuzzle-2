extends Node

#region Enums
#endregion

#region Parameters (consts and exportvars)
#endregion

#region Signals
signal inventory_changed(inventory : Inventory)
#endregion

#region Variables
var current_character := Global.Character.NUZZLE
var character_scenes : Dictionary[Global.Character,PackedScene] = {
	Global.Character.SLEEPY_NUZZLE: preload("uid://dyeu5sqgu0e26"),
	Global.Character.NUZZLE: preload("uid://cnkpty7qpcbtv")
}
var player_controller : PlayerController
var player_inventory : Inventory
var screen_id_history : Array[int] = []
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	set_player_inventory(Inventory.new())
	Console.create_command("add_item", _add_item_command)
	Console.create_command("remove_item", _remove_item_command)
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
func add_to_screen_history(id:int):
	screen_id_history.append(id)
	
func get_current_character_scene() -> PackedScene:
	return character_scenes[current_character]
	
func has_visited_screen(id:int):
	return screen_id_history.has(id)
	
func set_current_character(c:Global.Character):
	if c == null:
		return
	current_character = c
	
func set_player_controller(pc: PlayerController): player_controller = pc

func set_player_inventory(i: Inventory):
	if player_inventory:
		player_inventory.items_changed.disconnect(_on_inventory_changed)
	player_inventory = i
	player_inventory.items_changed.connect(_on_inventory_changed)
	inventory_changed.emit(player_inventory)
#endregion

#region Private functions
func _add_item_command(id:int):
	player_inventory.add_item_by_id(id)
	
func _on_inventory_changed():
	UiManager.main_ui.open_inventory()
	inventory_changed.emit(player_inventory)

func _remove_item_command(id:int):
	player_inventory.remove_item_by_id(id)
#endregion

#region Subclasses
#endregion
