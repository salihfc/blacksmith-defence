tool
extends Mod
class_name ModThorns
func get_base(): return "Mod"
func get_class(): return "ModThorns"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var effect

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
# warning-ignore:unused_argument
func apply_to(unit : Unit):
	unit.add_on_hit_taken_trigger(Trigger.new(effect))
	unit.add_mod_display(self)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

