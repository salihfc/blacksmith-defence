extends Resource
class_name GridDataContainer
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var _data = CacheDict.new()

### PUBLIC VAR ###
func clear() -> void:
	_data.clear()


func place_object(object : Object, pos : Vector2) -> void:
	assert(not is_occupied(pos))
	_data.cache(_input_transform(pos), object)


func remove_object(pos : Vector2) -> void:
	var path = _input_transform(pos)
	if _data.is_cached(path):
		_data.remove_cached(path)


func is_occupied(pos : Vector2) -> bool:
	var input = _input_transform(pos)
	return _data.is_cached(input)


func is_pos_empty(pos : Vector2) -> bool:
	return not is_occupied(pos)

### PRIVATE VAR ###
func _input_transform(pos):
	return UTILS.vec2_to_int_arr(pos)

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
