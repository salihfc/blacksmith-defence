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
	var ref = _get_obj_at_path(path_as_arr)
	ref[path_as_arr.back()] = new_value


func remove_cached(path_as_arr : Array) -> void:
	var ref = _get_obj_at_path(path_as_arr)
	ref.erase(path_as_arr.back())


func get_cached(path_as_arr : Array):
	var ref = _get_obj_at_path(path_as_arr)
	return ref.get(path_as_arr.back())


func as_array() -> Array:
	return _traverse_dict_tree(_cache, null, [])


### PRIVATE FUNCTIONS ###
func _traverse_dict_tree(cur, parent, path : Array) -> Array:
	if not cur is Dictionary:
		return [[cur, parent[cur]]]
	
	var res = []
	for key in cur.keys():
		path.push_back(key)
		var sub_arr = _traverse_dict_tree(key, cur, path)
		path.pop_back()
		res.append_array(sub_arr)
	return res


func _get_obj_at_path(path_as_arr : Array):
	var n = path_as_arr.size()
	var i = 0
	var ref = _cache
	
	while i < (n - 1): # !!!!!!
		var key = path_as_arr[i]
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "KEY [%s]" % [key])
		if not key in ref:
			ref[key] = {}
		ref = ref[key]
		i += 1
	return ref
### SIGNAL RESPONSES ###
