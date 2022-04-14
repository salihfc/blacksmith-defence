extends Node2D

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
export(float) var attack_range = 100.0

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var weaponSlot = $WeaponSlot as Node2D

### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func give_item(_item) -> void:
	var new_weapon = WEAPON_FACTORY.create_weapon(_item.id)
	weaponSlot.add_child(new_weapon)


### PRIVATE FUNCTIONS ###
func _get_weapon():
	if weaponSlot.get_child_count():
		return weaponSlot.get_child(0)
	return null


func _play_weapon_anim() -> void:
	var weapon = _get_weapon()
	if weapon:
		weapon.swing()


func _deal_damage() -> void:
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in all_enemies:
		if global_position.distance_to(enemy.global_position):
			enemy.take_damage()
	

### SIGNAL RESPONSES ###
