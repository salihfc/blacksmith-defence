extends Node2D
class_name WeaponSlot
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _weapon = null setget _set_weapon, _get_weapon

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func add_weapon(weapon_instance):
	return _set_weapon(weapon_instance)


func get_weapon():
	return _get_weapon()


func has_weapon() -> bool:
	return _get_weapon() != null

### PRIVATE FUNCTIONS ###
func _set_weapon(weapon_instance):
	_weapon = weapon_instance
	UTILS.clear_children(self)
	add_child(_weapon)
	return self


func _get_weapon():
	return _weapon

### SIGNAL RESPONSES ###
