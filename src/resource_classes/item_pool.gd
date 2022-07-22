tool
extends Resource
class_name ItemPool
func get_base(): return "Resource"
func get_class(): return "ItemPool"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Array, Resource) var items

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_items():
	return items


func get_random():
	if items.size():
		return items[randi() % items.size()]
	return null

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
