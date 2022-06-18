extends HBoxContainer

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
const P_MaterialView = preload("res://src/ui/material_view.tscn")
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _material_storage = MaterialStorage.new()
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func update_list() -> void:
	UTILS.clear_children(self)
	for mat in _material_storage.get_materials():
		var count = _material_storage.get_material_count(mat)
		var material_view = P_MaterialView.instance()
		add_child(material_view)
		material_view.set_data(mat, count)


func reinit(other_storage):
	_material_storage.copy_from(other_storage)
	update_list()


func get_storage():
	return _material_storage


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_material_collected(mat : MaterialData, count : int) -> void:
	LOG.pr(LOG.LOG_TYPE.INPUT, "Mat collected [%s] %s" % [count, mat])
	_material_storage.add_material(mat, count)
	update_list()


func _on_material_used(mat : MaterialData, count : int) -> void:
	LOG.pr(LOG.LOG_TYPE.INPUT, "Mat used [%s] %s" % [count, mat])
	_material_storage.use_material(mat, count)
	update_list()
