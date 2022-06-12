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
export(NodePath) var NP_AcceptButton
export(NodePath) var NP_DiscardButton

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var unitTexture = get_node(NP_UnitTexture) as TextureRect
onready var baseCostList = get_node(NP_BaseCostList) as HBoxContainer
onready var acceptButton = get_node(NP_AcceptButton) as TextureButton
onready var discardButton = get_node(NP_DiscardButton) as TextureButton

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	SIGNAL.bind(
		acceptButton, "pressed",
		self, "_on_accept_button_pressed"
	)

	SIGNAL.bind(
		discardButton, "pressed",
		self, "_on_discard_button_pressed"
	)

### PUBLIC FUNCTIONS ###
func set_data(unit_data : UnitData) -> void:
	unitTexture.texture = unit_data.get_view_texture()
	var materials = unit_data.cost.get_materials()
	for mat in materials.keys():
		var count = materials[mat]
		var material_view = P_MaterialView.instance()
		baseCostList.add_child(material_view)
		material_view.set_data(mat, count)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_accept_button_pressed():
	# TODO: EMPTY?
	pass

func _on_discard_button_pressed():
	# TODO: EMPTY?
	pass
