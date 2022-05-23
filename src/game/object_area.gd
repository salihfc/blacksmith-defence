extends Area2D
class_name ObjectArea

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(NodePath) var owner_path = null
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var collision_shape = $CollisionShape2D as CollisionShape2D

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###]
func get_owner():
	return get_node_or_null(owner_path)


func set_radius(new_radius : float) -> void:
	collision_shape.shape.radius = new_radius

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
