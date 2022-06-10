extends SpellBase

"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var blizzardPrefab

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func cast(
		_starting_point : Vector2 = self.global_position,
		_possible_targets : Array = get_possible_targets()
	) -> void:
	pass

### PUBLIC FUNCTIONS ###

func get_radius() -> float:
	return 100.0
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
