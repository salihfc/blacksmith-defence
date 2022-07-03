extends Node
class_name SceneManager
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
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_global(id):
	var nodes = get_tree().get_nodes_in_group(str(id))
	assert(nodes.size() == 1)
	return nodes[0]

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

