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


### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###

  
### PUBLIC FUNCTIONS ###
func swing() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("swing")


func set_animation_speed(speed : float) -> void:
	$AnimationPlayer.set_speed_scale(speed)
### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
func _send_damage_frame() -> void:
	emit_signal("damage_frame", 0)
