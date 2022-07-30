extends Node
class_name GroupManager
"""
"""
### SIGNAL ###
### ENUM ###
enum {
	GAME,
	BATTLE_WORLD,

	PLAYER_MATS,
	SCENE_MANAGER,

	COUNT,
}

### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _ref_dict = {}

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_global(id, object) -> void:
	if object is Node:
		object.add_to_group(str(id))
	else:
		_ref_dict[str(id)] = weakref(object)


func get_global(id):
	var nodes = get_tree().get_nodes_in_group(str(id))
	if nodes.size() == 1:
		return nodes[0]
	else:
		var ref = _ref_dict.get(str(id))
		if ref:
			return ref.get_ref()
		return null

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

