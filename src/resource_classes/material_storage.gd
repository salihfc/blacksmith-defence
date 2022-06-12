extends Resource
class_name MaterialStorage
"""
"""
### SIGNAL ###
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
### PUBLIC FUNCTIONS ###
func add_material(mat : MaterialData, ct : int) -> void:
	if not mat in _storage:
		_storage[mat] = 0
	_storage[mat] += ct


func has_material(mat : MaterialData, ct : int) -> bool:
	return _storage.get(mat) and _storage[mat] >= ct


func use_material(mat : MaterialData, ct : int) -> void:
	assert(_storage[mat] >= ct)
	_storage[mat] -= ct


func get_materials() -> Dictionary:
	return _storage


func covers_cost(_cost : MaterialStorage) -> bool:
	var mats = _cost.get_materials()
	for mat in mats.keys():
		if not has_material(mat, mats[mat]):
			return false
	return true


func use_cost(_cost : MaterialStorage) -> void:
	var mats = _cost.get_materials()
	for mat in mats.keys():
		use_material(mat, mats[mat])

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
