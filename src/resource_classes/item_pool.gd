extends Resource
class_name ItemPool

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
export(Array, Resource) var items

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func get_items():
	return items


func get_random():
	if items.size():
		return items[randi() % items.size()]
	return null

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
