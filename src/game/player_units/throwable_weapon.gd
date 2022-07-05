extends Node2D
class_name ThrowableWeapon
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var max_velocity
#export(float) var max_z_velocity
export(float) var gravity
export(float) var max_height

### PUBLIC VAR ###
### PRIVATE VAR ###
var _height  = 0
var _thrown = false
var z_velocity = 0.0
var _velocity = Vector2.ZERO


### ONREADY VAR ###
onready var sprite = $Pivot/Sprite as Sprite
onready var pivot = $Pivot as Node2D

### VIRTUAL FUNCTIONS (_init ...) ###
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and _thrown == false:
		var target_pos = get_global_mouse_position()
		throw(target_pos)


func _physics_process(delta: float) -> void:

	if _thrown:
		global_position += _velocity * delta
		_height += z_velocity * delta
		z_velocity += -gravity * delta

		LOG.pr(LOG.LOG_TYPE.INTERNAL, "h:[%s], z_v:[%s]" % [_height, z_velocity])

#		sprite.offset = Vector2(0.0, -_height)
		pivot.look_at(global_position + ((_velocity + Vector2.UP * z_velocity * 40.0) * 100.0))

		if _height <= 0.0:
			sprite.offset = Vector2.ZERO
			_height = 0
			_thrown = false
			_velocity = Vector2.ZERO



### PUBLIC FUNCTIONS ###
func throw(target_pos : Vector2) -> void:
	_thrown = true
	_height = 0

	_velocity = global_position.direction_to(target_pos) * max_velocity
#	_velocity = global_position.direction_to(target_pos) * global_position.distance_to(target_pos)
	var t = global_position.distance_to(target_pos) / _velocity.length()
	z_velocity = _get_z_velocity()

	LOG.pr(LOG.LOG_TYPE.INTERNAL, "THROW [%s] -> [%s] [t:%s]" % [global_position, target_pos, t])


### PRIVATE FUNCTIONS ###
func _get_z_velocity():
	return (2.0 * max_height) / gravity

### SIGNAL RESPONSES ###

