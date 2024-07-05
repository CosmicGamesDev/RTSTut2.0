extends Area2D

@export var parent : Node2D
@export var sprite : Sprite2D

func _ready():
	sprite.material = sprite.material.duplicate()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func show_outline():
	sprite.material.set_shader_parameter("thickness", 2)

func unshow_outline():
	sprite.material.set_shader_parameter("thickness", 0)

func _on_mouse_exited():
	HoverManager.remover_hover(self)


func _on_mouse_entered():
	HoverManager.add_hover(self)

