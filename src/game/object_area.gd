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
func _ready() -> void:
	assert(owner_path != null)
	modulate = Color("4effffff")


### PUBLIC FUNCTIONS ###]
func get_owner():
	return get_node_or_null(owner_path)


func set_radius(new_radius : float) -> void:
	collision_shape.shape.radius = new_radius


func get_radius() -> float:
	return collision_shape.shape.radius * min(scale.x, scale.y)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
