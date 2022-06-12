extends Resource
class_name WaveData
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
