extends UnitEnhancementBase
class_name UnitEnhancementMod
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
