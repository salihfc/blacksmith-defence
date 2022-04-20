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
var _enemies_in_range = {}
var _damage := 0.0
var _item_hp := 20.0
var _attack_cd = 4.0

### ONREADY VAR ###
onready var weaponSlot = $WeaponSlot as Node2D
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var attackTimer = $AttackTimer as Timer

### VIRTUAL FUNCTIONS (_init ...) ###

func _ready():
	add_to_group("player_unit")

### PUBLIC FUNCTIONS ###
func give_item(_item) -> void:
	_damage = _item.base_damage
	var new_weapon = WEAPON_FACTORY.create_weapon(_item.id)
	weaponSlot.add_child(new_weapon)


# The damage dealt to the item rather than unit
# Item breaks if it dies, Unit holding it runs off to the base
# TODO
func take_damage(damage : float) -> void:
	_item_hp -= damage
	
	if _item_hp <= 0.0:
		queue_free()


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
	for enemy in _enemies_in_range:
		enemy.take_damage(_damage)
	

### SIGNAL RESPONSES ###

func _on_AttackRange_area_entered(area):
	var enemy = area.get_parent()
	_enemies_in_range[enemy] = true
	
	if animPlayer.current_animation == "idle" or animPlayer.current_animation == "walk":
		animPlayer.play("attack")


func _on_AttackRange_area_exited(area):
	var enemy = area.get_parent()
	_enemies_in_range.erase(enemy)


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"attack":
			animPlayer.play("idle")
			attackTimer.start(_attack_cd)


func _on_AttackTimer_timeout():
	if _enemies_in_range.size():
		animPlayer.play("attack")
		attackTimer.start(_attack_cd)
