extends Node2D

"""

"""

### SIGNAL ###
signal damage_frame(damage_amount)

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _base_damage
### ONREADY VAR ###



### VIRTUAL FUNCTIONS (_init ...) ###
func init_with_data(weapon_data : WeaponData) -> void:
	_base_damage = weapon_data.base_damage


### PUBLIC FUNCTIONS ###
func swing() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("swing")


func set_animation_speed(speed : float) -> void:
	$AnimationPlayer.set_speed_scale(speed)


### PRIVATE FUNCTIONS ###
func _send_damage_frame() -> void:
	emit_signal("damage_frame", _base_damage)


### SIGNAL RESPONSES ###
