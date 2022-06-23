extends Node

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
func get_resisted(value : float, resist : float):
	return value * (1.0 - (resist/100.0))


func get_poison_damage(stack_count) -> float:
	return 10.0 * log(stack_count) + 6.5


func get_bleed_damage(stack_count) -> float:
	return stack_count

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
