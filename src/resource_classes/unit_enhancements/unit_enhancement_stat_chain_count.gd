tool
extends UnitEnhancementStat
class_name UnitEnhancementStatChainCount
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(int) var increase_value = 0

### PUBLIC VAR ###
func apply_to(_stats) -> void:
	if _stats.has_stat(StatContainer.STATS.CHAIN_COUNT):
		_stats.increase_stat(StatContainer.STATS.CHAIN_COUNT, increase_value)


### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
