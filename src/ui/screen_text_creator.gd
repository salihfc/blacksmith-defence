extends Control
class_name ScreenTextCreator
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var P_ScreenErrorText
export(PackedScene) var P_ScreenGratzText

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(P_ScreenErrorText)
	assert(P_ScreenGratzText)


func create_gratz_text(screen_pos : Vector2, text : String):
	var gratz_text = P_ScreenGratzText.instance().init(text)
	gratz_text.rect_position = screen_pos
	add_child(gratz_text)
	_animate(gratz_text, Vector2.DOWN * 10.0, 3.0)
	return self


func create_error_text(screen_pos : Vector2, text : String):
	var error_text = P_ScreenErrorText.instance().init(text)
	error_text.rect_position = screen_pos
	add_child(error_text)

	_animate(error_text)

	return self

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
func _animate(error_text, movement = Vector2.UP * 40.0, duration = 1.0) -> void:
	var start_pos = error_text.rect_position
	var end_pos = start_pos + movement

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

