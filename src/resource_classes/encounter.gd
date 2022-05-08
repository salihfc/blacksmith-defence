extends Resource
class_name EncounterData
"""

"""

### SIGNAL ###
signal encounter_completed()
signal wave_ended(wave_idx)
signal enemy_summoned(unit_data)
### ENUM ###
### CONST ###
### EXPORT ###
export(Array, Resource) var waves = []
### PUBLIC VAR ###
### PRIVATE VAR ###
var _current_wave_idx
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func start_wave(_wave_idx) -> void:
	_current_wave_idx = _wave_idx


func request_spawn_enemy() -> void:
	LOG.pr(1, "Request spawn enemy")
	if _current_wave_idx >= waves.size():
		emit_signal("encounter_completed")
	else:
		if waves[_current_wave_idx].empty():
			emit_signal("wave_ended", _current_wave_idx)
		else:
			emit_signal("enemy_summoned", waves.back().pop())


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
