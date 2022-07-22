tool
extends Resource
class_name PlayerMainBase
func get_base(): return "Resource"
func get_class(): return "PlayerMainBase"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
signal hp_updated(new_value, max_value)
signal player_main_base_destroyed()

### ENUM ###
### CONST ###
### EXPORT ###
export(float) var max_hp

### PUBLIC VAR ###
### PRIVATE VAR ###
var _current_hp

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func init():
	_update_hp(max_hp)

### PUBLIC FUNCTIONS ###
func take_damage(damage) -> void:
	assert(damage)
	if damage is Damage:
		_update_hp(_current_hp - damage.get_amount())
	elif damage is CumulativeDamage:
		for damage_piece in damage.get_pieces():
			take_damage(damage_piece)

### PRIVATE FUNCTIONS ###
func _update_hp(_new_cur) -> void:
	_current_hp = _new_cur
	emit_signal("hp_updated", _current_hp, max_hp)

	if _current_hp <= 0.0:
		emit_signal("player_main_base_destroyed")

### SIGNAL RESPONSES ###
