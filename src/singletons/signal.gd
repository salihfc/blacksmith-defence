tool
extends Node
"""
	Global Signal Helper Functions
"""

var relays = {}


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


func bind_multi(connection_array : Array) -> void:
	for data in connection_array:
		assert(data.size() >= 4)
		var source_node = data[0]
		var signal_name = data[1]
		var target_node = data[2]
		var method_name = data[3]
		var binds = [] if data.size() == 4 else data[4]

		bind(source_node, signal_name, target_node, method_name, binds)


func unbind(
		source_node : Object, signal_name : String,
		target_node : Object, method_name : String) -> void:

	if source_node.is_connected(signal_name, target_node, method_name):
		source_node.disconnect(signal_name, target_node, method_name)
		LOG.pr(LOG.LOG_TYPE.SIGNAL, "UNbind Signal: (%s:%s) -> (%s:%s)" %\
				[source_node, signal_name, target_node, method_name])

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
