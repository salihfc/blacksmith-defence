extends VBoxContainer
class_name StatList
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
const HIDE_VALUE = 0

### EXPORT ###
export(PackedScene) var P_StatDisplay

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func display_stats(_stats) -> void:
	assert(P_StatDisplay)
	UTILS.clear_children(self)
	var stat_dict = _stats.get_stat_list()

	for stat_name in stat_dict:
		var stat_value = stat_dict[stat_name]
		if stat_value != HIDE_VALUE:
			var stat_display = P_StatDisplay.instance()
			add_child(stat_display)
			stat_display.init(UTILS.extract_path_filename(stat_name), stat_value)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
