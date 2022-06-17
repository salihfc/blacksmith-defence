extends TextureButton
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
const P_MaterialView = preload("res://src/ui/material_view.tscn")

### EXPORT ###
export(NodePath) var NP_UnitTexture
export(NodePath) var NP_BaseCostList
export(NodePath) var NP_EnhanceCostList

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var unitTexture = get_node(NP_UnitTexture) as TextureRect
onready var baseCostList = get_node(NP_BaseCostList) as HBoxContainer
onready var enhanceCostList = get_node(NP_EnhanceCostList) as HBoxContainer

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_data(unit_recipe : UnitRecipe) -> void:
	var unit_data = unit_recipe.base_unit
	var enhance_cost = unit_recipe.enhance_cost
	unitTexture.texture = unit_data.get_view_texture()

	if unit_data.cost:
		var materials = unit_data.cost.get_materials()
		for mat in materials.keys():
			var count = materials[mat]
			var material_view = P_MaterialView.instance()
			baseCostList.add_child(material_view)
			material_view.set_data(mat, count)

	if enhance_cost:
		var materials = enhance_cost.get_materials()
		for mat in materials:
			var count = materials[mat]
			var material_view = P_MaterialView.instance()
			enhanceCostList.add_child(material_view)
			material_view.set_data(mat, count)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
