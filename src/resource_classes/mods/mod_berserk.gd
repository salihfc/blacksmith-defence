extends Mod
class_name ModBerserk
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

