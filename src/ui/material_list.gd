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
	assert(material_storage)
	UTILS.clear_children(self)
	for mat in material_storage.get_materials():
		var count = material_storage.get_material_count(mat)
		var material_view = P_MaterialView.instance()
		add_child(material_view)
		assert(mat != null)
		material_view.set_data(mat, count)


func reinit(other_storage):
	update_list(other_storage)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
