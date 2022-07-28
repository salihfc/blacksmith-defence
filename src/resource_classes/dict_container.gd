tool
extends Resource
class_name DictContainer
func get_base(): return "Resource"
func get_class(): return "DictContainer"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
	A container class that wraps around Built-in dictionary.
	Extra features:
		- Saving and loading dict as a TRES


Default Dictionary functions:
	void clear()
	Dictionary duplicate(deep: bool = false)
	bool empty()
	bool erase(key: Variant)
	Variant get(key: Variant, default: Variant = null)
	bool has(key: Variant)
	bool has_all(keys: Array)
	int hash()
	Array keys()
	int size()
	Array values()
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Dictionary) var _dict

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init() -> void:
	_dict = {}


### PUBLIC FUNCTIONS ###
func empty() -> bool:
	return _dict.empty()


func has(key) -> bool:
	return _dict.has(key)


func has_all(keys) -> bool:
	return _dict.has_all(keys)


func size() -> int:
	return _dict.size()


func get(key, default = null):
	return _dict.get(key, default)


func hash(): # WTF
	return _dict.hash()


func keys() -> Array:
	return _dict.keys()


func values() -> Array:
	return _dict.values()

##
func clear():
	_dict.clear()
	return self


func erase(key) -> bool:
	return _dict.erase(key)


func set(key, value):
#	prints ("SET", key, value)
	_dict[key] = value
	return self

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

