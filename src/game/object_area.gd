extends Area2D
class_name ObjectArea
"""
"""
### SIGNAL ###
signal areas_inside_changed()

### ENUM ###
### CONST ###
### EXPORT ###
export(bool) var dynamic_tracking = false
export(NodePath) var owner_path = null

### PUBLIC VAR ###
### PRIVATE VAR ###
var _areas_inside = {}

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(owner_path != null)
	modulate = Color("4effffff")

	if dynamic_tracking:
		SIGNAL.bind_bulk(
			self, self,
			[
				["area_entered", "_on_area_entered"],
				["area_exited", "_on_area_exited"],
			]
		)


### PUBLIC FUNCTIONS ###]
func get_owner():
	return get_node_or_null(owner_path)


func get_areas_inside() -> Array:
#	assert(dynamic_tracking) # Should not be called if ObjectArea does not have dynamic tracking
	if dynamic_tracking:
		return _areas_inside.keys()
	return get_overlapping_areas()


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_area_entered(area : Area2D) -> void:
	_areas_inside[area] = true
	emit_signal("areas_inside_changed")


func _on_area_exited(area : Area2D) -> void:
	var erased_something = _areas_inside.erase(area)
	if erased_something:
		emit_signal("areas_inside_changed")

