extends Area2D

@export var time_to_build = 5.0
var builders = []
@export var parent_interactive_obj : Node2D
var disable = false

signal build_finished

func _ready():
	area_entered.connect(_on_area_entered)

func _process(delta):
	if builders.size() > 0:
		time_to_build -= builders.size()*delta
	if time_to_build <= 0 and !disable:
		for builder in builders:
			builder.parent_unit.stop()
		builders = []
		disable = true
		emit_signal("build_finished")

func _on_area_entered(area):
	if !disable && area.is_in_group("work_area") && area.parent_unit.current_interactive_obj == parent_interactive_obj:
		builders.push_back(area)
		area.parent_unit.build()


func _on_area_exited(area):
	if builders.has(area):
		builders.erase(area)
