extends Control
class_name GameOverDialog
"""
"""
### SIGNAL ###
signal restart_requested()
signal main_menu_requested()

### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var wavesLabel = $Panel/MarginContainer/VBoxContainer/LabelWavesSurvived

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_waves_survived(wave_count : int):
	wavesLabel.text = str(wave_count)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_RestartButton_pressed() -> void:
	emit_signal("restart_requested")


func _on_MainMenuButton_pressed() -> void:
	emit_signal("main_menu_requested")
