tool
extends Resource
class_name WaveGenerator
func get_base(): return "Resource"
func get_class(): return "WaveGenerator"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var enemy_pool

export(float) var base_power = 10.0
export(Curve) var power_curve
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func generate_wave(wave_number : int, max_wave : int):
	var wave_t = float(wave_number) / max_wave
	var wave = WaveData.new()
	var power = _get_wave_power(wave_t)
	var current_power = 0

	while current_power < power:
		var random_enemy = _get_random_enemy()
		random_enemy.scale_to_wave(wave_t)
		current_power += random_enemy.calc_power()
		wave.add(random_enemy)

	LOG.pr(LOG.LOG_TYPE.INTERNAL | LOG.LOG_TYPE.GAMEPLAY, "[%s]WAVE_GEN (%s) power generated" % [wave_t, current_power])
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "%s" % [wave])

	return wave


### PRIVATE FUNCTIONS ###
func _get_wave_power(_wave_offset : float) -> float:
	return power_curve.interpolate(_wave_offset) * base_power


func _get_random_enemy():
	return enemy_pool.get_random().duplicate()

### SIGNAL RESPONSES ###
