extends Resource
class_name WeightedPool
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
# [item : weight]
export(Dictionary) var items

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_items():
	return items.keys()


func get_random():
	var rand = rand_range(0.0, _total_weight())
	for item in items:
		var w = items[item]
		rand -= w

		if rand < 0.0:
			return item
	return items.keys.back()

### PRIVATE FUNCTIONS ###
func _total_weight():
	var t = 0
	for w in items.values():
		if w is float:
			t += w
		else:
			push_warning("Weighted pool: Weight is not float type [%s]" % [w])
	return t

### SIGNAL RESPONSES ###
