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
export(int) var total_wave_count
export(Resource) var wave_generator
### PUBLIC VAR ###
### PRIVATE VAR ###
var _waves_completed := 0
var _current_wave
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func start_wave(wave_number) -> void:
	if wave_number >= total_wave_count:
		emit_signal("encounter_completed")
		return
	
	_current_wave = wave_generator.generate_wave(wave_number, total_wave_count)


func request_spawn_enemy() -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "Request spawn enemy")
	if _current_wave.empty():
		_waves_completed += 1
		emit_signal("wave_ended", _waves_completed)
	else:
		emit_signal("enemy_summoned", _current_wave.pop())


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
