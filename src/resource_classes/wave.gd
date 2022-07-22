tool
extends Resource
class_name WaveData
func get_base(): return "Resource"
func get_class(): return "WaveData"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
#func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
signal wave_ended()

### ENUM ###
### CONST ###
### EXPORT ###
export(Array, Resource) var enemies = []

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _to_string() -> String:
	var string = "\nWave: {\n"
	for enemy in enemies:
		string += "[%s] %s\n" % [enemy.calc_power(), enemy]
	string += "}\n"
	return string

### PUBLIC FUNCTIONS ###
func pop():
	if enemies.empty():
		return null

	enemies.shuffle()
	var enemy = enemies.back()
	enemies.pop_back()
	if enemies.size():
		emit_signal("wave_ended")
	return enemy


func add(unit_data : UnitData):
	enemies.append(unit_data)


func empty() -> bool:
	return enemies.size() == 0

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
