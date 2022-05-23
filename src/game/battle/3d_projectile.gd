extends Spatial

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var pivot = $Pivot as Spatial
### VIRTUAL FUNCTIONS (_init ...) ###

func _ready():
	look_at(Vector3(0.0, 0.0, 0.0) * 100.0)


### PUBLIC FUNCTIONS ###
func look_at(dir : Vector3, up : Vector3 = Vector3.UP) -> void:
	if abs(dir.x) + abs(dir.z) == 0:
		pivot.rotation_degrees = Vector3.ZERO

	else:
		pivot.look_at(dir, up)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
