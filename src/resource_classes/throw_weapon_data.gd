extends Resource
class_name ThrowableWeaponData
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(int) var id = -1
export(String) var name = "weapon"
export(Texture) var texture = null
export(float) var base_damage = 20.0

export(Animation) var idle_anim
export(Animation) var hold_anim
export(Animation) var swing_anim
export(Animation) var slam_anim
export(Animation) var thrust_anim

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_id():
	return id

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
