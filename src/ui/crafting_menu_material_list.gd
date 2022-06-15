extends VBoxContainer
"""
"""

### SIGNAL ###
signal material_selected_from_list(mat)

### ENUM ###
### CONST ###
const P_CraftingMenuMaterial = preload("res://src/ui/crafting_menu_material.tscn")

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func add_material(mat : MaterialData, ct : int, mat_effect_on_weapon : String) -> void:
	var new_mat = P_CraftingMenuMaterial.instance()
	add_child(new_mat)
	new_mat.set_mat(mat, ct, mat_effect_on_weapon)

	SIGNAL.bind(
		new_mat, "material_selected",
		self, "_on_material_selected"
	)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_material_selected(mat) -> void:
	emit_signal("material_selected_from_list", mat)
