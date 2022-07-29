tool
extends Resource
class_name MaterialCost
func get_base(): return "Resource"
func get_class(): return "MaterialCost"
func is_class(_name): return _name == get_class() or .is_class(_name)
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Dictionary) var _storage = {
	# Material Type Enum : Count
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

	var string := ""

	for mat_id in _storage:
		assert(mat_id is int)

		string += UTILS.wrap_str(UTILS.get_enum_string_from_id(MAT.TYPE, mat_id), "[", "]")
		string += " : "
		string += UTILS.wrap_str(str(_storage.get(mat_id, 0)), "[", "]")
		string += "\n"


	return UTILS.wrap_str(string, "\n{\n", "\n}\n")


func copy_from(other_storage):
	if other_storage:
		if other_storage._storage:
			_storage = other_storage._storage.duplicate(true)
		else:
			_storage = {}
	return self

### PUBLIC FUNCTIONS ###
func add_storage(other_storage):
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "OTHER STORAGE (%s) (%s)\n MATS: (%s)" % [other_storage.resource_path, other_storage, other_storage.get_materials()])


	for mat in other_storage.get_materials():
		var count = other_storage.get_material_count(mat)
#		LOG.pr(LOG.LOG_TYPE.INTERNAL, "(%s) ADD STORAGE MAT (%s) [%s]" % [self, mat, count])
		_add_material(mat, count)
	return self


func add_material(mat : int, ct : int):
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "(%s) ADD MAT (%s) [%s]" % [self, mat, ct])
	_add_material(mat, ct)
	return self


func add_from_array(mat_arr : Array):
	for item in mat_arr:
		assert(item != null)
		add_material(item, 1)
	return self


func get_materials() -> Array:
	return _storage.keys()


func get_material_count(mat : int) -> int:
	if _has_material(mat, 0):
		return _storage[mat]
	return 0


func covers_cost(_cost) -> bool:
	for mat in _cost.get_materials():
		if not _has_material(mat, _cost.get_material_count(mat)):
			return false
	return true


func use_material(mat : int, ct : int):
	_use_material(mat, ct)
	return self


func use_cost(_cost):
	var mats = _cost.get_materials()
	for mat in mats.keys():
		_use_material(mat, mats[mat])
	return self

### PRIVATE FUNCTIONS ###
func _has_material(mat, ct : int) -> bool:
	return mat in _storage and _storage[mat] >= ct


func _use_material(mat, ct : int) -> void:
	assert(mat in _storage)
	_storage[mat] -= ct
	_on_change()


func _add_material(mat, ct : int) -> void:
	# First time this type of mat is added
	if not mat in _storage:
		_storage[mat] = 0
	_storage[mat] += ct
	_on_change()


func _on_change() -> void:
	emit_signal("changed")

### SIGNAL RESPONSES ###
