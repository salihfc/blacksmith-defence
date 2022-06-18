extends Control
"""
"""

### SIGNAL ###
## Sent when craft button clicked with a valid crafting config
signal unit_created(unit_recipe)


### ENUM ###
### CONST ###
### EXPORT ###
export(NodePath) var NP_WeaponList
export(NodePath) var NP_CraftingPanel
export(NodePath) var NP_MaterialList
export(NodePath) var NP_WeaponTextureRect
export(NodePath) var NP_MaterialSlots

export(Resource) var craftable_units
export(Resource) var owned_materials = MaterialStorage.new()

### PUBLIC VAR ###
### PRIVATE VAR ###
var _mat_slots = [null, null, null]
var _selected_unit = null

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

	reinit(owned_materials)

### PUBLIC FUNCTIONS ###
func reinit(mat_storage) -> void:
	owned_materials.copy_from(mat_storage)

	assert(craftable_units)
	display_weapons(craftable_units)
	assert(owned_materials)
	_init_material_list(owned_materials)

	#
	_selected_unit = null
	weaponTextureRect.texture = null
	#
	for idx in _mat_slots.size():
		_mat_slots[idx] = null
	_on_mats_in_slots_updated()

func display_weapons(_craftable_units : ItemPool):
	weaponList.clear()

#	add_item(text: String, icon: Texture = null, selectable: bool = true
	for unit in _craftable_units.get_items():
		var item = unit.weapon
		weaponList.add_item(item.name, item.texture)


func get_storage():
	return owned_materials

### PRIVATE FUNCTIONS ###
func _init_material_list(mat_storage : MaterialStorage) -> void:
	UTILS.clear_children(materialList)
	for mat in mat_storage.get_materials():
		var ct = mat_storage.get_material_count(mat)
		if ct > 0:
			materialList.add_material(mat, ct, _get_mat_effect(mat))


func _get_mat_effect(_mat) -> String:
	if _selected_unit:
		var hint = WEAPON_ENHANCE_DB.get_hint(UTILS.get_enum_string_from_id(Weapon.TYPE, _selected_unit.weapon.get_id()), _mat.name)
		if hint:
			return hint

	return "no effect"


func _is_craf_valid() -> bool:
	return _selected_unit != null


func _get_craft():
	return UnitRecipe.new(
		_selected_unit,
		MaterialStorage.new().add_from_array(_mat_slots)
	)

### SIGNAL RESPONSES ###
func _on_WeaponList_item_selected(index: int) -> void:
	weaponTextureRect.texture = weaponList.get_item_icon(index)
	_selected_unit = craftable_units.get_items()[index]
	_init_material_list(owned_materials)


func _on_material_selected_from_list(mat : MaterialData) -> void:
	assert(mat)
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "mat selected [%s]" % [MaterialData.TYPE.keys()[mat.type]])

	for idx in _mat_slots.size():
		if _mat_slots[idx] == null:
			# Update data
			_mat_slots[idx] = mat
			owned_materials.use_material(mat, 1)

			# Update ui
			_init_material_list(owned_materials)
			_on_mats_in_slots_updated()
			break


func _on_mats_in_slots_updated() -> void:
	var t = 0
	for mat in _mat_slots:
		if mat:
			materialSlots.get_child(t).texture = mat.sprite
		else:
			materialSlots.get_child(t).texture = null

		t += 1


func _on_CraftButton_pressed() -> void:
	if _is_craf_valid():
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "unit created [%s] [%s]" % [_selected_unit.name, _mat_slots])
		emit_signal("unit_created", _get_craft())
