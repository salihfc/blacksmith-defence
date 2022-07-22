tool
extends Resource
class_name DevConfig
func get_base(): return "Resource"
func get_class(): return "DevConfig"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### export(bool) var ###
### EXPORT ###
export(bool) var DEBUG_ON = false

export(bool) var SPAWN_ENEMIES = false

export(bool) var SHOW_VFX = true
export(bool) var SHOW_AI_STATE = true
export(bool) var SHOW_HP_BARS = true
export(bool) var SHOW_FLOATING_DAMAGE_NUMBERS = true
export(bool) var SHOW_RANGE_CIRCLES = false

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

