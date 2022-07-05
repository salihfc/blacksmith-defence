tool
extends Node2D
class_name ParticleArea
"""
"""
### SIGNAL ###
signal damage_frame_reached()
signal done()

### ENUM ###
### CONST ###
### EXPORT ###
export(float) var damage_frame_time
export(float) var duration

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var particles = $Particles as Node2D
onready var hitbox = $HitBox as ObjectArea
onready var timer = $Timer as Timer
onready var durationTimer = $DurationTimer as Timer

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	SIGNAL.bind(
		timer, "timeout",
		self, "_on_timeout"
	)

	SIGNAL.bind(
		durationTimer, "timeout",
		self, "_on_duration_timer_timeout"
	)

### PUBLIC FUNCTIONS ###
func activate():
	for particle in particles.get_children():
		particle.restart()
		particle.emitting = true
	timer.start(damage_frame_time)
	durationTimer.start(duration)


func get_units_inside():
	return hitbox.get_areas_inside()

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_timeout():
	emit_signal("damage_frame_reached")


func _on_duration_timer_timeout():
	emit_signal("done")
