extends Node2D

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(bool) var auto_free = true
export(float) var destroy_after = 4.0
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		$Timer, "timeout",
		self, "queue_free"
	)

### PUBLIC FUNCTIONS ###
func emit(emit := true) -> void:
	$Particles2D.emitting = emit
	
	if auto_free:
		$Timer.start(destroy_after)
	else:
		$Timer.start(450)


func is_emitting() -> bool:
	return $Particles2D.emitting
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
