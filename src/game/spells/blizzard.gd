extends Node2D

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var speed_mod = 0.8
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var hitboxShape = $Areas/DamageArea/CollisionShape2D as CollisionShape2D
### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func set_pos(pos : Vector2):
	set_as_toplevel(true)
	global_position = pos


func animate():
	animPlayer.play("pulse")


### PRIVATE FUNCTIONS ###
func _enable_hitbox(enabled := true):
	hitboxShape.disabled = not enabled


### SIGNAL RESPONSES ###
func _on_SlowArea_area_entered(area: Area2D) -> void:
	var object = area.get_owner()
	
	if object and object.has_method("apply_move_speed_mod"):
		object.apply_move_speed_mod(speed_mod)
