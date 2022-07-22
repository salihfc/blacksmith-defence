tool
extends Resource
class_name Effect
func get_base(): return "Resource"
func get_class(): return "Effect"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
func copy_from_prototype(_prototype):
	assert(0)
	return self

### PUBLIC FUNCTIONS ###
func trigger(_subject=null, _object=null, _args={}):
	assert(0) # Virtual function do not call on base class

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

