extends Node


func _ready() -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "UTILS")


func clear_children(node : Node) -> void:
	var children = node.get_children()
	for child in children:
		node.remove_child(child)
		child.queue_free()


func get_parents(objects : Array) -> Array:
	var parents = []
	for obj in objects:
		parents.append(obj.get_parent())
	return parents


func get_owners(objects : Array) -> Array:
	var owners = []
	for obj in objects:
		owners.append(obj.get_owner())
	return owners


func bind(
		source_node : Object, signal_name : String,
		target_node : Object, method_name : String,
		binds := []) -> void:

	var err = source_node.connect(signal_name, target_node, method_name, binds)
	if err != OK:
		LOG.err("CANNOT BIND SIGNAL: (%s:%s) -> (%s:%s)" %\
				[source_node, signal_name, target_node, method_name])
	else:
		LOG.pr(LOG.LOG_TYPE.SIGNAL, "Bind Signal: (%s:%s) -> (%s:%s)" %\
				[source_node, signal_name, target_node, method_name])


func unbind(
		source_node : Object, signal_name : String,
		target_node : Object, method_name : String) -> void:

	if source_node.is_connected(signal_name, target_node, method_name):
		source_node.disconnect(signal_name, target_node, method_name)
		LOG.pr(LOG.LOG_TYPE.SIGNAL, "UNbind Signal: (%s:%s) -> (%s:%s)" %\
				[source_node, signal_name, target_node, method_name])


var relays = {}

func bind_relay(
		source_node : Object, signal_name : String,
		target_node : Object, repeated_signal_name_list) -> void:

	if repeated_signal_name_list is String:
		repeated_signal_name_list = [repeated_signal_name_list]

	var source_weakref = _find_relay_node_weakref(source_node)
	if source_weakref == null:
		source_weakref = weakref(source_node)
		relays[source_weakref] = {}

	var err = source_node.connect(signal_name, self, "_relay_helper", [source_weakref, signal_name])
	if err != OK:
		LOG.err("CANNOT BIND RELAY: (%s:%s) -> (%s:%s)" %\
				[source_node, signal_name, target_node, repeated_signal_name_list])
	else:
		LOG.pr(LOG.LOG_TYPE.SIGNAL, "Bind Relay: (%s:%s) -> (%s:%s)" %\
				[source_node, signal_name, target_node, repeated_signal_name_list])

		var target_weakref = _find_target_node_weakref(target_node, relays[source_weakref])
		if target_weakref == null:
			target_weakref = weakref(target_node)

		relays[source_weakref][target_weakref] = repeated_signal_name_list



func _find_target_node_weakref(target_node : Object, dict):
	for _weakref in dict.keys():
		if _weakref.get_ref() == target_node:
			return _weakref
	return null

func _find_relay_node_weakref(emitter_node : Object):
	for emitter_weakref in relays.keys():
		if emitter_weakref.get_ref() == emitter_node:
			return emitter_weakref
	return null


func _relay_helper(emitter_node : Object, signal_name : String) -> void:
	var node_weakref = _find_relay_node_weakref(emitter_node)
	if node_weakref:
		var emitter_signal_relays = relays.get(signal_name)
		if emitter_signal_relays:
			for repeater_node in emitter_signal_relays.keys():
				var repeated_signal_list = emitter_signal_relays.get(repeater_node)
				for repeated_signal_name in repeated_signal_list:
					repeater_node.emit(repeated_signal_name)


func bind_bulk(
		source_node : Object, target_node : Object,
		signal_method_bind_arr : Array = []) -> void:

	for signal_method_bind in signal_method_bind_arr:
		var signal_name = signal_method_bind[0]
		var method_name = signal_method_bind[1]
		var binds = []
		if signal_method_bind.size() > 2:
			binds = signal_method_bind[2]
		bind(source_node, signal_name, target_node, method_name, binds)


# pause_node: for debugging purposes
func pause_node(node : Node, active = false) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "Pausing (%s) [%s]" % [node, active])
	Engine.time_scale = 1.0 if active else 0.0


func eval(expression_string, param_names, param_values):
	var expression = Expression.new()
	expression.parse(expression_string, param_names)
	var result = expression.execute(param_values)
	if result:
		return result
	return -1


func clamp01(value):
	return clamp(value, 0.0, 1.0)


func angle_to_vec2(theta) -> Vector2:
	return Vector2(cos(theta), sin(theta)).normalized()


func random_unit_vec2() -> Vector2:
	var theta = rand_range(0, 2 * PI)
	return angle_to_vec2(theta)


func check(p : float) -> bool:
	return randf() <= p


func get_random_subset(set : Array, ct : int) -> Array:
	set.shuffle()
	return set.slice(0, ct - 1)


func get_random_from(set : Array):
	return get_random_subset(set, 1)[0]


func get_closest_node(node : Node2D, other_nodes : Array):
	if node in other_nodes:
		other_nodes.erase(node)

	var closest = null
	var min_dist = INF
	for other_node in other_nodes:
		var dist = node.global_position.distance_to(other_node.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = other_node
	return closest


func flatten_array(arr : Array):
	var new_arr = []
	for item in arr:
		if item is Array:
			new_arr.append_array(flatten_array(item))
		new_arr.append(item)
	return new_arr


func get_enum_string_from_id(enum_ref, id) -> String:
	return enum_ref.keys()[id]


func vec2_to_int_arr(vec2 : Vector2) -> Array:
	return [int(vec2.x), int(vec2.y)]
