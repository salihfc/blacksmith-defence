extends Node2D

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _max_hp
var _hp
var _damage
var _speed
var _velocity

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite


### VIRTUAL FUNCTIONS (_init ...) ###
func _physics_process(delta):
	global_position += _velocity * delta * _speed


### PUBLIC FUNCTIONS ###
func init_after_ready(enemy_data) -> void:
	_max_hp = enemy_data.max_hp
	_hp = _max_hp
	_damage = enemy_data.damage
	_speed = enemy_data.speed
	sprite.texture = enemy_data.texture


func send_in_direction(dir : Vector2) -> void:
	_velocity = dir.normalized()


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
