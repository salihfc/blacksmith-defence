extends Resource
class_name MaterialPool

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Array, Resource) var materials
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_materials():
	return materials


func get_random():
	return UTILS.get_random_from(materials)
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
