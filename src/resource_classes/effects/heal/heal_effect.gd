extends Effect
class_name HealEffect
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var heal_amount = 0.0

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
func copy_from_prototype(_prototype):
	heal_amount = _prototype.heal_amount
	return self

### PUBLIC FUNCTIONS ###
func trigger(_subject=null, _object=null, _args={}):
	assert(_subject and _subject.has_method("heal"))
	_subject.heal(heal_amount)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

