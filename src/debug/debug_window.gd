extends PanelContainer
class_name DebugWindow
"""

"""
### SIGNAL ###
### ENUM ###
### CONST ###
const P_RowData = preload("res://src/debug/row_data.tscn")
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var listView = $VBoxContainer as VBoxContainer
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func display_unit(unit) -> void:
	UTILS.clear_children(listView)
	var info = unit.get_info()
	_add_row_with_data_arr(info)

	var utility_scores = unit.get_utility_cache()
	for score_data in utility_scores:
		_add_row_with_data_arr(score_data)

	SIGNAL.bind(
		unit, "info_updated",
		self, "_on_displayed_unit_update",
		[weakref(unit)]
	)


### PRIVATE FUNCTIONS ###
func _add_row_with_data_arr(arr) -> void:
	var row_data_view = P_RowData.instance()
	listView.add_child(row_data_view)
	row_data_view.fill_with(arr)


### SIGNAL RESPONSES ###
func _on_displayed_unit_update(unit_weakref) -> void:
	assert(unit_weakref.get_ref()) # Might break!
	display_unit(unit_weakref.get_ref())
