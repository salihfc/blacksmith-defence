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
onready var timer = $Timer as Timer
onready var particles = $Particles2D as Particles2D

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	SIGNAL.bind(
		timer, "timeout",
		self, "queue_free"
	)

### PUBLIC FUNCTIONS ###
func emit(emit := true) -> void:
	particles.restart()
	particles.emitting = emit

	if auto_free:
		timer.start(destroy_after)
	else:
		timer.start(450)


func is_emitting() -> bool:
	return particles.emitting

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
