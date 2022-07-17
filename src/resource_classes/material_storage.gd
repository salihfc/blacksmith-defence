extends Reference
class_name MaterialStorage
"""
"""
### SIGNAL ###
signal changed()

### ENUM ###
### CONST ###
### EXPORT ###
export(Dictionary) var _storage = {
	# Material Res : Count
}

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(_dict : Dictionary = {}):
	_storage = _dict.duplicate(true)


func _to_string() -> String:
	if _storage.size() == 0:
		return "{}"
	return UTILS.pretty_dict(_storage)


func copy_from(other_storage):
	if other_storage:
		_storage = other_storage._storage
	return self

### PUBLIC FUNCTIONS ###
func add_storage(other_storage):
	for mat in other_storage.get_materials():
		_add_material(mat, other_storage.get_material_count(mat))
	return self


func add_material(mat : MaterialData, ct : int):
	_add_material(mat, ct)
	return self


func add_from_array(mat_arr : Array):
	for item in mat_arr:
		if item == null:
			continue
		add_material(item, 1)
	return self


func get_materials() -> Array:
	return _storage.keys()


func get_material_count(mat : MaterialData) -> int:
	if _has_material(mat, 0):
		return _storage[mat]
	return 0


func covers_cost(_cost : MaterialStorage) -> bool:
	for mat in _cost.get_materials():
		if not _has_material(mat, _cost.get_material_count(mat)):
			return false
	return true


func use_material(mat : MaterialData, ct : int):
	_use_material(mat, ct)
	return self


func use_cost(_cost : MaterialStorage):
	var mats = _cost.get_materials()
	for mat in mats.keys():
		_use_material(mat, mats[mat])
	return self

### PRIVATE FUNCTIONS ###
func _has_material(mat : MaterialData, ct : int) -> bool:
	var key_to_check = null
	for _mat in _storage:
		if _mat.type == mat.type:
			key_to_check = _mat
			break
	return key_to_check and _storage[key_to_check] >= ct


func _use_material(mat : MaterialData, ct : int) -> void:
	var key_to_decrease = null
	for _mat in _storage:
		if _mat.type == mat.type:
			key_to_decrease = _mat
			break

	assert(key_to_decrease)
	_storage[key_to_decrease] -= ct
	_on_change()


func _add_material(mat : MaterialData, ct : int) -> void:
	var key_to_increase = mat
	for _mat in _storage:
		if _mat.type == mat.type:
			key_to_increase = _mat
			break

	# First time this type of mat is added
	if not key_to_increase in _storage:
		_storage[key_to_increase] = 0
	_storage[key_to_increase] += ct
	_on_change()


func _on_change() -> void:
	emit_signal("changed")

### SIGNAL RESPONSES ###
