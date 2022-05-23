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
onready var unitTexture = $PanelContainer/HBoxContainer/UnitTexture as TextureRect
onready var baseCostList = $PanelContainer/HBoxContainer/CostList/BaseCostList as HBoxContainer
onready var acceptButton = $PanelContainer/HBoxContainer/Buttons/VBoxContainer/Accept as TextureButton
onready var discardButton = $PanelContainer/HBoxContainer/Buttons/VBoxContainer/Discard as TextureButton
### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	UTILS.bind(
		acceptButton, "pressed",
		self, "_on_accept_button_pressed"
	)

	UTILS.bind(
		discardButton, "pressed",
		self, "_on_discard_button_pressed"
	)


### PUBLIC FUNCTIONS ###
func set_data(unit_data : UnitData) -> void:
	unitTexture.texture = unit_data.get_view_texture()
	var materials = unit_data.cost.get_materials()
	for mat in materials.keys():
		var count = materials[mat]
		var material_view = PrefabMaterialView.instance()
		baseCostList.add_child(material_view)
		material_view.set_data(mat, count)
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###


func _on_accept_button_pressed():
	pass

func _on_discard_button_pressed():
	pass