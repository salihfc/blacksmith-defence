extends Node2D
"""
"""
### SIGNAL ###
signal collected()

### ENUM ###
### CONST ###
### EXPORT ###
export(float) var auto_collect_after = 1.0

### PUBLIC VAR ###
### PRIVATE VAR ###
var _mat : MaterialData
var _ct : int
var _collected = false

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	sprite.texture = _mat.sprite


### PUBLIC FUNCTIONS ###
func set_data(mat : MaterialData, ct : int) -> void:
	_mat = mat
	_ct = ct


func get_mat():
	return _mat


func get_count():
	return _ct


func play_drop_animation() -> void:
	TWEEN.interpolate_property_to_and_back(
		self, "scale",
		scale, Vector2.ZERO,
		0.3, 0.1
	)

	TWEEN.call_deferred(
		"interpolate_method_to_and_back",

		self, "_set_shader_param_glow_anim_t",
		0.0, 1.0,
		0.1, 0.1
	)

	$AutoCollectTimer.call_deferred("start", auto_collect_after)


func play_collect_animation() -> void:
	var anim_duration = 0.3
	TWEEN.interpolate_property(
		self, "scale",
		scale, Vector2.ZERO,
		anim_duration
	)

	$AutoFreeTimer.call_deferred("start", anim_duration)

### PRIVATE FUNCTIONS ###
func _set_shader_param_glow_anim_t(t : float) -> void:
	sprite.material.set_shader_param("in_anim_t", t)


func _collect() -> void:
	if not _collected:
		_collected = true
		play_collect_animation()
		emit_signal("collected")

### SIGNAL RESPONSES ###
func _on_MousePickingArea_area_entered(_area):
	_collect()


func _on_AutoCollectTimer_timeout() -> void:
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "TIMER TIMEOUT >>")
	_collect()


func _on_AutoFreeTimer_timeout() -> void:
	call_deferred("queue_free")
