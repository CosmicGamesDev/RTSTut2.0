extends Area2D

@export var parent_interactive_obj : Node2D

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("gather_area") && area.parent_unit.current_interactive_obj == parent_interactive_obj:
		area.parent_unit.gather(parent_interactive_obj.gather_type)

