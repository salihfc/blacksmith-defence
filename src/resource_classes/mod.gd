tool
extends Resource
class_name Mod
func get_base(): return "Resource"
func get_class(): return "Mod"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
	Mod gives interesting behaviours to units, e.g:
		[-] Triggered Effects
			[+] Berserk: Upon reaching low health -> double atk speed
			[+] Martyr: Upon reaching low health -> ....
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

