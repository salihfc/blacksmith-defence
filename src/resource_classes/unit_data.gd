extends Resource
class_name UnitData
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
export(String) var name
export(Texture) var texture
export(Texture) var view_texture
export(float) var max_hp
export(Resource) var cost = MaterialStorage.new() # MaterialStorage

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func get_view_texture():
	if view_texture:
		return view_texture
	return texture

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
