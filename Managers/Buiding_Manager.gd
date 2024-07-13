extends Node2D

@onready var build_mode_scene = preload("res://house_build_mode.tscn")
@onready var building_scene = preload("res://house.tscn")
var current_build_scene = Node2D.new()
var build_overlay = Node2D.new()
var is_building = false
var navigation_region : NavigationRegion2D
func _ready():
	navigation_region = get_tree().get_first_node_in_group("navigation")

func _input(event):
	if event.is_action_pressed("Build") and SelectionManager.selected.size() > 0:
		is_building = true
		build_overlay = build_mode_scene.instantiate()
		get_tree().get_first_node_in_group("building_layer").add_child(build_overlay)
		current_build_scene = build_overlay
	if event.is_action_pressed("click") and is_building and SelectionManager.selected.size() > 0:
		var building = building_scene.instantiate()
		navigation_region.add_child(building)
		building.global_position = get_global_mouse_position()
		navigation_region.bake_navigation_polygon()
		current_build_scene = Node2D.new()
		build_overlay.queue_free()
		SelectionManager.emit_action(building.global_position, SelectionManager.ACTION_STATES.build, building)
		is_building = false

func _process(delta):
	current_build_scene.global_position = get_global_mouse_position()
