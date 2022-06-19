tool
extends UnitEnhancementBase
class_name UnitEnhancementStat
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
export(StatContainer.STATS) var stat_id = 0
export(int) var increase_value = 0

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(_stat_id = 0, _value = 0) -> void:
	stat_id = _stat_id
	increase_value = _value

### PUBLIC FUNCTIONS ###
func apply_to(_stats) -> void:
	if _stats.has_stat(stat_id):
		_stats.increase_stat(stat_id, increase_value)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
