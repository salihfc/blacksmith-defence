extends Control
#TODO: - Integrate CraftingMenu
#		- Update Unit List to have be a list of crafted/craftable unit recipes
#		- Add option to hide uncraftable recipes

### SIGNAL ###
signal material_used(mat, count)

### ENUM ###
### CONST ###
# Prefabs
### EXPORT ###
export(PackedScene) var P_UnitRecipeView

"""
	NOTE:
	Only export NodePaths when the scene structure has a high depth to prevent
	very long, ugly looking paths after '$'
"""
export(NodePath) var NP_Battle
export(NodePath) var NP_MaterialList
export(NodePath) var NP_UnitRecipeList
export(NodePath) var NP_DebugWindow
export(NodePath) var NP_CraftingMenu
export(NodePath) var NP_PopupPanel
export(NodePath) var NP_StartButton
export(NodePath) var NP_CraftButton
export(NodePath) var NP_BaseHealthBar

export(Resource) var unit_data_pool = null
export(Resource) var player_base = null

### PUBLIC VAR ###
### PRIVATE VAR ###
var _cached_recipes = [
	UnitRecipe.new(
		load("res://tres/units/player_units/sword_unit_data.tres"),
		MaterialStorage.new(
			{
				MaterialData.new(MaterialData.TYPE.COPPER) : 2,
			}
		)
	)
]

### ONREADY VAR ###
onready var battle = get_node(NP_Battle)
onready var materialList = get_node(NP_MaterialList)
onready var unitRecipeList = get_node(NP_UnitRecipeList)
onready var debugWindow = get_node(NP_DebugWindow) as DebugWindow
onready var craftingMenu = get_node(NP_CraftingMenu)
onready var popupPanel = get_node(NP_PopupPanel) as PopupPanel
onready var startWaveButton = get_node(NP_StartButton)
onready var craftButton = get_node(NP_CraftButton)
onready var baseHealthBar = get_node(NP_BaseHealthBar)

### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):
	if event is InputEventKey and event.pressed:
#		LOG.pr(LOG.LOG_TYPE.INTERNAL, "(%s) pressed" % [event.scancode])
		if event.scancode == KEY_QUOTELEFT: # Toggle DebugWindow
			debugWindow.visible = !debugWindow.visible

		if event.scancode == KEY_SPACE: # Wave start shortcut
			_on_wave_start_button_pressed()

		if event.scancode == KEY_P: # Pause with P
			LOG.pr(LOG.LOG_TYPE.INTERNAL, "PAUSED")
			battle.paused = not battle.paused
			UTILS.pause_node(battle, not battle.paused)

		if event.scancode == KEY_A: # Toggle Circles with A
			CONFIG.SHOW_RANGE_CIRCLES = not CONFIG.SHOW_RANGE_CIRCLES


func _ready():
	assert(player_base)
	# Init Player Base
	player_base.init()
	SIGNAL.bind(
		player_base, "player_main_base_destroyed",
		self, "_on_player_main_base_destroyed"
	)

	SIGNAL.bind(
		player_base, "hp_updated",
		baseHealthBar, "set_hp_value"
	)

	SIGNAL.bind(
		startWaveButton, "pressed",
		self, "_on_wave_start_button_pressed"
	)

	SIGNAL.bind(
		craftButton, "pressed",
		self, "_on_CraftButton_pressed"
	)

	SIGNAL.bind_bulk(
		battle, self,
		[
			["unit_selected", "_on_unit_selected"],
			["unit_spawned", "_on_unit_spawned"],
			["wave_completed", "_on_wave_completed"],
		]
	)

	SIGNAL.bind(
		battle, "base_damaged",
		player_base, "take_damage"
	)

	SIGNAL.bind(
		battle, "material_collected",
		materialList, "_on_material_collected"
	)

	SIGNAL.bind(
		self, "material_used",
		materialList, "_on_material_used"
	)

	SIGNAL.bind_bulk(
		craftingMenu, self,
		[
			["unit_created", "_on_unit_created"],
			["crafting_cancelled", "_on_crafting_cancelled"]
		]
	)


	_update_recipe_list_view()

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
func _update_recipe_list_view() -> void:
	UTILS.clear_children(unitRecipeList)

	for recipe in _cached_recipes:
		assert(recipe is UnitRecipe)
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "recipe:\n[%s]" % [recipe])

		var new_recipe_view = P_UnitRecipeView.instance()
		unitRecipeList.add_child(new_recipe_view)
		new_recipe_view.set_data(recipe)

		SIGNAL.bind(
			new_recipe_view, "recipe_selected",
			self, "_on_recipe_selected",
			[recipe]
		)

### SIGNAL RESPONSES ###
func _on_recipe_selected(unit_recipe : UnitRecipe) -> void:
	assert(unit_recipe)
	LOG.pr(LOG.LOG_TYPE.INPUT, "UNIT_VIEW PRESSED WITH [%s] unit_total[%s]\nstorage[%s]" % [unit_recipe, unit_recipe.total_cost(), materialList.get_storage()])
	if materialList.get_storage().covers_cost(unit_recipe.total_cost()):
		battle.set_dragged_item(unit_recipe)
	else:
		LOG.pr(LOG.LOG_TYPE.INPUT, "RECIPE CANNOT BE AFFORDED [%s] \n [%s]" % [unit_recipe, unit_recipe.total_cost()])


func _on_unit_spawned(unit_recipe : UnitRecipe):
	# Spend the material cost of the unit
	var recipe_mat_storage = unit_recipe.total_cost()
	for mat in recipe_mat_storage.get_materials():
		var count = recipe_mat_storage.get_material_count(mat)
		emit_signal("material_used", mat, count)


func _on_unit_selected(unit) -> void:
	debugWindow.display_unit(unit)


func _on_wave_start_button_pressed() -> void:
	battle.start_next_wave()
	startWaveButton.hide()


func _on_wave_completed() -> void:
	startWaveButton.show()


func _on_player_main_base_destroyed() -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "PLAYER LOST")


func _on_CraftButton_pressed() -> void:
	# Display Craft Menu
	craftingMenu.reinit(materialList.get_storage())
	popupPanel.popup()


func _on_unit_created(unit_recipe) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "UNIT WITH RECIPE CREATED [%s]" % [unit_recipe])
	popupPanel.hide()
	materialList.reinit(craftingMenu.get_storage())

	_cached_recipes.append(unit_recipe)
	_update_recipe_list_view()


func _on_crafting_cancelled() -> void:
	LOG.pr(LOG.LOG_TYPE.INPUT, "CRAFTING CANCELLED")
	popupPanel.hide()
	materialList.reinit(craftingMenu.recover_from_slots().get_storage())
