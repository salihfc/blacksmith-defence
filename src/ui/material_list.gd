extends HBoxContainer
class_name MaterialList
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
const P_MaterialView = preload("res://src/ui/material_view.tscn")

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func update_list(material_storage) -> void:
	UTILS.clear_children(self)

	if material_storage:
		for mat in material_storage.get_materials():
			assert(mat != null)

			var count = material_storage.get_material_count(mat)
			var material_view = P_MaterialView.instance().set_data(mat, count)
			add_child(material_view)


func reinit(other_storage):
	update_list(other_storage)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
