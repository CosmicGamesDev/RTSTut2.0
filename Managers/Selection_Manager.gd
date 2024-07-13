extends Node2D

var selected = []
signal deselect
signal do_action(pos: Vector2, state, interactive_object: Node2D)

var dragging = false
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new() 

enum ACTION_STATES {
	idle,
	move,
	gather,
	build
}

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# If the mouse was clicked and nothing is selected, start dragging
			if selected.size() == 0:
				dragging = true
				drag_start = event.position
		# If the mouse is released and is dragging, stop dragging
		elif dragging:
			dragging = false
			queue_redraw()
			var drag_end = event.position
			select_rect.extents = abs(drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = PhysicsShapeQueryParameters2D.new()
			query.shape = select_rect
			query.collision_mask = 2  # Units are on collision layer 2
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			var queried_selected = space.intersect_shape(query)
			for unit in queried_selected:
				selected.push_back(unit.collider)
				unit.collider.select()
	if event is InputEventMouseMotion and dragging:
		queue_redraw()

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color.YELLOW, false, 2.0)
		z_index = 1

func _input(event):
	if event.is_action_pressed("deselect"):
		for unit in selected:
			unit.unselect()
		selected = []
	if event.is_action_pressed("click") and HoverManager.hovered_items.size() == 0:
		emit_signal("do_action", get_global_mouse_position(), ACTION_STATES.move)
	if event.is_action_pressed("click") and HoverManager.hovered_items.size() > 0:
		emit_signal("do_action", HoverManager.hover_first.parent.action_location.global_position, ACTION_STATES.gather, HoverManager.hover_first.parent)

func emit_action(pos, state, interactive_obj):
	emit_signal("do_action", pos, state, interactive_obj)
