extends Node2D
class_name SpellBase
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var owner_unit_weakref = null

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_owner(_unit) -> void:
	owner_unit_weakref = weakref(_unit)


func get_possible_targets():
	return get_tree().get_nodes_in_group(CONFIG.ENEMY_GROUP)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
