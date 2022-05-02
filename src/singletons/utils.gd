extends Node


func _ready() -> void:
	LOG.pr(3, "READY", "UTILS")


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
		LOG.pr(3, "Bind Signal: (%s:%s) -> (%s:%s)" %\
				[source_node, signal_name, target_node, method_name])


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
