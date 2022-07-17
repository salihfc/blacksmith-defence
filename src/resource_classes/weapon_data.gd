tool
extends Resource
class_name WeaponData
func get_base(): return "Resource"
func get_class(): return "WeaponData"
func is_class(_name): return _name == "WeaponData" or .is_class(_name)
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

export(Shape2D) var collision_shape
export(Vector2) var collision_shape_offset

export(bool) var throwable = false

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_id():
	return id

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
