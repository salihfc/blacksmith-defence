extends PanelContainer
class_name DebugWindow

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
const PrefabRowData = preload("res://src/debug/row_data.tscn")
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _last_displayed_unit = null

### ONREADY VAR ###
onready var listView = $VBoxContainer as VBoxContainer
### VIRTUAL FUNCTIONS (_init ...) ###

### PUBLIC FUNCTIONS ###
func display_unit(unit) -> void:
	
	if _last_displayed_unit and _last_displayed_unit.get_ref():
		# break the signal connection
		UTILS.unbind(
			_last_displayed_unit.get_ref(), "info_updated",
			self, "_on_displayed_unit_update"
		)
	
	UTILS.clear_children(listView)
	var info = unit.get_info()
	_add_row_with_data_arr(info)
	
	var utility_scores = unit.get_utility_cache()
	for score_data in utility_scores:
		_add_row_with_data_arr(score_data)

	UTILS.bind(
		unit, "info_updated",
		self, "_on_displayed_unit_update"
	)
	
	_last_displayed_unit = weakref(unit)


### PRIVATE FUNCTIONS ###
func _add_row_with_data_arr(arr) -> void:
	var row_data_view = PrefabRowData.instance()
	listView.add_child(row_data_view)
	row_data_view.fill_with(arr)



### SIGNAL RESPONSES ###

func _on_displayed_unit_update() -> void:
	display_unit(_last_displayed_unit.get_ref())
