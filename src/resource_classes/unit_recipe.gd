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
var _total_cost

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _to_string() -> String:
	return str(base_unit) + " enh[" + str(enhance_cost) + "]"

func _init(_unit : UnitData = null, _cost : MaterialStorage = null) -> void:
	base_unit = _unit
	enhance_cost = _cost

	_total_cost = MaterialStorage.new()
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "total[%s]" % [_total_cost])
	assert(base_unit.cost)
	_total_cost.add_storage(base_unit.cost)
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "total[%s]" % [_total_cost])

	if enhance_cost:
		_total_cost.add_storage(enhance_cost)
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "total[%s]" % [_total_cost])


### PUBLIC FUNCTIONS ###
func total_cost():
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "total FUNC[%s]" % [_total_cost])
	return _total_cost

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
