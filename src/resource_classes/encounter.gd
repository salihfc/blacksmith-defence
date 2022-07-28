tool
extends Resource
class_name EncounterData
func get_base(): return "Resource"
func get_class(): return "EncounterData"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
signal encounter_completed()
signal wave_ended(wave_idx)
signal wave_started(wave_idx)
signal enemy_encountered(unit_data)

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


	emit_signal("wave_started", wave_number + 1)
	_current_wave = wave_generator.generate_wave(wave_number, total_wave_count)


func request_spawn_enemy() -> void:
	if is_wave_done():
		_waves_completed += 1
		emit_signal("wave_ended", _waves_completed)
	else:
		LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "Request spawn enemy")
		emit_signal("enemy_encountered", _current_wave.pop())


func is_wave_done() -> bool:
	return _current_wave.empty()

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
