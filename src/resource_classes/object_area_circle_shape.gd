extends ObjectArea
class_name ObjectAreaCircleShape
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(NodePath) var NP_collision_shape

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var collision_shape = get_node(NP_collision_shape) as CollisionShape2D

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_radius() -> float:
	return collision_shape.shape.radius * min(scale.x, scale.y)


func set_radius(new_radius : float) -> void:
	collision_shape.shape.set_deferred("radius", new_radius)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

