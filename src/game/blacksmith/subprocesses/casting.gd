extends Control

"""

"""

### SIGNAL ###
signal forge_completed(item, progress_amount)

### ENUM ###


### CONST ###
const SIM_TICK_PERIOD = 1.1
const MIN_PROGRESS_PER_TICK = 5
const MAX_PROGRESS_PER_TICK = 20

### EXPORT ###


### PUBLIC VAR ###
var _current_progress = 0
var _item = null

### PRIVATE VAR ###
### ONREADY VAR ###
onready var tickTimer = $TickTimer as Timer
onready var texture = $PanelContainer/HBoxContainer/MarginContainer/PanelContainer/TextureProgress as TextureProgress
onready var button = $PanelContainer/HBoxContainer/MarginContainer/PanelContainer/TextureProgress/Button as Button

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	texture.value = 0
	tickTimer.start(SIM_TICK_PERIOD)
	


### PUBLIC FUNCTIONS ###
func set_item(item) -> void:
	_item = item
	texture.texture_progress = item.texture


### PRIVATE FUNCTIONS ###
func _update_texture() -> void:
	texture.value = _current_progress


func _progress():
	var progress_amount = int(rand_range(MIN_PROGRESS_PER_TICK, MAX_PROGRESS_PER_TICK + 0.99))
	_current_progress += progress_amount
	LOG.pr(1, "progress [%s]" % [_current_progress])
	_update_texture()

### SIGNAL RESPONSES ###


func _on_TickTimer_timeout():
	if button.pressed:
		_progress()
	
	tickTimer.start(SIM_TICK_PERIOD)


func _on_CompleteButton_pressed():
	LOG.pr(1, "FORGED: [%s] %s " % [_current_progress, _item])
	emit_signal("forge_completed", _item, _current_progress)
