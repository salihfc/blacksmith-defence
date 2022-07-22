extends Resource
class_name WeaponEnhancementData
"""
"""
 ### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var iron = MatEnhanceData.new()
export(Resource) var copper = MatEnhanceData.new()
export(Resource) var fire = MatEnhanceData.new()
export(Resource) var water = MatEnhanceData.new()
export(Resource) var earth = MatEnhanceData.new()

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_hint(mat_type : int):

	match mat_type:
		MaterialData.TYPE.IRON:
			return iron
		MaterialData.TYPE.COPPER:
			return copper
		MaterialData.TYPE.FIRE:
			return fire
		MaterialData.TYPE.WATER:
			return water
		MaterialData.TYPE.EARTH:
			return earth

	assert(0)
	return "Hint NOT defined for mat [%s]" % [mat_type]

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

