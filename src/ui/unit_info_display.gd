extends Panel
class_name UnitInfoDisplay
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var unitNameLabel = $HBoxContainer/VBoxContainer/UnitNameLabel as Label
onready var unitPortrait = $HBoxContainer/VBoxContainer/UnitPortrait as TextureRect

onready var baseCostList = $HBoxContainer/VBoxContainer2/BaseCostList as MaterialList
onready var enhanceCostList = $HBoxContainer/VBoxContainer2/EnhanceCostList as MaterialList
onready var statList = $StatList as StatList

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func init_from_unit(unit : Unit) -> void:
	unitNameLabel.text = str(unit)
	unitPortrait.texture = unit.sprite.texture

	# Fix : Private member access!
	var base_cost_storage = unit._base_cost
	var enhance_cost_storage = unit._enhance_cost
	var unit_stats = unit._stats

	baseCostList.reinit(base_cost_storage)
	enhanceCostList.reinit(enhance_cost_storage)
	statList.display_stats(unit_stats)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_info_updated(_unit) -> void:
#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "UNIT INFO UPDATED [%s]" % [_unit])
	init_from_unit(_unit)
