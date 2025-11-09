extends CanvasLayer
class_name MainMenuController

#region Enums
enum Page {
	MAIN,
	CREDITS
}
#endregion

#region Parameters (consts and exportvars)
@export var first_scene : PackedScene
@onready var main_page: Control = %Main
@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton

@export var credits : Array[Credit] = []
@onready var credits_page: Control = %Credits
@onready var references: RichTextLabel = %References
@onready var back_button: Button = %BackButton
#endregion

#region Signals
#endregion

#region Variables
var pages : Array[Control] = []
var current_page := Page.MAIN:
	set(value):
		current_page = value
		_update_page()
#endregion

#region Computed properties
#endregion

#region Event functions
func _init(): pass
	
func _enter_tree(): pass
	
func _ready():
	pages = [main_page, credits_page]
	start_button.pressed.connect(_start)
	credits_button.pressed.connect(func(): set_page(Page.CREDITS))
	back_button.pressed.connect(func(): set_page(Page.MAIN))
	references.meta_clicked.connect(_link_clicked)
	_set_references_text()
	
func _process(_delta): pass
	
func _physics_process(_delta): pass
	
func _input(_event: InputEvent): pass

func _exit_tree(): pass
#endregion

#region Public functions
func set_page(p: Page):
	current_page = p
#endregion

#region Private functions
func _hide_all_pages():
	for page in pages:
		page.hide()
		
func _link_clicked(meta : Variant):
	OS.shell_open(str(meta))
	
func _update_page():
	_hide_all_pages()
	match current_page:
		Page.MAIN: main_page.show()
		Page.CREDITS: credits_page.show()
		
func _set_references_text():
	var result := ""
	for i in credits.size():
		if i > 0:
			result += "[br]"
		var credit := credits[i]
		var authors := ""
		for j in credit.authors.size():
			if j > 0:
				authors += ", "
			authors += credit.authors[j]
		var credit_str := "• [i][b][url=%s]%s[/url][/b][/i], por [b]%s[/b]" % [credit.url, credit.name, authors]
		result += credit_str
	references.text = result
	
		
func _start():
	get_tree().change_scene_to_packed(first_scene)
#endregion

#region Subclasses
#endregion
