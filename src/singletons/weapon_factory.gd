extends Node

"""

"""

### SIGNAL ###


### ENUM ###
enum WEAPON {
	SWORD,
	RAPIER
}

### CONST ###
const WEAPONS = {
	WEAPON.SWORD : preload("res://src/game/player_units/sword.tscn"),
	WEAPON.RAPIER : preload("res://src/game/player_units/rapier.tscn"),
}

### EXPORT ###


### PUBLIC VAR ###
func create_weapon(weapon):
	return WEAPONS[weapon.get_id()].instance()
	

### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
