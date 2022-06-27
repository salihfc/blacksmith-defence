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


func get_ignite_damage(originator_damage) -> float:
	if originator_damage == null:
		return 0.0
	return originator_damage.get_amount() * 0.3


class SortPairsBySecondElement:
	# a, b are Arrays
	static func sort_descending(a, b):
		if a[1] > b[1]:
			return true
		return false


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
