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
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_possible_targets():
	return get_tree().get_nodes_in_group(CONFIG.ENEMY_GROUP)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
