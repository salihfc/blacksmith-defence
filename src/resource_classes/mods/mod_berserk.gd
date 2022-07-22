tool
extends Mod
class_name ModBerserk
func get_base(): return "Mod"
func get_class(): return "ModBerserk"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var berserk_effect

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func apply_to(unit : Unit):
	unit.add_on_low_life_trigger(Trigger.new(berserk_effect))
	unit.add_mod_display(self)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

