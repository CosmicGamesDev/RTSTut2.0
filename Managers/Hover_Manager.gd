extends Node2D

var hovered_items = []
var hover_first := Node2D.new()

func add_hover(item):
	hovered_items.push_back(item)
	if hovered_items.size() > 0:
		hover_first = hovered_items[0]
	if hover_first == item:
		item.show_outline()

func remover_hover(item):
	hovered_items.erase(item)
	item.unshow_outline()
	if hovered_items.size() > 0:
		hover_first = hovered_items[0]
		hover_first.show_outline()
