extends Control

"""

"""

### SIGNAL ###
signal item_ready(item)

### ENUM ###
enum TABS {
	ITEM_SELECTION,
	FORGE,
}

### CONST ###
const ItemButtonPrefab = preload("res://src/game/item_button.tscn")

### EXPORT ###
export(Resource) var item_pool = null

### PUBLIC VAR ###


### PRIVATE VAR ###
var _last_clicked_item = null

### ONREADY VAR ###
onready var tabContainer = $TabContainer as TabContainer
onready var forge = $TabContainer/Forge
onready var itemList = $TabContainer/ItemSelectionTab/MarginContainer/HBoxContainer/ItemList as VBoxContainer


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		forge, "forge_completed",
		self, "_on_item_forged"
	)
	
	for item in item_pool.items:
		var item_button = ItemButtonPrefab.instance()
		item_button.init(item)
		itemList.add_child(item_button)

		UTILS.bind(
			item_button, "pressed",
			self, "_on_item_selected",
			[item]
		)


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###

func _on_SelectButton_pressed():
	assert(_last_clicked_item)
	forge.set_item(_last_clicked_item)
	tabContainer.current_tab = TABS.FORGE


func _on_item_selected(item) -> void:
	_last_clicked_item = item


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_item_forged(item, progress_amount) -> void:
	emit_signal("item_ready", item)
