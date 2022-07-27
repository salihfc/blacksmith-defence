extends Control
class_name ScreenTextCreator
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var P_ScreenErrorText

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(P_ScreenErrorText)


func create_text(screen_pos : Vector2, text : String):
	var error_text = P_ScreenErrorText.instance().init(text)
	error_text.rect_position = screen_pos
	add_child(error_text)

	_animate(error_text)

	return self

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
func _animate(error_text) -> void:
	var duration = 1.0

	var start_pos = error_text.rect_position
	var end_pos = start_pos + Vector2.UP * 40.0

	TWEEN.interpolate_property(
		error_text, "rect_position",
		start_pos, end_pos,
		duration
	)

	TWEEN.interpolate_property(
		error_text, "modulate",
		error_text.modulate, Color.transparent,
		duration
	)

	TWEEN.interpolate_callback(error_text, "queue_free", duration + 0.1)


### SIGNAL RESPONSES ###

