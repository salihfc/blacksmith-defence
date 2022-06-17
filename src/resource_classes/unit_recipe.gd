extends Resource
class_name UnitRecipe
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var base_unit # UnitData
export(Resource) var enhance_cost # MaterialStorage

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(_unit : UnitData = null, _cost : MaterialStorage = null) -> void:
	base_unit = _unit
	enhance_cost = _cost

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
