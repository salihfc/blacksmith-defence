extends Resource
class_name CumulativeDamage
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Array, Resource) var _damage_pieces = []

### PUBLIC VAR ###
func get_pieces():
	return _damage_pieces


func add_piece(damage_piece : Damage):
	_damage_pieces.append(damage_piece)
	return self

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(from_array : Array = []) -> void:
	_damage_pieces = from_array

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
