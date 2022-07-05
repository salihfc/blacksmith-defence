tool
extends Node2D
class_name SpellBase
"""
"""
### SIGNAL ###
signal enemy_hit(target, damage)

### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var owner_unit_weakref = null

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###

func get_total_damage():
	assert(0)
	return null

### PUBLIC FUNCTIONS ###
func set_owner_unit(_unit) -> void:
	owner_unit_weakref = weakref(_unit)


func get_owner():
	if owner_unit_weakref:
		return owner_unit_weakref.get_ref()
	return null


func get_possible_targets():
	return get_tree().get_nodes_in_group(CONFIG.ENEMY_GROUP)

### PRIVATE FUNCTIONS ###
func _damage_targets(targets) -> void:
	for target in targets:
		if target.has_method("take_damage"):
			var total = get_total_damage()
			target.take_damage(total)
			emit_signal("enemy_hit", target, total)
		else:
			push_warning("target cannot take damage")

### SIGNAL RESPONSES ###
