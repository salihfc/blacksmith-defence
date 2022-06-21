extends Control

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(bool) var animate = false

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var bar = $ProgressBar as ProgressBar
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_value(value : float) -> void:
	if not animate:
		bar.value = value * 100.0
	else:
		TWEEN.interpolate_property(
			bar, "value",
			bar.value, value * 100.0,
			0.4
		)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
