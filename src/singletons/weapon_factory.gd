extends Node

"""

"""

### SIGNAL ###


### ENUM ###
enum WEAPON {
	SWORD,
}

### CONST ###
const WEAPONS = {
	WEAPON.SWORD : preload("res://src/game/player_units/sword.tscn"),
}

### EXPORT ###


### PUBLIC VAR ###
func create_weapon(weapon):
	return WEAPONS[weapon].instance()
	

### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
