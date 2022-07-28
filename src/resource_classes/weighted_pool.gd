tool
extends Resource
class_name WeightedPool
func get_base(): return "Resource"
func get_class(): return "WeightedPool"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
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
func _init(_items = {}) -> void:
	items = _items.duplicate()

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
