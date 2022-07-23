extends Control
# TODO:
#		[+] Integrate CraftingMenu
#		[+] Update Unit List to have be a list of crafted/craftable unit recipes
#		- Add option to hide uncraftable recipes

### SIGNAL ###
signal material_used(mat, count)

### ENUM ###
### CONST ###
# Prefabs
### EXPORT ###
export(PackedScene) var P_UnitRecipeView
#export(Texture) var mouse_normal_cursor
#export(Texture) var mouse_pressed_cursor

"""
	NOTE:
	Only export NodePaths when the scene structure is deep to prevent
	very long, ugly looking paths after '$'
"""
export(NodePath) var NP_Battle
export(NodePath) var NP_MaterialList
export(NodePath) var NP_UnitRecipeList
export(NodePath) var NP_DebugWindow
export(NodePath) var NP_CraftingMenu
export(NodePath) var NP_CraftingPopupPanel
export(NodePath) var NP_StartButton
export(NodePath) var NP_CraftButton
export(NodePath) var NP_BaseHealthBar

export(NodePath) var NP_WaveCounter

export(NodePath) var NP_UnitInfoPopupPanel
export(NodePath) var NP_UnitInfoDisplay

export(NodePath) var NP_ExitConfirmationDialog

export(Resource) var unit_data_pool = null
export(Resource) var player_base = null

### PUBLIC VAR ###
var player_material_storage = MaterialStorage.new()

### PRIVATE VAR ###
var _cached_recipes = [
	UnitRecipe.new(
		preload("res://tres/units/player_units/Duelist.tres"),
		MaterialStorage.new()\
			.add_material(preload("res://tres/materials/material_fire_rune.tres"), 1)\
			.add_material(preload("res://tres/materials/material_earth_rune.tres"), 1)\
			.add_material(preload("res://tres/materials/material_copper.tres"), 1)\
#			.add_material(preload("res://tres/materials/material_water_rune.tres"), 1)\
	),

	UnitRecipe.new(
		preload("res://tres/units/player_units/Arcanist.tres"),
		MaterialStorage.new().add_material(preload("res://tres/materials/material_fire_rune.tres"), 1)
	),
]

### ONREADY VAR ###
onready var battle = get_node(NP_Battle)
onready var materialList = get_node(NP_MaterialList)
onready var unitRecipeList = get_node(NP_UnitRecipeList)
onready var debugWindow = get_node(NP_DebugWindow) as DebugWindow
onready var craftingMenu = get_node(NP_CraftingMenu)
onready var craftingPopup = get_node(NP_CraftingPopupPanel) as PopupPanel
onready var startWaveButton = get_node(NP_StartButton)
onready var craftButton = get_node(NP_CraftButton)
onready var baseHealthBar = get_node(NP_BaseHealthBar)

onready var unitInfoPopupPanel = get_node(NP_UnitInfoPopupPanel) as PopupPanel
onready var unitInfoDisplay = get_node(NP_UnitInfoDisplay) as UnitInfoDisplay
onready var exitConfirmationDialog = get_node(NP_ExitConfirmationDialog) as ConfirmationDialog

onready var waveCounter = get_node(NP_WaveCounter) as WaveCounter

### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT:
#			if event.pressed:
#				Input.set_custom_mouse_cursor(mouse_pressed_cursor)
#			else:
#				Input.set_custom_mouse_cursor(mouse_normal_cursor)

	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_QUOTELEFT: # Toggle DebugWindow
				debugWindow.visible = !debugWindow.visible

			KEY_SPACE: # Wave start shortcut
				_on_wave_start_button_pressed()

			KEY_P: # Pause with P
				LOG.pr(LOG.LOG_TYPE.INTERNAL, "PAUSED")
				_pause_battle()

			KEY_A: # Toggle Circles with A
				CONFIG.SHOW_RANGE_CIRCLES = not CONFIG.SHOW_RANGE_CIRCLES

			KEY_ESCAPE:
				# Game scene overwrites the effect of ESCAPE KEY
				# To prevent SceneManager::_unhandled_input from processing this input
				# mark it handled
				get_tree().set_input_as_handled()
				#

				if craftingPopup.visible:
					_on_crafting_cancelled()
				else:
					LOG.pr(LOG.LOG_TYPE.INTERNAL, "Confirm Exit?")
					_pause_battle()
					exitConfirmationDialog.popup_centered()


func _ready():
	GROUP.set_global(GROUP.GAME, self)
	GROUP.set_global(GROUP.PLAYER_MATS, player_material_storage)
#	Input.set_custom_mouse_cursor(mouse_normal_cursor)
	# Init Player Base
	assert(player_base)
	player_base.init()

	SIGNAL.bind_multi([
		[player_base, "player_main_base_destroyed", self, "_on_player_main_base_destroyed"],
		[player_base, "hp_updated", baseHealthBar, "_on_value_updated"],

		[startWaveButton, "pressed", self, "_on_wave_start_button_pressed"],
		[craftButton, "pressed", self, "_on_CraftButton_pressed"],
		[exitConfirmationDialog, "confirmed", self, "_go_to_main_menu"],
		[exitConfirmationDialog, "popup_hide", self, "_pause_battle"],

		[battle, "wave_started", waveCounter, "set_value"],

		[battle, "base_damaged", player_base, "take_damage"],

		[battle, "material_collected", player_material_storage, "add_material"],
		[self, "material_used", player_material_storage, "use_material"],

		[player_material_storage, "changed", materialList, "reinit", [player_material_storage]]
	])

	SIGNAL.bind_bulk(
		battle, self,
		[
			["unit_selected", "_on_unit_selected"],
			["unit_spawned", "_on_unit_spawned"],
			["wave_completed", "_on_wave_completed"],
		]
	)

	SIGNAL.bind_bulk(
		craftingMenu, self,
		[
			["unit_created", "_on_unit_created"],
			["crafting_cancelled", "_on_crafting_cancelled"]
		]
	)

	for item in unit_data_pool.get_items():
		_cached_recipes.append(
			UnitRecipe.new(item)
		)

	_update_recipe_list()


### PUBLIC FUNCTIONS ###
func is_any_popup_visible() -> bool:
	return UTILS.any([
			craftingPopup.visible,
			exitConfirmationDialog.visible,
	])


### PRIVATE FUNCTIONS ###
func _go_to_main_menu() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	scene_manager.change_scene(scene_manager.SCENE.MAIN_MENU)


func _update_recipe_list() -> void:
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


func _pause_battle() -> void:
	battle.paused = not battle.paused
	UTILS.pause_node(battle, not battle.paused)

### SIGNAL RESPONSES ###
func _on_recipe_selected(unit_recipe : UnitRecipe) -> void:
	assert(unit_recipe)
	LOG.pr(LOG.LOG_TYPE.INPUT,\
		"UNIT_VIEW PRESSED WITH [%s] unit_total[%s]\nstorage[%s]"\
		% [unit_recipe, unit_recipe.total_cost(), player_material_storage])

	if player_material_storage.covers_cost(unit_recipe.total_cost()):
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
	unitInfoDisplay.init_from_unit(unit)
	unitInfoPopupPanel.popup()

	if not unit.is_connected("info_updated", unitInfoDisplay, "_on_info_updated"):
		SIGNAL.bind(
			unit, "info_updated",
			unitInfoDisplay, "_on_info_updated",
			[unit])


func _on_wave_start_button_pressed() -> void:
	battle.start_next_wave()
	startWaveButton.hide()


func _on_wave_completed() -> void:
	startWaveButton.show()


func _on_player_main_base_destroyed() -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "PLAYER LOST")
	_pause_battle()


func _on_CraftButton_pressed() -> void:
	# Display Craft Menu
	craftingMenu.reinit(player_material_storage)
	_pause_battle()
	craftingPopup.popup()


func _on_unit_created(unit_recipe) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "UNIT WITH RECIPE CREATED [%s]" % [unit_recipe])
	craftingPopup.hide()
	materialList.reinit(craftingMenu.recover_mat_from_slots().get_storage())
	_pause_battle()
	_cached_recipes.append(unit_recipe)
	_update_recipe_list()


func _on_crafting_cancelled() -> void:
	LOG.pr(LOG.LOG_TYPE.INPUT, "CRAFTING CANCELLED")
	craftingPopup.hide()
	_pause_battle()
	materialList.reinit(craftingMenu.recover_mat_from_slots().get_storage())
