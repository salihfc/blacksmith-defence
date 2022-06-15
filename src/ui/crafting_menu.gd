extends Control
"""
"""

### SIGNAL ###
## Sent when craft button clicked with a valid crafting config
signal unit_created(unit_data)


### ENUM ###
### CONST ###
### EXPORT ###
export(NodePath) var NP_WeaponList
export(NodePath) var NP_CraftingPanel
export(NodePath) var NP_MaterialList
export(NodePath) var NP_WeaponTextureRect
export(NodePath) var NP_MaterialSlots

export(Resource) var weapons
export(Resource) var test_mat_storage

### PUBLIC VAR ###
### PRIVATE VAR ###
var _mat_slots = [null, null, null]
var _selected_weapon = null

### ONREADY VAR ###
onready var weaponList = get_node(NP_WeaponList) as ItemList
onready var weaponTextureRect = get_node(NP_WeaponTextureRect) as TextureRect
onready var materialList = get_node(NP_MaterialList) as VBoxContainer
onready var materialSlots = get_node(NP_MaterialSlots) as VBoxContainer

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	SIGNAL.bind(
		materialList, "material_selected_from_list",
		self, "_on_material_selected_from_list"
	)

	assert(weapons)
	display_weapons(weapons)
	assert(test_mat_storage)
	_init_material_list(test_mat_storage)

### PUBLIC FUNCTIONS ###
func display_weapons(weapon_pool : ItemPool):
	weaponList.clear()

#	add_item(text: String, icon: Texture = null, selectable: bool = true
	for item in weapon_pool.get_items():
		weaponList.add_item(item.name, item.texture)

### PRIVATE FUNCTIONS ###
func _init_material_list(mat_storage : MaterialStorage) -> void:
	UTILS.clear_children(materialList)
	var mat_dict = mat_storage.get_materials()
	for mat in mat_dict:
		var ct = mat_dict.get(mat, 0)
		if ct > 0:
			materialList.add_material(mat, ct, _get_mat_effect(mat))


func _get_mat_effect(_mat) -> String:
	if _selected_weapon == null:
		return "no effect"
	return WEAPON_ENHANCE_DB.get_hint(_selected_weapon.get_id(), _mat.type)


func _is_craf_valid() -> bool:
	return true


func _get_craft():
	return null

### SIGNAL RESPONSES ###
func _on_WeaponList_item_selected(index: int) -> void:
	weaponTextureRect.texture = weaponList.get_item_icon(index)
	_selected_weapon = weapons.get_items()[index]
	_init_material_list(test_mat_storage)


func _on_material_selected_from_list(mat : MaterialData) -> void:
	assert(mat)
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "mat selected [%s]" % [MaterialData.TYPE.keys()[mat.type]])

	for idx in _mat_slots.size():
		if _mat_slots[idx] == null:
			# Update data
			_mat_slots[idx] = mat
			test_mat_storage.use_material(mat, 1)

			# Update ui
			_init_material_list(test_mat_storage)
			_on_mats_in_slots_updated()
			break


func _on_mats_in_slots_updated() -> void:
	var t = 0
	for mat in _mat_slots:
		if mat:
			materialSlots.get_child(t).texture = mat.sprite

		t += 1


func _on_CraftButton_pressed() -> void:
	if _is_craf_valid():
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "unit created [%s] [%s]" % [_selected_weapon.name, _mat_slots])
		emit_signal("unit_created", _get_craft())
