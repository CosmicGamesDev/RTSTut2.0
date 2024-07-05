extends Node2D

@onready var house_build_mode = preload("res://house_build_mode.tscn")
@onready var house_scene = preload("res://house.tscn")
var current_build_scene = Node2D.new()

var is_building = false


func _input(event):
	if event.is_action_pressed("Build"):
		is_building = true
		var house_overlay = house_build_mode.instantiate()
		get_tree().get_first_node_in_group("building_layer").add_child(house_overlay)
		current_build_scene = house_overlay
	if event.is_action_pressed("click") and is_building:
		var house = house_scene.instantiate()
		get_tree().get_first_node_in_group("building_layer").add_child(house)
		house.global_position = get_global_mouse_position()

func _process(delta):
	current_build_scene.global_position = get_global_mouse_position()
