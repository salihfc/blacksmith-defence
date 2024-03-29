extends Control
"""
"""

### SIGNAL ###
## Sent when craft button clicked with a valid crafting config
signal unit_created(unit_recipe)
signal crafting_cancelled()

### ENUM ###
### CONST ###
### EXPORT ###
export(NodePath) var NP_WeaponList
export(NodePath) var NP_CraftingPanel
export(NodePath) var NP_MaterialList
export(NodePath) var NP_WeaponTextureRect
export(NodePath) var NP_MaterialSlots

export(NodePath) var NP_CraftButton
export(NodePath) var NP_CancelButton

export(Resource) var craftable_units
export(Resource) var owned_materials

### PUBLIC VAR ###
### PRIVATE VAR ###
var _mat_slots = [null, null, null]
var _selected_unit = null

### ONREADY VAR ###
onready var weaponList = get_node(NP_WeaponList) as ItemList
onready var weaponTextureRect = get_node(NP_WeaponTextureRect) as TextureRect
onready var materialList = get_node(NP_MaterialList) as VBoxContainer
onready var materialSlots = get_node(NP_MaterialSlots) as VBoxContainer

onready var craftButton = get_node(NP_CraftButton) as Button
onready var cancelButton = get_node(NP_CancelButton) as Button

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	craftButton.add_to_group("ui_button")
	cancelButton.add_to_group("ui_button")

	SIGNAL.bind(
		materialList, "material_selected_from_list",
		self, "_on_material_selected_from_list"
	)

	for idx in materialSlots.get_child_count():
		var mat_slot = materialSlots.get_child(idx)
		SIGNAL.bind(
			mat_slot, "pressed",
			self, "_on_mat_slot_pressed",
			[idx]
		)

	reinit(owned_materials)

### PUBLIC FUNCTIONS ###
func reinit(mat_storage) -> void:
	if owned_materials == null:
		owned_materials = MaterialCost.new()

	owned_materials.copy_from(mat_storage)

	assert(craftable_units)
	_display_craftable_weapons(craftable_units)
	assert(owned_materials)
	_init_material_list(owned_materials)

	#
	_selected_unit = null
	weaponTextureRect.texture = null
	#
	for idx in _mat_slots.size():
		_mat_slots[idx] = null
	_on_mats_in_slots_updated()


func recover_mat_from_slots():
	for idx in _mat_slots.size():
		if _mat_slots[idx] != null:
			owned_materials.add_material(_mat_slots[idx], 1)
	return self


func get_storage():
	return owned_materials

### PRIVATE FUNCTIONS ###
func _init_material_list(mat_storage) -> void:
	UTILS.clear_children(materialList)
	for mat in mat_storage.get_materials():
		var ct = mat_storage.get_material_count(mat)
		if ct > 0:
			materialList.add_material(mat, ct, _get_mat_effect(mat))


func _display_craftable_weapons(_craftable_units : ItemPool):
	weaponList.clear()
	for unit in _craftable_units.get_items():
		var item = unit.weapon
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "Displaying [%s]" % [item.name])
		weaponList.add_item(item.name, item.texture)
		weaponList.set_item_tooltip_enabled(weaponList.get_item_count() - 1, false)


func _get_mat_effect(_mat : int) -> String:
	if _selected_unit:
		var hint = WEAPON_ENHANCE_DB.get_hint(
				UTILS.get_enum_string_from_id(Weapon.TYPE, _selected_unit.weapon.get_id()),
				MAT.get_type_name(_mat)
		)
		if hint:
			return hint
	return "no effect"


func _is_craf_valid() -> bool:
	return _selected_unit != null


func _get_craft():
	return UnitRecipe.new(
		_selected_unit,
		MaterialCost.new().add_from_array(_mat_slots)
	)

### SIGNAL RESPONSES ###
func _on_WeaponList_item_selected(index: int) -> void:
	weaponTextureRect.texture = weaponList.get_item_icon(index)
	_selected_unit = craftable_units.get_items()[index]
	_init_material_list(owned_materials)


func _on_material_selected_from_list(mat : int) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "mat selected [%s]" % [MAT.get_type_name(mat)])

	for idx in _mat_slots.size():
		if _mat_slots[idx] == null: # Empty Slot found
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
		if mat != null:
			materialSlots.get_child(t).get_child(0).texture = MAT.get_texture(mat)
		else:
			materialSlots.get_child(t).get_child(0).texture = null
		t += 1


func _on_mat_slot_pressed(idx : int) -> void:
	if _mat_slots[idx]:
		owned_materials.add_material(_mat_slots[idx], 1)
		_mat_slots[idx] = null
		_init_material_list(owned_materials)
		_on_mats_in_slots_updated()


func _on_CraftButton_pressed() -> void:
	if _is_craf_valid():
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "unit created [%s] [%s]" % [_selected_unit.name, _mat_slots])
		emit_signal("unit_created", _get_craft())


func _on_CancelButton_pressed() -> void:
	emit_signal("crafting_cancelled")
