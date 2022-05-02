extends Resource
class_name MaterialStorage
"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _storage = {
	# Material Res : Count
}

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func add_material(mat : MaterialData, ct : int) -> void:
	if not mat in _storage:
		_storage[mat] = 0
	_storage[mat] += ct


func has_material(mat : MaterialData, ct : int) -> bool:
	return _storage[mat] >= ct


func use_material(mat : MaterialData, ct : int) -> void:
	assert(_storage[mat] >= ct)
	_storage[mat] -= ct


func get_materials() -> Dictionary:
	return _storage

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
