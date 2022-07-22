tool
extends Resource
class_name UnitEnhancementBase
func get_base(): return "Resource"
func get_class(): return "UnitEnhancementBase"
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
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func apply_to(_unit) -> void:
	assert(0) # Should not be called [virtual func]

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
