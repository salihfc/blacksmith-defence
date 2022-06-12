extends Resource
class_name CacheDict
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _cache = {}

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func clear() -> void:
	_cache.clear()


func cache(path_as_arr : Array, new_value) -> void:
	var _hash = get_hash(path_as_arr)
	_cache[_hash] = new_value


func remove_cached(path_as_arr : Array) -> void:
	var _hash = get_hash(path_as_arr)
	_cache.erase(_hash)


func get_cached(path_as_arr : Array):
	var _hash = get_hash(path_as_arr)
	return _cache.get(_hash)


func is_cached(path_as_arr : Array) -> bool:
	return get_hash(path_as_arr) in _cache


func get_hash(path_as_arr):
	return path_as_arr


func as_array() -> Array:
	var arr = []
	for key in _cache:
		arr.append([key, _cache[key]])
	return arr

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
