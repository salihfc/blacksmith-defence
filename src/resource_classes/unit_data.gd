extends Resource
class_name UnitData
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
# Visual
export(String) var name
export(Texture) var texture
export(Texture) var view_texture
export(Resource) var cost = MaterialStorage.new() # MaterialStorage

# Battle
export(float) var max_hp
export(float) var resist_phys	= 0.0
export(float) var resist_fire	= 0.0
export(float) var resist_water	= 0.0
export(float) var resist_earth	= 0.0

export(float) var move_speed	= 1.0	# pixel/second
export(float) var atk_speed		= 1.0	# attacks per second
export(float) var damage_multi	= 1.0

export(Resource) var weapon

#
export(Resource) var enchancements = MaterialStorage.new()

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
