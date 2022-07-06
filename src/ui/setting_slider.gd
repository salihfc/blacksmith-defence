extends Control
class_name SettingSlider
"""
"""
### SIGNAL ###
signal option_value_changed(new_frac_value)
signal enabled(enable)

### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var check_button = $HBoxContainer/CheckButton as CheckButton
onready var slider = $HBoxContainer/HSlider as HSlider

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_option(option_name : String = "", option_icon : Texture = null, frac_value : float = 0.0):
	_set_name(option_name)
	_set_icon(option_icon)
	_set_value(frac_value)

### PRIVATE FUNCTIONS ###
func _set_name(__name) -> void:
	check_button.text = __name


func _set_icon(__icon) -> void:
	check_button.icon = __icon


func _set_value(__frac_value : float) -> void:
	assert(0.0 <= __frac_value and __frac_value <= 1.0)
	slider.value = _to_slider_value(__frac_value)


func _to_slider_value(__frac_value) -> float:
	return slider.min_value + (slider.max_value - slider.min_value) * __frac_value


func _to_frac_value(slider_value) -> float:
	return (slider_value - slider.min_value) / (slider.max_value - slider.min_value)

### SIGNAL RESPONSES ###
func _on_CheckButton_toggled(enabled: bool) -> void:
	slider.editable = enabled
	emit_signal("enabled", enabled)


func _on_HSlider_value_changed(value: float) -> void:
	emit_signal("option_value_changed", _to_frac_value(value))
