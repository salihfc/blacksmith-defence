extends Node2D

"""
	This type of projectiles will still be rendered using y-sort.
	
	y axis if sprite will be offsetted by "_height" value to place the projectile in correct place 
	
	x+ = y+ 2d
	y+ = h+ 2d
	z+ = x- 2d
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _delta_vertical = 0.0
var _height = 0.0

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite
onready var projectile = $"ViewportContainer/Viewport/3DProjectile" as Spatial

### VIRTUAL FUNCTIONS (_init ...) ###

### PUBLIC FUNCTIONS ###
func shoot() -> void:
	pass

### PRIVATE FUNCTIONS ###
func _update_offset() -> void:
	sprite.offset.y = min(0.0, -_height)


func _set_rotation(_new_dir : Vector2, _delta_vert : float) -> void:
	"""
		x+ = y+ 2d
		y+ = h+ 2d
		z+ = x- 2d
	"""
	
	var dir = Vector3(
		_new_dir.y,
		_delta_vert,
		-_new_dir.x
	).normalized() * 1000.0

	projectile.look_at(dir)

### SIGNAL RESPONSES ###
