extends MarginContainer
#extends PanelContainer
"""
"""
### SIGNAL ###
signal recipe_selected()

### ENUM ###
### CONST ###
const P_MaterialView = preload("res://src/ui/material_view.tscn")

### EXPORT ###
export(NodePath) var NP_UnitTexture
export(NodePath) var NP_BaseCostList
export(NodePath) var NP_EnhanceCostList
export(NodePath) var NP_Button
export(NodePath) var NP_UnitRecipeViewPanel

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var unitTexture = get_node(NP_UnitTexture) as TextureRect
onready var button = get_node(NP_Button) as Button
onready var baseCostList = get_node(NP_BaseCostList) as HBoxContainer
onready var enhanceCostList = get_node(NP_EnhanceCostList)
onready var unitRecipeViewPanel = get_node(NP_UnitRecipeViewPanel)

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	button.add_to_group("ui_button")

	SIGNAL.bind(
		button, "pressed",
		self, "_on_TextureButton_pressed"
	)


### PUBLIC FUNCTIONS ###
func set_data(unit_recipe : UnitRecipe) -> void:
	var unit_data = unit_recipe.base_unit
	var enhance_cost = unit_recipe.enhance_cost
#	unitTexture.texture = unit_data.get_view_texture()
	unitTexture.texture = unit_data.weapon.texture

	if unit_data.cost:
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "XXXXXXXXXXXXXXXXXXXXXXXXXXX :")
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "UNIT_DATA: (%s)" % [unit_data])
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "COST: (%s)" % [unit_data.cost])
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "MATS: (%s)" % [unit_data.cost.get_materials()])

		for mat in unit_data.cost.get_materials():
			assert(mat != null)
			var count = unit_data.cost.get_material_count(mat)
			LOG.pr(LOG.LOG_TYPE.INTERNAL, "(%s) >> (%s)" % [mat, count])

			var material_view = P_MaterialView.instance()
			baseCostList.add_child(material_view)
			material_view.set_data(mat, count)

		LOG.pr(LOG.LOG_TYPE.INTERNAL, "XXXXXXXXXXXXXXXXXXXXXXXXXXX :")

	if enhance_cost:
		for mat in enhance_cost.get_materials():
			var count = enhance_cost.get_material_count(mat)
			var material_view = P_MaterialView.instance()
			enhanceCostList.add_child(material_view)
			material_view.set_data(mat, count)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###


func _on_TextureButton_pressed() -> void:
	emit_signal("recipe_selected")
