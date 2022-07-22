tool
extends ItemPool
class_name MaterialPool
func get_base(): return "ItemPool"
func get_class(): return "MaterialPool"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
#func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _to_string() -> String:
	return str(items)

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
