extends Mod
class_name ModMartyr
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
	unit.add_on_low_life_trigger(Trigger.new(effect))
	unit.add_mod_display(self)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

