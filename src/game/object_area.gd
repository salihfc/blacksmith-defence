extends Area2D
class_name ObjectArea

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(NodePath) var owner_path = null
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###]
func get_owner():
	return get_node_or_null(owner_path)
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
