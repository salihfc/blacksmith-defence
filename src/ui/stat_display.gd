extends HBoxContainer
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var statName = $StatName as Label
onready var statValue = $StatValue as Label

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func init(_name, _value) -> void:
	statName.text = str(_name)
	statValue.text = str(_value)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
