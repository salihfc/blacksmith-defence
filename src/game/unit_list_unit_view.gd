extends TextureButton

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
const PrefabMaterialView = preload("res://src/ui/material_view.tscn")
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var unitTexture = $HBoxContainer/UnitTexture as TextureRect
onready var costList = $HBoxContainer/CostList as HBoxContainer
### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func set_data(unit_data : UnitData) -> void:
	unitTexture.texture = unit_data.get_view_texture()
	var materials = unit_data.cost.get_materials()
	for mat in materials.keys():
		var count = materials[mat]
		var material_view = PrefabMaterialView.instance()
		costList.add_child(material_view)
		material_view.set_data(mat, count)
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
