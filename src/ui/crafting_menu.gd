extends Control
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(NodePath) var NP_WeaponList
export(NodePath) var NP_CraftingPanel
export(NodePath) var NP_MaterialList
export(NodePath) var NP_WeaponTextureRect

export(Resource) var weapons

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var weaponList = get_node(NP_WeaponList) as ItemList
onready var weaponTextureRect = get_node(NP_WeaponTextureRect) as TextureRect

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(weapons)
	display_weapons(weapons)

### PUBLIC FUNCTIONS ###
func display_weapons(weapon_pool : ItemPool):
	weaponList.clear()

#	add_item(text: String, icon: Texture = null, selectable: bool = true
	for item in weapon_pool.get_items():
		weaponList.add_item(item.name, item.texture)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###


func _on_WeaponList_item_selected(index: int) -> void:
	weaponTextureRect.texture = weaponList.get_item_icon(index)


func _on_MaterialList_item_selected(index: int) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "material selected [%s]" % [index])
