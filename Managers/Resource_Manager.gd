extends Node

signal add_resource (amount)
signal subtract_resource (amount)

func add(amount):
	emit_signal("add_resource", amount)

func subtract(amount):
	emit_signal("subtract_resource", amount)
