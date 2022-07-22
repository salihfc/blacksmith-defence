tool
extends UnitEnhancementBase
class_name UnitEnhancementMod
func get_base(): return "UnitEnhancementBase"
func get_class(): return "UnitEnhancementMod"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var mod

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func apply_to(_unit) -> void:
	assert(mod is Mod)
	mod.apply_to(_unit)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
