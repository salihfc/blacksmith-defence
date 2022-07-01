extends Resource
class_name Mod
"""
	Mod gives interesting behaviours to units, e.g:
		[-] Triggered Effects
			[-] Berserk: Upon reaching low health -> double atk speed
			[-] Martyr: Upon reaching low health -> ....
			[-] Thorns: Upon taking damage
			[-] Toxic: Upon death

		[-] Permanent Effects
			[-] Aura {stat}?: Give nearby allies start +x

"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Texture) var icon

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func apply_to(_unit):
	assert(0)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

