extends Control
class_name StatusListDisplay
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var P_StatusIconDisplay
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var hbox_container: HBoxContainer = $"HBoxContainer"

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func bind_container(container):
	SIGNAL.bind(
		container, "statuses_changed",
		self, "_on_container_changed"
	)
	return self

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

func _on_container_changed(statuses) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "STATUSES CHANGED")
	UTILS.clear_children(hbox_container)

	for status_type in statuses:
		if statuses[status_type].size():
			var status = statuses[status_type][0]
			var icon = status.icon
			var texture_rect = P_StatusIconDisplay.instance()
			texture_rect.texture = icon
			hbox_container.add_child(texture_rect)

	pass
